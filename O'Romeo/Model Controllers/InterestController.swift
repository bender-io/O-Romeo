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
    func createInterestFor(personUID: String, name: String, description: String, completion: @escaping (Error?) -> Void) {
        let interest = interests.filter { $0.name == name }

        guard name != interest.first?.name else { completion(Errors.interestAlreadyExists); return }

        var ref: DocumentReference? = nil
        ref = db.collection("interest").addDocument(data: [
            "name" : name,
            "description" : description,
            "personUID" : personUID
            ], completion: { (error) in
                if let error = error {
                    print("Error adding document: \(error) : \(error.localizedDescription)")
                    completion(error)
                    return
                } else {
                    guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID); return }
                    PersonController.shared.updatePersonInterests(for: personUID, with: docID, completion: { (error) in
                        if let error = error {
                            print("There was an error: \(error.localizedDescription): \(#function)")
                            completion(error)
                            return
                        }
                    })
                    print("Document added with ID: \(docID)")
                }
                completion(nil)

        })
    }

    /// Deletes the interest with the given interest or interestUID
    ///
    /// - Parameters:
    ///   - interest: Interest to be deleted (Interest?)
    ///   - interestUID: Uid of interest to be deleted (String?)
    ///   - completion: error (Error)
    func deleteInterest(interest: Interest?, interestUID: String?, completion: @escaping (Error?) -> Void) {
        if let interest = interest {
            db.collection("interest").document(interest.interestUID).delete { (error) in
                if let error = error {
                    print("There was an error deleting the interest: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
            db.collection("person").document(interest.personUID).updateData([
                "interests" : FieldValue.arrayRemove([interest.interestUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error deleting the interestUID in person: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else if let interestUID = interestUID {
            db.collection("interest").document(interestUID).delete { (error) in
                if let error = error {
                    print("There was an error deleting the interest: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        completion(nil)
    }

    /// Updates the interest with the specified parameters.
    ///
    /// - Parameters:
    ///   - interest: Interest to be updated (Interest)
    ///   - name: The new name (String)
    ///   - description: The new description (String)
    func updateInterest(interest: Interest, name: String, description: String) {
        db.collection("interest").document(interest.interestUID).updateData([

            "name" : name,
            "description" : description
        ]) { (error) in
            if let error = error {
                print("There was an error updating the interest: \(error) : \(error.localizedDescription): \(#function)")

            }
        }
    }

    /// Fetches the interests for the specified person from the firestore
    ///
    /// - Parameters:
    ///   - person: Person to fetch interests for (Person)
    ///   - completion: error (Error)
    func fetchInterestsFromFirestore(for person: Person, completion: @escaping (Error?) -> Void) {
        db.collection("interest").whereField("personUID", isEqualTo: person.personUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching interests: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }

            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { completion(Errors.snapshotGuard); return }

            let foundInterests = snapshot.documents.compactMap { Interest(from: $0.data(), uid: $0.documentID) }
            for interest in foundInterests {
                if interest.name == "Favorite Color" {
                    self.interests.insert(interest, at: 0)
                } else if interest.name == "Favorite Movie" {
                    self.interests.insert(interest, at: 0)
                } else if interest.name == "Favorite Flower" {
                    self.interests.insert(interest, at: 0)
                } else {
                    self.interests.append(interest)
                }
            }
            completion(nil)
        }
    }
}
