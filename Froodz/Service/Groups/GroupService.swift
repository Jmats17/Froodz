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

struct GroupService {
    
    static let FBRef = Firestore.firestore().collection("Groups")
    
    //Creating new group to push to FB
    static func didCreateNewGroup(groupName : String, didRegister: @escaping (Bool) -> Void) {
        
        FBRef.addDocument(data: [
            "groupName" : groupName,
            "code": Helper.return_RandomGeneratedCode(),
            "users": FieldValue.arrayUnion([UIDevice.current.identifierForVendor!.uuidString])
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                didRegister(false)
            } else {
                print("Document added with ID: \(FBRef.document().documentID)")
                didRegister(true)
            }
        }
        
    }
    //Joining existing group as a user and pushing data to FB
    static func didJoinExistingGroup() {
        
    }
}
