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
        
    //Return error string associated with request
    private static func errorExists(err: Error?) -> (Bool) {
        if let _ = err {
            return true
        } else {
            return false
        }
    }
    
    //Create new line and upload to Firebase Group/Line Collection
    static func pushNewLine_ToGroup(lineName : String, amount : Double, groupID : String, completion: @escaping (Bool) -> Void) {
        
        let lineData = CodableService.CodableLine.toLineData(lineName: lineName, amount: amount, users: [user.username], creator: user.username)
        
        FBRef.document(groupID).collection("Lines").addDocument(data: lineData) { error in
            if self.errorExists(err: error) { print(error!.localizedDescription)
                completion(false) ; return }
            
            completion(true)
            print("Document successfully written!")
        }
    }
    
    //Check to see if user has placed a bet on current line
    //If no bet, allow placement, otherwise return
    static func checkUserPlaceLineBet(groupID : String, lineID: String,
                                       completion: @escaping (_ didPlaceBetAlready: Bool) -> Void) {

        FBRef.document(groupID).collection("Lines").document(lineID).getDocument { (snapshot, error) in
            
            if self.errorExists(err: error) { print(error!.localizedDescription)
            completion(true) ; return }

            guard let data = snapshot else {completion(true) ; return}
            let line = CodableService.CodableLine.getLine(snapshot: data)

            if !line.single.isEmpty, line.single.contains(user.username) {
                completion(true)
                return
            } else if !line.doubleDown.isEmpty, line.doubleDown.contains(user.username) {
                completion(true)
                return
            }
            
            completion(false)
            return
        }
    }
    
    //Update Single bet array for Line to include user
    static func addUser_ToSingleBet(groupID : String, lineID: String) {
        FBRef.document(groupID).collection("Lines").document(lineID).updateData([
            "single": FieldValue.arrayUnion([user.username]),
        ])
    }
    
    //Update double bet array for Line to include user
    static func addUser_ToDoubleDown(groupID : String, lineID: String) {
        FBRef.document(groupID).collection("Lines").document(lineID).updateData([
            "doubleDown": FieldValue.arrayUnion([user.username]),
        ])
    }
    
    //Get the current lines from the Group/Lines reference and return lines
    static func retrieve_Lines(lineRef: String, groupID: String, completion: @escaping ([Line]) -> Void) {
        
        FBRef.document(groupID).collection(lineRef).addSnapshotListener { (snapshot, err) in
           
            var lines = [Line]()
            if self.errorExists(err: err) { print(err!.localizedDescription)
            completion([]) ; return }
            
            guard let documents = snapshot?.documents else { completion([]); return }
            
            for document in documents {
                lines.append(CodableService.CodableLine.getLine(snapshot: document))
            }
            completion(lines)
        }
    }
    
    static func get_CurrentLines(groupID: String, completion: @escaping ([Line]) -> ()) {
        return retrieve_Lines(lineRef: "Lines", groupID: groupID, completion: completion)
    }
    
    static func get_PastLines(groupID: String, completion: @escaping ([Line]) -> ()) {
        return retrieve_Lines(lineRef: "Past Lines", groupID: groupID, completion: completion)
    }
}
