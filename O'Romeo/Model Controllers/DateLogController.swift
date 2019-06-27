//
//  CalendarController.swift
//  O'Romeo
//
//  Created by Will morris on 6/24/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DateLogController {
    
    // MARK: - Properties
    
    static let shared = DateLogController()
    
    var dateLogs: [DateLog] = []
    
    let db = UserController.shared.db
    
    // MARK: - Methods
    
    /// Creates a new dateLog for the specified person and adds it to the "dateLog" collection in firestore. Next the specified persons array of dateLogs is updated to contain the uid for the newly created dateLog.
    ///
    /// - Parameters:
    ///   - date: Time of date (Date)
    ///   - julietName: Name of girl (String)
    ///   - event: Name of event (String)
    ///   - address: Address of event (String)
    ///   - personUID: Uid of person (String)
    ///   - description: Description of event (String)
    ///   - completion: error (Error)
    func createDateLog(date: String, julietName: String, event: String, address: String, personUID: String, description: String, completion: @escaping (Error?) -> Void) {
        
        var ref: DocumentReference? = nil
        ref = db.collection("dateLog").addDocument(data: [
            "date" : date,
            "julietName" : julietName,
            "event" : event,
            "address" : address,
            "personUID" : personUID,
            "description" : description
            ], completion: { (error) in
                if let error = error {
                    print("There was an error adding to calendar: \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                } else {
                    guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID); return }
                    PersonController.shared.updatePersonDateLog(for: personUID, with: docID, completion: { (error) in
                        if let error = error {
                            print("There was an error: \(error.localizedDescription) : \(#function)")
                            completion(error)
                            return
                        }
                        LocalNotificationsController.shared.scheduleUserNotifications(for: date.asDate(), uid: docID)
                    })
                }
                completion(nil)
        })
    }
    
    /// Deletes the interest with the given dateLog or dateLog UID
    ///
    /// - Parameters:
    ///   - dateLog: DateLog to be deleted (DateLog?)
    ///   - dateLogUID: Uid of dateLog to be deleted (String?)
    ///   - completion: error (Error)
    func deleteDateLog(dateLog: DateLog?, dateLogUID: String?, completion: @escaping (Error?) -> Void) {
        if let dateLog = dateLog {
            db.collection("dateLog").document(dateLog.dateLogUID).delete { (error) in
                if let error = error {
                    print("There was an error deleting the dateLog: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
            guard let personUID = dateLog.personUID else { completion(Errors.unwrapPersonUID); return }
            db.collection("person").document(personUID).updateData([
                "dateLog" : FieldValue.arrayRemove([dateLog.dateLogUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error deleting the dateLogUID from person: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        } else if let dateLogUID = dateLogUID {
            db.collection("dateLog").document(dateLogUID).delete { (error) in
                if let error = error {
                    print("There was an error deleting the dateLog: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        completion(nil)
    }
    
    /// Updates the dateLog with the specified parameters. If the person is different, updates the person documents
    ///
    /// - Parameters:
    ///   - dateLog: DateLog to be updated (DateLog)
    ///   - date: New date (Date)
    ///   - person: Person object (Person?)
    ///   - event: New event name (String)
    ///   - address: New Address (String)
    ///   - description: New Description (String)
    func updateDateLog(dateLog: DateLog, date: String, person: Person?, event: String, address: String, description: String, completion: @escaping (Error?) -> Void) {
        db.collection("dateLog").document(dateLog.dateLogUID).updateData([
            "date" : date,
            "event" : event,
            "address" : address,
            "description" : description
        ]) { (error) in
            if let error = error {
                print("There was an error updating the dateLog: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        guard let person = person else { return }
        db.collection("dateLog").document(dateLog.dateLogUID).updateData([
            "julietName" : person.name,
            "personUID" : person.personUID
        ]) { (error) in
            if let error = error {
                print("There was an error updating the dateLog: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
        }
        if dateLog.personUID != person.personUID {
            guard let personUID = dateLog.personUID else { completion(Errors.unwrapPersonUID); return }
            db.collection("person").document(personUID).updateData([
                "dateLog" : FieldValue.arrayRemove([dateLog.dateLogUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error updating old person: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
            db.collection("person").document(person.personUID).updateData([
                "dateLog" : FieldValue.arrayUnion([dateLog.dateLogUID])
            ]) { (error) in
                if let error = error {
                    print("There was an error updating new person: \(error) : \(error.localizedDescription) : \(#function)")
                    completion(error)
                    return
                }
            }
        }
        completion(nil)
    }
    
    /// Fetches the dateLog for the specified person from the firestore
    ///
    /// - Parameters:
    ///   - person: The person to fetch from (Person)
    ///   - completion: error (Error)
    func fetchDateLogFromFirestore(for person: Person, completion: @escaping (Error?) -> Void) {
        db.collection("dateLog").whereField("personUID", isEqualTo: person.personUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching dateLogs: \(error) : \(error.localizedDescription) : \(#function)")
                completion(error)
                return
            }
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { completion(Errors.snapshotGuard); return }
            
            let fetchedDateLogs = snapshot.documents.compactMap { DateLog(from: $0.data(), uid: $0.documentID) }
            self.dateLogs.append(contentsOf: fetchedDateLogs)
            completion(nil)
        }
    }
}
