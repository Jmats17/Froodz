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
    
    //If there are groups, return List of User's Groups
    static func return_ActiveGroups(userID: String, completion: @escaping ([Group]) -> ()) {
        UserService.return_UserActiveGroupsIDS(userID: userID) { (groups) in
            if groups.count > 0 {
                return UserGroups_Service.retrieveGroups_FromGroupsArr(groupIds: groups) { (groups) in
                    completion(groups)
                }
            }
        }
    }

    //Get list of groups from Group snapshot and return as Group array
    private static func retrieveGroups_FromGroupsArr(groupIds : [String], completion: @escaping ([Group]) -> Void) {
        FBRef.addSnapshotListener { (documentSnapshot, error) in
            var groups = [Group]()
            if let err = error {
                print(err.localizedDescription)
                completion([])
                return
            }
            
            guard let snapshot = documentSnapshot else { completion([]); return }
            for document in snapshot.documents {
                if groupIds.contains(document.documentID) {
                    groups.append(CodableService.CodableGroup.getGroup(snapshot: document))
                }
            }
            completion(groups)
        }
        
    }
}
