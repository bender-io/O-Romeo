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
<<<<<<< HEAD
    func createInterestFor(personUID: String, name: String, description: String, completion: @escaping (Bool) -> Void) {
        let interest = interests.filter { $0.name == name }
        
        guard name != interest.first?.name else { print("Interest already exists: \(#function)"); completion(false); return }
=======
    func createInterestFor(personUID: String, name: String, description: String, completion: @escaping (Error?) -> Void) {
        let interest = interests.filter { $0.name == name }
        
        guard name != interest.first?.name else { completion(Errors.interestAlreadyExists); return }
>>>>>>> added segues from events to add calendar
        var ref: DocumentReference? = nil
        ref = db.collection("interest").addDocument(data: [
            "name" : name,
            "description" : description,
            "personUID" : personUID
            ], completion: { (error) in
                if let error = error {
                    print("Error adding document: \(error) : \(error.localizedDescription)")
                } else {
<<<<<<< HEAD
                    guard let docID = ref?.documentID else { print("Couldn't unwrap ref.documentID: \(#function)"); completion(false); return }
                    PersonController.shared.updatePersonInterests(for: personUID, with: docID)
                    print("Document added with ID: \(docID)")
                }
                completion(true)
=======
                    guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID); return }
                    PersonController.shared.updatePersonInterests(for: personUID, with: docID, completion: { (error) in
                        if let error = error {
                            print("There was an error: \(error.localizedDescription): \(#function)")
                        }
                    })
                    print("Document added with ID: \(docID)")
                }
                completion(nil)
>>>>>>> added segues from events to add calendar
        })
    }
    
    /// Deletes the interest with the given interestUID
    ///
    /// - Parameters:
    ///   - interestUID: Uid of interest to be deleted (String)
    ///   - completion: error (Error)
    func deleteInterest(interestUID: String, completion: @escaping (Error?) -> Void) {
        db.collection("interest").document(interestUID).delete { (error) in
            if let error = error {
                print("There was an error deleting the interest: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
            }
        }
    }
    
    /// Updates the interest with the specified parameters.
    ///
    /// - Parameters:
    ///   - interest: Interest to be updated (Interest)
    ///   - name: The new name (String)
    ///   - description: The new description (String)
<<<<<<< HEAD
    func updateInterest(name: String, description: String) {
        let interest = interests.filter { $0.name == name }
        
        guard let interestUID = interest.first?.interestUID else { print("Couldn't unwrap interestUID: \(#function)"); return }
        db.collection("interest").document(interestUID).updateData([
=======
    func updateInterest(interest: Interest, name: String, description: String) {
        db.collection("interest").document(interest.interestUID).updateData([
>>>>>>> added segues from events to add calendar
            "name" : name,
            "description" : description
        ]) { (error) in
            if let error = error {
<<<<<<< HEAD
                print("there was an error updating the interest: \(error) : \(error.localizedDescription)")
=======
                print("There was an error updating the interest: \(error) : \(error.localizedDescription): \(#function)")
>>>>>>> added segues from events to add calendar
            }
        }
    }
    
    /// Fetches the interests for the specified person from the firestore
    ///
    /// - Parameter person: The person object to fetch from (Person)
<<<<<<< HEAD
    func fetchInterestsFromFirestore(for person: Person) {
        db.collection("interest").whereField("personUID", isEqualTo: person.personUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching interests: \(error) : \(error.localizedDescription) : \(#function)")
            }
            
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { completion(Errors.snapshotGuard); return }
            
            self.interests = snapshot.documents.compactMap { Interest(from: $0.data(), uid: $0.documentID) }
=======
    func fetchInterestsFromFirestore(for person: Person, completion: @escaping (Error?) -> Void) {
        db.collection("interest").whereField("personUID", isEqualTo: person.personUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching interests: \(error) : \(error.localizedDescription) : \(#function)")
            }
            
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { completion(Errors.snapshotGuard); return }
            
            self.interests = snapshot.documents.compactMap { Interest(from: $0.data(), uid: $0.documentID) }
            completion(nil)
>>>>>>> added segues from events to add calendar
        }
    }
}
