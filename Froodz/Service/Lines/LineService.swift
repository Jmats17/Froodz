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
    static let user = User.current
    
    static func pushNewLine_ToGroup(lineName : String, amount : Double, secondAmt : Double?, groupID : String, type: String, completion: @escaping (Bool) -> Void) {

        let line = Line(documentId: nil, lineName: lineName, type: type, numOnLine: amount, optionalSecondLine: secondAmt, users: [user.username], creator: user.username, over: [], under: [])

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
    
    static func checkUserPlaceLineBet(groupID : String, lineID: String,
                                      selectedLine: String, completion: @escaping (_ didPlaceBetAlready: Bool) -> Void) {


        FBRef.document(groupID).collection("Lines").document(lineID).getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(true)
                return
            }

            guard let data = snapshot else {completion(true) ; return}
            let line = try! FirestoreDecoder().decode(Line.self, from: data.prepareForDecoding())

            if !line.under.isEmpty, line.under.contains(user.username) {
                completion(true)
                return
            } else if !line.over.isEmpty, line.over.contains(user.username) {
                completion(true)
                return
            }
            
            completion(false)
            return
        }
    }
    
    static func addUser_ToLineSide(groupID : String, lineID: String, sideTapped: String) {

        if sideTapped == "Minus" {
            FBRef.document(groupID).collection("Lines").document(lineID).updateData([
                "under": FieldValue.arrayUnion([user.username]),
                "over": FieldValue.arrayUnion([])
            ])
        } else {
            FBRef.document(groupID).collection("Lines").document(lineID).updateData([
                "over": FieldValue.arrayUnion([user.username]),
                "under": FieldValue.arrayUnion([])
            ])
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
