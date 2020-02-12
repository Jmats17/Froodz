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
    
    private static let FBUserRef = Firestore.firestore().collection("Users").document(UIDevice.current.identifierForVendor!.uuidString)

    //Creating new group to push to FB
    static func didCreateNewGroup(groupName : String, didRegister: @escaping (Bool) -> Void) {
        let FBRef = Firestore.firestore().collection("Groups")
        var ref: DocumentReference? = nil
        ref = FBRef.addDocument(data: [
            "groupName" : groupName,
            "code": Helper.return_RandomGeneratedCode(),
            "users": FieldValue.arrayUnion([UIDevice.current.identifierForVendor!.uuidString])
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                didRegister(false)
            } else {
                guard let id = ref?.documentID else {didRegister(false); return}
                UserService.addGroupTo_ActiveGroups(groupID: id)
                didRegister(true)
            }
        }
        
    }
    
    //Joining existing group as a user and pushing data to FB
    static func didJoinExistingGroup(code: String,_ didJoin: @escaping (Bool) -> Void) {
        let FBRef = Firestore.firestore().collection("Groups")

        FBRef.whereField("code", isEqualTo: code).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                didJoin(false)
                return
            }

            guard let document = snapshot?.documents[0] else { didJoin(false); return }
            let group = try! FirestoreDecoder().decode(Group.self, from: document.prepareForDecoding())
            if !group.users.contains(UIDevice.current.identifierForVendor!.uuidString) {
                FBRef.document(group.documentId).updateData([
                    "users" : FieldValue.arrayUnion([UIDevice.current.identifierForVendor!.uuidString])
                ]) { error in
                    if let err = error { print(err.localizedDescription) ; didJoin(false) ; return }
                    else {
                        UserService.addGroupTo_ActiveGroups(groupID: group.documentId)
                        didJoin(true)
                        return
                    }
                }
                
            }
            didJoin(false)
            return
        }
    }
    
}
