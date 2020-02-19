//
//  Constants.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/13/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let fullName = "fullName"
        static let username = "username"
    }
    
    struct Color {
        static let placeholderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        static let primaryBlue = UIColor(red: 70/255, green: 171/255, blue: 242/255, alpha: 1.0)
        static let primaryBlackText = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        static let secondaryDarkBlue = UIColor(red: 55/255, green: 135/255, blue: 191/255, alpha: 1.0)

    }
}
