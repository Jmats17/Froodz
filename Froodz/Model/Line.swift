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
    let numOnLine: Double
    let users : [String]
    let creator: String
    var single: [String]
    var doubleDown: [String]
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case lineName
        case numOnLine
        case users
        case creator
        case single
        case doubleDown
    }

}
