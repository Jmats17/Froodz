//
//  Group.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct Group : Codable {
    
    let documentId: String
    let groupName: String
    let code: String
    let creator: String
    let users: [String]
    let leaderboard: [String: Double]
    let startingAmt: Double
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case groupName
        case code
        case users
        case creator
        case leaderboard
        case startingAmt
    }
}

