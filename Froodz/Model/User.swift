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


struct User : Codable {
    
    let documentId: String
    let name: String
    let active_groups : [String]
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case name
        case active_groups
    }
}
