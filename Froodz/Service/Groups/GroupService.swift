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
    
    private static let FBUserRef = Firestore.firestore().collection("Users").document(User.current.documentId)
    static let user = User.current
    
    //Creating new group to push to FB
    static func didCreateNewGroup(userID: String, groupName : String, didRegister: @escaping (Bool) -> Void) {
        let FBRef = Firestore.firestore().collection("Groups")
        var ref: DocumentReference? = nil
        ref = FBRef.addDocument(data: [
            "groupName" : groupName,
            "code": Helper.return_RandomGeneratedCode(),
            "users": [ User.current.documentId : 0 ]
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
        let FBRef = Firestore.firestore().collection("Groups")

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
