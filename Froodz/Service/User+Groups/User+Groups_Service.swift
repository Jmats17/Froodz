//
//  User+Groups_Service.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct UserGroups_Service {
    
    private static let FBRef = Firestore.firestore().collection("Groups")
    
    //Get list of groups from Group snapshot and return as Group array
    static func retrieveGroups_FromGroupsArr(userID: String, completion: @escaping ([Group]) -> Void) {
        FBRef.whereField("users", arrayContains: userID).addSnapshotListener { (documentSnapshot, error) in
            var groups = [Group]()
            if let err = error {
                print(err.localizedDescription)
                completion([])
                return
            }
            
            guard let snapshot = documentSnapshot else { completion([]); return }
            for document in snapshot.documents {
                groups.append(CodableService.CodableGroup.getGroup(snapshot: document))
            }
            completion(groups)
        }
    }
}
