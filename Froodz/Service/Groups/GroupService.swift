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

    static func addPointsToWinners(line: Line, lineWinners: [String], group : Group, amountToWinners: Double, winningSide: String, completion: @escaping (_ didSucceed: Bool) -> Void) {
        
        let ref = Firestore.firestore()
        let batch = ref.batch()
        
        for winner in group.users {
            if lineWinners.contains(winner.key) {
                let group = ref.collection("Groups").document(group.documentId)
                let key = "users.\(winner.key)"
                batch.updateData([
                    key : FieldValue.increment(amountToWinners)
                ], forDocument: group)
            }
        }
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
    
    //Creating new group to push to FB
    static func didCreateNewGroup(userID: String, groupName : String, didRegister: @escaping (Bool) -> Void) {
        var ref: DocumentReference? = nil
        ref = FBRef.addDocument(data: [
            "groupName" : groupName,
            "code": Helper.return_RandomGeneratedCode(),
            "users": [ User.current.documentId : 0.0 ]
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
                if !group.users.keys.contains(user.documentId) {
                    FBRef.document(group.documentId).updateData([
                        "users" : FieldValue.arrayUnion([User.current.documentId])
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
