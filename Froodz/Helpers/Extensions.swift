//
//  Extensions.swift
//  Froodz
//
//  Created by Justin Matsnev on 2/10/20.
//  Copyright © 2020 Justin Matsnev. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension JSONDecoder {
    func decode<T>(_ type: T.Type, fromJSONObject object: Any) throws -> T where T: Decodable {
        return try decode(T.self, from: try JSONSerialization.data(withJSONObject: object, options: []))
    }
}

extension DocumentSnapshot {

    func prepareForDecoding() -> [String: Any] {
        guard var data = self.data() else {return [:]}
        data["documentId"] = self.documentID

        return data
    }

}
