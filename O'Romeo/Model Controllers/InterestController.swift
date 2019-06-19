//
//  InterestController.swift
//  O'Romeo
//
//  Created by Will morris on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class InterestController {
    
    // MARK: - Properties
    
    static let shared = InterestController()
    
    let db = UserController.shared.db
    
    var interests = [Interest]()
    
    // MARK: - Methods
    
    func createInterestFor(person: Person, with name: String, description: String) {
        var ref: DocumentReference? = nil
        ref = db.collection("interest").addDocument(data: [
            "name" : name,
            "description" : description,
            "personUID" : person.personUID
            ], completion: { (error) in
                if let error = error {
                    print("Error adding document: \(error) : \(error.localizedDescription)")
                } else {
                    guard let docID = ref?.documentID else { print("Couldn't unwrap ref.documentID: \(#function)"); return }
                    PersonController.shared.updatePersonInterests(for: person.name, with: docID)
                    print("Document added with ID: \(docID)")
                }
        })
    }
    
    func updateInterest(name: String, description: String) {
        let interest = interests.filter { $0.name == name }
        
        guard let interestUID = interest.first?.interestUID else { print("Couldn't unwrap interestUID: \(#function)"); return }
        db.collection("interest").document(interestUID).updateData([
            "name" : name,
            "description" : description
        ]) { (error) in
            if let error = error {
                print("there was an error updating the interest: \(error) : \(error.localizedDescription)")
            }
        }
    }
    
    func fetchInterestsFromFirestore(for person: Person) {
        db.collection("interest").whereField("personUID", isEqualTo: person.personUID).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { print("Failed snapshot gaurd: \(#function)"); return }
            
            self.interests = snapshot.documents.compactMap { Interest(from: $0.data(), uid: $0.documentID) }
        }
    }
}
