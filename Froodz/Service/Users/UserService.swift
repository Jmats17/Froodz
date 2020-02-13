//
//  UserService.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/9/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import CodableFirebase

struct UserService {
    
    private static let FBUserRef = Firestore.firestore().collection("Users")
    private static let usernameRef = Firestore.firestore().collection("Usernames")

    static func return_UserActiveGroups(userID: String, completion : @escaping ([String]) -> Void) {
        
        FBUserRef.document(userID).getDocument { (documentSnapshot, error) in
            
            if let err = error {
                completion([])
                print(err.localizedDescription)
                return
            }
            
            guard let snapshot = documentSnapshot else { completion([]); return }
                  
            let user = try! FirestoreDecoder().decode(User.self, from: snapshot.prepareForDecoding())
            completion(user.active_groups)
        }
    }
    
    static func addGroupTo_ActiveGroups(userID: String, groupID: String) {
        FBUserRef.document(userID).updateData([
            "active_groups": FieldValue.arrayUnion([groupID])
        ]) { err in
            if let err = err {
                print("Error joining group: \(err.localizedDescription)")
            } else {
                print("Joined")
            }
        }
    }
    
    static func checkForExistingUsername(username: String, completion: @escaping (_ isTaken : Bool) -> Void) {
        
        usernameRef.whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(true)
                return
            }
            
            guard let snapshot = snapshot else {
                print("Error fetching document: \(String(describing: error?.localizedDescription))")
                completion(true)
                return
            }
            
            let result = snapshot.documents.map({ (document) -> [String : String] in
                return document.data() as! [String : String]
            })
            
            if result.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
            
        }
    }
    
    static func create(_ user: FIRUser , username: String, fullName : String, completion: @escaping (User?) -> Void) {
        var userAttrs = [String : Any]()
        
        Firestore.firestore().collection("Usernames").addDocument(data: ["username" : username])
        
        userAttrs = ["username": username, "fullName" : fullName, "active_groups": FieldValue.arrayUnion([])] as [String : Any]
        
        let ref = Firestore.firestore().collection("Users").document(user.uid)
        ref.setData(userAttrs) { (err) in
            if let error = err {
                print(error.localizedDescription)
                return completion(nil)
            }
            ref.getDocument(completion: { (snapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                }
                guard let snapshot = snapshot else { return completion(nil) }
                let user = try! FirestoreDecoder().decode(User.self, from: snapshot.prepareForDecoding())

                completion(user)
            })
        }
        
    }
    
}
