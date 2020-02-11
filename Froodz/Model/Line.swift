//
//  Line.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import CodableFirebase

struct Line: Codable {
    
    let documentId: String?
    let lineName: String
    let type : String
    let numOnLine: Int
    let users : [String]?
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case lineName
        case type
        case numOnLine
        case users
    }
    
    enum Encodable: String, Codable {
        case lineName
        case type
        case numOnLine
    }
}
