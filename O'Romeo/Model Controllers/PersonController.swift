//
//  PersonController.swift
//  O'Romeo
//
//  Created by Will morris on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class PersonController {
    
    static let shared = PersonController()
    
    let db = UserController.shared.db
    
    var persons = [Person]()
    
    func createPersonWith(name: String, anniversary: String, birthday: String, interests: [String] = []) {
        guard let currentUser = Auth.auth().currentUser else { print("No current user: \(#function)"); return }
        var ref: DocumentReference? = nil
        ref = db.collection("person").addDocument(data: [
            "name" : name,
            "anniversary" : anniversary,
            "birthday" : birthday,
            "userUID" : currentUser.uid,
            "interests" : interests
            ], completion: { (error) in
                if let error = error {
                    print("Error adding document: \(error) : \(error.localizedDescription)")
                } else {
                    guard let docID = ref?.documentID else { print("Couldn't unwrap ref.documentID: \(#function)"); return }
                    UserController.shared.updatePersonUIDs(with: docID)
                    print("Document added with ID: \(docID)")
                }
        })
    }
    
    func updatePersonInterests(for person: String, with interest: String) {
        let value = persons.filter { $0.name == person }
        
        guard let personUID = value.first?.personUID else { print("Couldn't unwrap value.first?.personUID: \(#function)"); return }
        db.collection("person").document(personUID).updateData([
            "interests" : FieldValue.arrayUnion([interest])
        ]) { (error) in
            if let error = error {
                print("there was an error updating the person: \(error) : \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPersonsFromFirestore() {
        guard let userUID = Auth.auth().currentUser?.uid else { print("Couldn't unwrap Auth.auth().currentUser.uid: \(#function)"); return }
        db.collection("person").whereField("userUID", isEqualTo: userUID).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { print("Failed snapshot gaurd: \(#function)"); return }
            
            self.persons = snapshot.documents.compactMap { Person(from: $0.data(), uid: $0.documentID) }
        }
    }
}
