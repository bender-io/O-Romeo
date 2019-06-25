//
//  PersonController.swift
//  O'Romeo
//
//  Created by Will morris on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class PersonController {

    // MARK: - Properties

    static let shared = PersonController()

    let db = UserController.shared.db

    var persons = [Person]()

    // MARK: - Methods

    /// Create a person document and add it to the person collection in firestore. If document creation is successful, calls updatePersonUIDs and passes in the person documents DocumentReference ID.
    ///
    /// - Parameters:
    ///   - name: Name of person (String)
    ///   - anniversary: Anniversary of relationship (String = "")
    ///   - birthday: Birthday of person (String = "")
    ///   - interests: Interests of person ([String] = [])
    func createPersonWith(name: String, anniversary: String = "", birthday: String = "", interests: [String] = [], dateLog: [String] = [], completion: @escaping (Error?) -> Void) {
        let person = persons.filter { $0.name == name }

        guard name != person.first?.name else { completion(Errors.personAlreadyExists); return }
        guard let currentUser = Auth.auth().currentUser else { completion(Errors.noCurrentUser); return }

        var ref: DocumentReference? = nil
        ref = db.collection("person").addDocument(data: [
            "name" : name,
            "anniversary" : anniversary,
            "birthday" : birthday,
            "userUID" : currentUser.uid,
            "interests" : interests,
            "dateLog" : dateLog
            ], completion: { (error) in
                if let error = error {
                    print("Error adding document: \(error) : \(error.localizedDescription): \(#function)")
                } else {
                    guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID); return }

                    UserController.shared.updatePersonUIDs(with: docID)
                    self.addDefaultInterests(for: docID)
                    print("Document added with ID: \(docID)")
                }
                completion(nil)

        })
    }

    /// Deletes the person document using the passed in personUID
    ///
    /// - Parameters:
    ///   - personUID: Uid of person to be deleted (String)
    ///   - completion: error (Error)
    func deletePerson(personUID: String, completion: @escaping (Error?) -> Void) {
        db.collection("person").document(personUID).delete { (error) in
            if let error = error {
                print("There was an error deleting the person: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
            }
        }
    }

    /// Takes in a persons name and an interest. Filters through the persons array ([Person]) to find the person with matching name. Then grabs the personUID of the person and uses that to find the persons document in firestore. Once the document is found, the interest is added to the intrests array in the person document.
    ///
    /// - Parameters:
    ///   - personUID: Uid of person to be updated (String)
    ///   - interest: Interest to be added (String)
    ///   - completion: error (Error)
    func updatePersonInterests(for personUID: String, with interest: String, completion: @escaping (Error?) -> Void) {
        let value = persons.filter { $0.personUID == personUID }

        guard let personUID = value.first?.personUID else { completion(Errors.unwrapPersonUID); return }

        db.collection("person").document(personUID).updateData([
            "interests" : FieldValue.arrayUnion([interest])
        ]) { (error) in
            if let error = error {
                print("there was an error updating the persons interests: \(error) : \(error.localizedDescription): \(#function)")
            }
            completion(nil)
        }
    }

    /// Takes in a persons name and an event. Filters through the persons array ([Person]) to find the person with matching name. Then grabs the personUID of the person and uses that to find the persons document in firestore. Once the document is found, the event is added to the Date Log in the person document.
    ///
    /// - Parameters:
    ///   - personUID: Uid of person to be updated (String)
    ///   - event: Event to be added (String)
    ///   - completion: error (Error)
    func updatePersonDateLog(for personUID: String, with event: String, completion: @escaping (Error?) -> Void) {
        let value = persons.filter { $0.personUID == personUID }

        guard let personUID = value.first?.personUID else { completion(Errors.unwrapPersonUID); return }
        db.collection("person").document(personUID).updateData([
            "dateLog" : FieldValue.arrayUnion([event])
        ]) { (error) in
            if let error = error {
                print("There was an error updating the persons datelog: \(error): \(error.localizedDescription) : \(#function)")
            }
            completion(nil)
        }
    }

    /// Takes in a persons name and an interest. Filters through the persons array ([Person]) to find the person with matching name. Then grabs the personUID of the person and uses that to find the persons document in firestore. Once the document is found, updates the name, birthday, and anniversary for the person.
    ///
    /// - Parameters:
    ///   - personUID: Uid of person to be updated (String)
    ///   - name: Name of person (String)
    ///   - birthday: Birthday of person (String)
    ///   - anniversary: Anniversary of person (String)
    ///   - completion: error (Error)
    func updatePersonInfo(for personUID: String, name: String, birthday: String, anniversary: String, completion: @escaping (Error?) -> Void) {
        let value = persons.filter { $0.personUID == personUID }

        guard let personUID = value.first?.personUID else { completion(Errors.unwrapPersonUID); return }
        db.collection("person").document(personUID).updateData([
            "name" : name,
            "birthday" : birthday,
            "anniversary" : anniversary
        ]) { (error) in
            if let error = error {
                print("there was an error updating the person: \(error) : \(error.localizedDescription): \(#function)")
            }
            completion(nil)

        }
    }

    /// Fetches the users person documents from the firstore and adds them to local array (Source of truth)
    ///
    /// - Parameter completion: error (Error)
    func fetchPersonsFromFirestore(completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { completion(Errors.unwrapCurrentUserUID); return }
        db.collection("person").whereField("userUID", isEqualTo: userUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching persons: \(error) : \(error.localizedDescription) : \(#function)")
            }
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { completion(Errors.snapshotGuard); return }

            self.persons = snapshot.documents.compactMap { Person(from: $0.data(), uid: $0.documentID) }
            completion(nil)

        }
    }

    /// Creates default interests for the specified person using their personUID
    ///
    /// - Parameter personUID: The uid for the person (String)
    func addDefaultInterests(for personUID: String) {
        InterestController.shared.createInterestFor(personUID: personUID, name: "Favorite Color", description: "Put favorite color here") {
            (error) in
            if let error = error {
                print("There was an error creating default interest 1: \(error.localizedDescription): \(#function)")
            }
        }

        InterestController.shared.createInterestFor(personUID: personUID, name: "Favorite Flower", description: "Put favorite flower here") {
            (error) in
            if let error = error {
                print("There was an error creating default interest 2: \(error.localizedDescription): \(#function)")

            }
        }

        InterestController.shared.createInterestFor(personUID: personUID, name: "Favorite Movie", description: "Put favorite movie here") {
            (error) in
            if let error = error {
                print("There was an error creating default interest 3: \(error.localizedDescription): \(#function)")

            }
        }
    }
}
