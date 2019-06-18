//
//  UserController.swift
//  O'Romeo
//
//  Created by Will morris on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class UserController {
    
    static let shared = UserController()
    
    lazy var db = Firestore.firestore()
    
    func createUserWith(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("There was an error creating the user: \(error) : \(error.localizedDescription)")
            }
            
            guard let data = data else { print("Couldnt unwrap data: \(#function)"); return }
            self.db.collection("user").document(data.user.uid).setData([
                "personUIDs" : []
                ], completion: { (error) in
                    if let error = error {
                        print("Error adding document: \(error) : \(error.localizedDescription)")
                    } else {
                        print("Document added with ID: \(data.user.uid)")
                    }
            })
            
        }
    }
    
    func updatePersonUIDs(with person: String) {
        guard let currentUser = Auth.auth().currentUser else { print("Couldn't unwrap the current user: \(#function)"); return }
        db.collection("user").document(currentUser.uid).updateData([
            "personUIDs" : FieldValue.arrayUnion([person])
        ]) { (error) in
            if let error = error {
                print("There was an error updating the person array: \(error) : \(error.localizedDescription)")
            }
        }
    }
}
