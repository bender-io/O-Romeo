//
//  UserController.swift
//  O'Romeo
//
//  Created by Will morris on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserController {
    
    // MARK: - Properties
    
    static let shared = UserController()
    
    lazy var db = Firestore.firestore()
    
    // MARK: - Methods
    
    /// Creates a new user with the given email and password. Adds them as a document in the "users" collection. Each new user document has a dictionary that contains a key of "personUIDs" with a value of an empty array. Everytime a new person document is created, the persons uid will be added to the users "personUIDs" array.
    ///
    /// - Parameters:
    ///   - email: Users email (String)
    ///   - password: Users password (String)
    ///   - completion: Returns an error if there was one (Error)
    func createUserWith(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("There was an error creating the user: \(error) : \(error.localizedDescription)")
                completion(false)
            }
            
            guard let data = data else { print("Couldnt unwrap data: \(#function)"); completion(false); return }
            self.db.collection("user").document(data.user.uid).setData([
                "personUIDs" : []
                ], completion: { (error) in
                    if let error = error {
                        print("Error adding document: \(error) : \(error.localizedDescription)")
                    } else {
                        print("Document added with ID: \(data.user.uid)")
                    }
            })
            completion(true)
        }
    }
    
    /// Takes in a persons uid and appends it to the users "personUIDs" array.
    ///
    /// - Parameter person: Person uid (string)
    func updatePersonUIDs(with personUID: String) {
        guard let currentUser = Auth.auth().currentUser else { print("Couldn't unwrap the current user: \(#function)"); return }
        db.collection("user").document(currentUser.uid).updateData([
            "personUIDs" : FieldValue.arrayUnion([personUID])
        ]) { (error) in
            if let error = error {
                print("There was an error updating the person array: \(error) : \(error.localizedDescription)")
            }
        }
    }
    
    /// Sign in the user with the given email and password.
    ///
    /// - Parameters:
    ///   - email: Users email (String)
    ///   - password: Users password (String)
    ///   - completion: Returns an error if there was one (Error)
    func signInUserWith(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("There was an error signing in the user: \(error) : \(error.localizedDescription)")
                completion(error)
            }
            completion(nil)
        }
    }
    
    /// Sign out the current user
    func signOutUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("There was an error signing the user out: \(error) : \(error.localizedDescription)")
        }
    }
}
