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
    var active_groups : [String]
    var fcmToken : String?
    
    private static var _current: User?
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case username
        case fullName
        case active_groups
        case fcmToken
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let docData = try! FirestoreEncoder().encode(user)
            UserDefaults.standard.set(docData, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
        
    }
}
