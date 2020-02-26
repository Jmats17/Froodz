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

    //Retrieve the User's group IDs and send to Groups+Users Service class
    static func return_UserActiveGroupsIDS(userID: String, completion : @escaping ([String]) -> Void) {
        FBUserRef.document(userID).getDocument { (documentSnapshot, error) in
            
            if self.errorExists(err: error) { completion([]) ; return }
                        
            guard let snapshot = documentSnapshot else { completion([]); return }
            let user = CodableService.CodableUser.getUser(snapshot: snapshot)
            
            completion(user.active_groups)
        }
    }
    
    //Return error string associated with request
    private static func errorExists(err: Error?) -> (Bool) {
        if let _ = err {
            return true
        } else {
            return false
        }
    }
    
    //Add new group reference ID to Users's active groups
    static func addGroupTo_ActiveGroups(userID: String, groupID: String) {
        FBUserRef.document(userID).updateData([
            "active_groups": FieldValue.arrayUnion([groupID])
        ]) { err in
            if self.errorExists(err: err) { return }
        }
    }
    
    //Return Current Users's balance from selected Group
    static func returnUsersBalance_FromGroup(group : Group) -> Double {
        if group.leaderboard.keys.contains(User.current.username) {
            guard let amount = group.leaderboard[User.current.username] else { return 0.0 }
            return amount
        }
        return 0.0
    }
    
    
    
    //Create User Object and push to firebase
    static func create(_ user: FIRUser , username: String, fullName : String, completion: @escaping (User?) -> Void) {
        
        var userAttrs = [String : Any]()
        Firestore.firestore().collection("Usernames").addDocument(data: ["username" : username])
        
        userAttrs = ["username": username, "fullName" : fullName, "active_groups": FieldValue.arrayUnion([])] as [String : Any]
        
        let ref = FBUserRef.document(user.uid)
        ref.setData(userAttrs) { (err) in
            
            if self.errorExists(err: err) { completion(nil) ; return }

            ref.getDocument(completion: { (snapshot, error) in
                
                if self.errorExists(err: error) { completion(nil) ; return }

                guard let snapshot = snapshot else { return completion(nil) }
                let user = CodableService.CodableUser.getUser(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    //Check for existing usernames, if no username exists, push new username otherwise return taken
    static func checkForExistingUsername(username: String, completion: @escaping (_ isTaken : Bool) -> Void) {
        usernameRef.whereField("username", isEqualTo: username.lowercased()).getDocuments { (snapshot, error) in
            
            if self.errorExists(err: error) { completion(true) ; return }

            
            guard let snapshot = snapshot else {
                if self.errorExists(err: error) { completion(true) ; return }
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
    
}
