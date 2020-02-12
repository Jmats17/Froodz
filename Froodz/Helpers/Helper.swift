//
//  Helper.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
    
    //Generate randomn code for new group
    static func return_RandomGeneratedCode() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
}
