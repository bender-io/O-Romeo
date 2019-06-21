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
    
    /// Creates a new interest for the specified person and adds it to the "interest" collection in firestore. Next the specified persons array of interests is updated to contain the uid for the newly created interest.
    ///
    /// - Parameters:
    ///   - personUID: The uid of the person object to add the interest too (String)
    ///   - name: The name of the interest (String)
    ///   - description: The description of the interest (String)
    func createInterestFor(personUID: String, name: String, description: String, completion: @escaping (Bool) -> Void) {
        let interest = interests.filter { $0.name == name }
        
        guard name != interest.first?.name else { print("Interest already exists: \(#function)"); completion(false); return }
        var ref: DocumentReference? = nil
        ref = db.collection("interest").addDocument(data: [
            "name" : name,
            "description" : description,
            "personUID" : personUID
            ], completion: { (error) in
                if let error = error {
                    print("Error adding document: \(error) : \(error.localizedDescription)")
                } else {
                    guard let docID = ref?.documentID else { print("Couldn't unwrap ref.documentID: \(#function)"); completion(false); return }
                    PersonController.shared.updatePersonInterests(for: personUID, with: docID)
                    print("Document added with ID: \(docID)")
                }
                completion(true)
        })
    }
    
    /// Updates the interest with the specified name.
    ///
    /// - Parameters:
    ///   - name: The new name (String)
    ///   - description: The new description (String)
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
    
    /// Fetches the interests for the specified person from the firestore.
    ///
    /// - Parameter person: The person object to fetch from (Person)
    func fetchInterestsFromFirestore(for person: Person) {
        db.collection("interest").whereField("personUID", isEqualTo: person.personUID).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { print("Failed snapshot gaurd: \(#function)"); return }
            
            self.interests = snapshot.documents.compactMap { Interest(from: $0.data(), uid: $0.documentID) }
        }
    }
}
