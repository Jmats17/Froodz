//
//  LineService.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import CodableFirebase
import FirebaseFirestore

struct LineService {
    
    static func pushNewLine_ToGroup(lineName : String, amount : Int, groupID : String, type: String, completion: @escaping (Bool) -> Void) {
        
        let line = Line(documentId: nil, lineName: lineName, type: type, numOnLine: amount, users: nil)
        let lineData = try! FirestoreEncoder().encode(line)
        
        Firestore.firestore().collection("Groups").document(groupID).collection("Lines").addDocument(data: lineData) { error in
            if let error = error {
                completion(false)
                print("Error writing document: \(error.localizedDescription)")
            } else {
                completion(true)
                print("Document successfully written!")
            }
        }
    }
    
}
