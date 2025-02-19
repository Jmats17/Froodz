//
//  GroupService.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import CodableFirebase
import FirebaseMessaging

struct GroupService {
    
    static let user = User.current
    static let FBRef = Firestore.firestore().collection("Groups")
    
    static func distributePoints_ToUsers(winningSide: String, line: String, group : Group, amount: Double, completion: @escaping (_ didSucceed: Bool) -> Void) {
        FBRef.document(group.documentId).collection("Lines").document(line).getDocument { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                completion(false)
                return
            }
            guard let snapshot = snapshot else { completion(false) ; return }
            let retrievedLine = try! FirestoreDecoder().decode(Line.self, from: snapshot.prepareForDecoding())
            let ref = Firestore.firestore()
            let batch = ref.batch()
            let groupRef = ref.collection("Groups").document(group.documentId)
            
            for winner in group.leaderboard {
                if winningSide == "Agreed" {
                    if retrievedLine.agreedUsers.contains(winner.key) {
                        assignValue(batch: batch, key: "leaderboard.\(winner.key)", amount: amount, groupRef: groupRef)
                    } else if retrievedLine.disagreedUsers.contains(winner.key) {
                        assignValue(batch: batch, key: "leaderboard.\(winner.key)", amount: -amount, groupRef: groupRef)
                    }
                }
                if winningSide == "Disagreed" {
                    if retrievedLine.agreedUsers.contains(winner.key) {
                        assignValue(batch: batch, key: "leaderboard.\(winner.key)", amount: -amount, groupRef: groupRef)
                    } else if retrievedLine.disagreedUsers.contains(winner.key) {
                        assignValue(batch: batch, key: "leaderboard.\(winner.key)", amount: amount, groupRef: groupRef)
                    }
                }
            }
            GroupService.deleteData_PushToPastLines(group: group, line: retrievedLine, ref: ref, batch: batch, completion: completion)
        }
    }
    
    static func assignValue(batch: WriteBatch, key: String, amount: Double, groupRef: DocumentReference) {
        batch.updateData([
            key : FieldValue.increment(amount)
        ], forDocument: groupRef)
    }
    
    static func deleteData_PushToPastLines(group: Group, line: Line, ref: Firestore, batch: WriteBatch, completion: @escaping (_ didSucceed: Bool) -> Void) {
        guard let lineID = line.documentId else { completion(false) ; return}
        let lineData = try! FirestoreEncoder().encode(line)

        let lineRef = ref.collection("Groups").document(group.documentId).collection("Lines").document(lineID)
        let pastLineRef = ref.collection("Groups").document(group.documentId).collection("Past Lines").document()
        
        batch.setData(lineData, forDocument: pastLineRef)
        batch.deleteDocument(lineRef)
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
                completion(false)
            } else {
                print("Batch write succeeded.")
                completion(true)
            }
        }
    }
    
    static func didReturn_RequestedGroup(groupID: String, completion: @escaping (Group?) -> Void) {
        FBRef.document(groupID).getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot else {completion(nil) ; return}
            
            let group = try! FirestoreDecoder().decode(Group.self, from: snapshot.prepareForDecoding())
            completion(group)
        }
    }
    
    static func deleteCurrentGroup(groupID: String, completion: @escaping (Bool) -> Void) {
        
        FBRef.document(groupID).delete { (error) in
            if let error = error { print(error.localizedDescription) ; completion(false) ; return }
            Firestore.firestore().collection("Users").whereField("active_groups", arrayContains: groupID).getDocuments { (snapshot, err) in
                if let error = err { print(error.localizedDescription) ; completion(false) ; return }
                guard let documents = snapshot?.documents else {completion(false) ; return }
                
                for document in documents {
                    var user = CodableService.CodableUser.getUser(snapshot: document)
                    user.active_groups.removeAll(where: { $0 == groupID })
                    Firestore.firestore().collection("Users").document(user.documentId).updateData(["active_groups" : user.active_groups])
                }
                completion(true)
                return
            }
            
        }
        
    }
    
    //Creating new group to push to FB
    static func didCreateNewGroup(userID: String, groupName : String, amount: Double, didRegister: @escaping (Bool) -> Void) {
        var ref: DocumentReference? = nil
        ref = FBRef.addDocument(data: [
            "groupName" : groupName,
            "code": Helper.return_RandomGeneratedCode(),
            "users": FieldValue.arrayUnion([user.documentId]),
            "leaderboard": [
                user.username : amount
            ],
            "creator": user.username,
            "startingAmt": amount
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                didRegister(false)
            } else {
                guard let id = ref?.documentID else {didRegister(false); return}
                UserService.addGroupTo_ActiveGroups(userID: userID, groupID: id)
                PushNotificationService.subscribeToGroup(group: id)
                didRegister(true)
            }
        }
    }

    //Joining existing group as a user and pushing data to FB
    static func didJoinExistingGroup(userID: String, code: String,_ didJoin: @escaping (Bool, String?) -> Void) {

        FBRef.whereField("code", isEqualTo: code).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                didJoin(false, nil)
                return
            }

            guard let documents = snapshot?.documents else {
                didJoin(false, nil)
                return
            }
            
            if documents.count > 0 {
                let group = try! FirestoreDecoder().decode(Group.self, from: documents[0].prepareForDecoding())
                if !group.users.contains(User.current.username) {
                    FBRef.document(group.documentId).updateData([
                        "leaderboard.\(user.username)" : group.startingAmt,
                        "users": FieldValue.arrayUnion([user.documentId])
                    ]) { error in
                        if let err = error { print(err.localizedDescription) ; didJoin(false, nil) ; return }
                        else {
                            UserService.addGroupTo_ActiveGroups(userID: userID, groupID: group.documentId)
                            PushNotificationService.subscribeToGroup(group: group.documentId)
                            didJoin(true, group.documentId)
                            return
                        }
                    }
                } else {didJoin(false, nil) ; return}
            } else {didJoin(false, nil) ; return}
        }
    }
    
}
