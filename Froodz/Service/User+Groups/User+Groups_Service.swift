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
    
    static func return_ActiveGroups(userID: String, completion: @escaping ([Group]) -> ()) {
        UserService.return_UserActiveGroups(userID: userID) { (groups) in
            if groups.count > 0 {
                return UserGroups_Service.retrieveGroups_FromGroupsArr(groupIds: groups) { (groups) in
                    completion(groups)
                }
            }
        }
    }

    private static func retrieveGroups_FromGroupsArr(groupIds : [String], completion: @escaping ([Group]) -> Void) {
        
        FBRef.getDocuments { (documentSnapshot, error) in
            
            var groups = [Group]()
            
            if let err = error {
                print(err.localizedDescription)
                completion([])
                return
            }
            
            guard let snapshot = documentSnapshot else { completion([]); return }
            for document in snapshot.documents {
                
                if groupIds.contains(document.documentID) {
                    if let group = try? JSONDecoder().decode(Group.self, fromJSONObject: document.prepareForDecoding()) {
                        groups.append(group)
                    }
                }
            }
            
            completion(groups)
        }
        
    }
}
