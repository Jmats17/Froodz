//
//  FirestoreService.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/18/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import CodableFirebase
import FirebaseFirestore

struct CodableService {
    
    struct CodableUser {
        //Get the User from Firebase snapshot
        //Decode using CodableFirebase and turn into User object
        static func getUser(snapshot: DocumentSnapshot) -> User {
            let user = try! FirestoreDecoder().decode(User.self, from: snapshot.prepareForDecoding())
            return user
        }
    }
    
    struct CodableGroup {
        //Get the Group from Firebase snapshot
        //Decode using CodableFirebase and turn into Group object
        static func getGroup(snapshot: DocumentSnapshot) -> Group {
            let group = try! FirestoreDecoder().decode(Group.self, from: snapshot.prepareForDecoding())
            return group
        }
    }
    
    struct CodableLine {
        //Convert Line object to data to push to firebase
        static func toLineData(lineName: String, amount: Double, users: [String], creator: String) -> [String: Any] {
            let line = Line(documentId: nil, lineName: lineName, numOnLine: amount, users: users, creator: creator, agreedUsers: [], disagreedUsers: [])
            return try! FirestoreEncoder().encode(line)
        }
        
        //Get the Group from Firebase snapshot
        //Decode using CodableFirebase and turn into Group object
        static func getLine(snapshot: DocumentSnapshot) -> Line {
            let line = try! FirestoreDecoder().decode(Line.self, from: snapshot.prepareForDecoding())
            return line
        }
    }
    
    
}
