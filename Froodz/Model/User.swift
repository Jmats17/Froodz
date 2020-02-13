//
//  User.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import CodableFirebase

struct User : Codable {
    
    let documentId: String
    let username: String
    let fullName: String
    let active_groups : [String]
    
    private static var _current: User?
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case username
        case fullName
        case active_groups
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let docData = try! FirestoreEncoder().encode(user)
            UserDefaults.standard.set(docData, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
        
    }
}
