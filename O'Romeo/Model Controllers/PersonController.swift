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
    func createPersonWith(name: String, anniversary: String = "", birthday: String = "", interests: [String] = [], completion: @escaping (Error?) -> Void) {
        let person = persons.filter { $0.name == name }
        let personError = "Person already exists: \(#function)" as! Error
        let currentUserError = "No current user: \(#function)" as! Error
        let docIDError = "Couldn't unwrap ref.documentID: \(#function)" as! Error
        
        guard name == person.first?.name else { completion(personError); return }
        guard let currentUser = Auth.auth().currentUser else { completion(currentUserError); return }
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
                    guard let docID = ref?.documentID else { completion(docIDError); return }
                    UserController.shared.updatePersonUIDs(with: docID)
                    print("Document added with ID: \(docID)")
                }
                completion(nil)
        })
    }
    
    /// Takes in a persons name and an interest. Filters through the persons array ([Person]) to find the person with matching name. Then grabs the personUID of the person and uses that to find the persons document in firestore. Once the document is found, the interest is added to the intrests array in the person document.
    ///
    /// - Parameters:
    ///   - person: Name of person to be updated (String)
    ///   - interest: Interest to be added (String)
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
    
    /// Fetches all the persons for the current user and sets them to the persons array ([Person])
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
