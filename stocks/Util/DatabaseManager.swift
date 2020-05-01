//
//  DatabaseManager.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/30/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseManager: NSObject {
    static var shared = DatabaseManager()
    var ref: DatabaseReference
    var usersHandle: DatabaseReference {
        ref.child("users")
    }
    var userHandle: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return ref.child("users").child(uid)
    }

    override init() {
        ref = Database.database().reference()
    }
}
