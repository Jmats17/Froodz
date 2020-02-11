//
//  UserService.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/9/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import CodableFirebase

struct UserService {
    
    private static let FBUserRef = Firestore.firestore().collection("Users")
        .document(UIDevice.current.identifierForVendor!.uuidString)
    
    static func return_UserActiveGroups(completion : @escaping ([String]) -> Void) {
        
        FBUserRef.getDocument { (documentSnapshot, error) in
            
            if let err = error {
                completion([])
                print(err.localizedDescription)
                return
            }
            
            guard let snapshot = documentSnapshot else { completion([]); return }
                  
            let user = try! FirestoreDecoder().decode(User.self, from: snapshot.prepareForDecoding())
            completion(user.active_groups)
        }
    }
}
