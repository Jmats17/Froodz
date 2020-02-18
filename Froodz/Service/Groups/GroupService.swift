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

struct GroupService {
    
    static let user = User.current
    static let FBRef = Firestore.firestore().collection("Groups")

    static func addPointsToWinners(line: String, group : Group, singleAmount: Double, completion: @escaping (_ didSucceed: Bool) -> Void) {
        
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
            
            for winner in group.users {
                if retrievedLine.single.contains(winner.key) {
                    let groupRef = ref.collection("Groups").document(group.documentId)
                    let key = "users.\(winner.key)"
                    batch.updateData([
                        key : FieldValue.increment(singleAmount)
                    ], forDocument: groupRef)
                }
                
                if retrievedLine.doubleDown.contains(winner.key) {
                    let groupRef = ref.collection("Groups").document(group.documentId)
                    let key = "users.\(winner.key)"
                    let double = singleAmount * 2.0
                    batch.updateData([
                        key : FieldValue.increment(double)
                    ], forDocument: groupRef)
                }
            }
            GroupService.deleteData_PushToPastLines(group: group, line: retrievedLine, ref: ref, batch: batch, completion: completion)
        }
        
    }
    
    static func deductPointsToLosers(line: String, group : Group, singleAmount: Double, completion: @escaping (_ didSucceed: Bool) -> Void) {
        
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
            
            for loser in group.users {
                if retrievedLine.single.contains(loser.key) {
                    let group = ref.collection("Groups").document(group.documentId)
                    let key = "users.\(loser.key)"
                    batch.updateData([
                        key : FieldValue.increment(-singleAmount)
                    ], forDocument: group)
                }
                
                if retrievedLine.doubleDown.contains(loser.key) {
                    let group = ref.collection("Groups").document(group.documentId)
                    let key = "users.\(loser.key)"
                    let double = singleAmount * 2.0
                    batch.updateData([
                        key : FieldValue.increment(-double)
                    ], forDocument: group)
                }
            }
            GroupService.deleteData_PushToPastLines(group: group, line: retrievedLine, ref: ref, batch: batch, completion: completion)
        }
        
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
    
    //Creating new group to push to FB
    static func didCreateNewGroup(userID: String, groupName : String, didRegister: @escaping (Bool) -> Void) {
        var ref: DocumentReference? = nil
        ref = FBRef.addDocument(data: [
            "groupName" : groupName,
            "code": Helper.return_RandomGeneratedCode(),
            "users": [ User.current.username : 500.0 ]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                didRegister(false)
            } else {
                guard let id = ref?.documentID else {didRegister(false); return}
                UserService.addGroupTo_ActiveGroups(userID: userID, groupID: id)
                didRegister(true)
            }
        }
        
    }
    
    //Joining existing group as a user and pushing data to FB
    static func didJoinExistingGroup(userID: String, code: String,_ didJoin: @escaping (Bool) -> Void) {

        FBRef.whereField("code", isEqualTo: code).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                didJoin(false)
                return
            }

            guard let documents = snapshot?.documents else {
                didJoin(false)
                return
            }
            
            if documents.count > 0 {
                let group = try! FirestoreDecoder().decode(Group.self, from: documents[0].prepareForDecoding())
                if !group.users.keys.contains(User.current.username) {
                    FBRef.document(group.documentId).updateData([
                        "users" : [user.username : 500.0]
                    ]) { error in
                        if let err = error { print(err.localizedDescription) ; didJoin(false) ; return }
                        else {
                            UserService.addGroupTo_ActiveGroups(userID: userID, groupID: group.documentId)
                            didJoin(true)
                            return
                        }
                    }
                    
                }
            }
            
            didJoin(false)
            return
        }
    }
    
}
