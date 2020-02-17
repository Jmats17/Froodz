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
    let numOnLine: Double
    let optionalSecondLine: Double?
    let users : [String]
    let creator: String
    let over: [String]
    let under: [String]
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case lineName
        case type
        case numOnLine
        case optionalSecondLine
        case users
        case creator
        case over
        case under
    }

}
