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
    
    static let FBRef = Firestore.firestore().collection("Groups")
    
    static func pushNewLine_ToGroup(lineName : String, amount : Int, groupID : String, type: String, completion: @escaping (Bool) -> Void) {
        
        let line = Line(documentId: nil, lineName: lineName, type: type, numOnLine: amount, users: nil)
        let lineData = try! FirestoreEncoder().encode(line)
        
        FBRef.document(groupID).collection("Lines").addDocument(data: lineData) { error in
            if let error = error {
                completion(false)
                print("Error writing document: \(error.localizedDescription)")
            } else {
                completion(true)
                print("Document successfully written!")
            }
        }
    }
    
    static func retrieve_CurrentLines(groupID: String, completion: @escaping ([Line]) -> Void) {
        
        FBRef.document(groupID).collection("Lines").getDocuments { (documentSnapshot, error) in
            
            var lines = [Line]()
            
            if let error = error {
                print(error.localizedDescription)
                completion([])
                return
            }
            
            guard let documents = documentSnapshot?.documents else { completion([]); return }
            
            for document in documents {
                let line = try! FirestoreDecoder().decode(Line.self, from: document.prepareForDecoding())
                lines.append(line)
            }
            
            completion(lines)
        }
        
    }
    
}
