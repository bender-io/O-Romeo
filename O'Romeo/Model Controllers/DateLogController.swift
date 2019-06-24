//
//  CalendarController.swift
//  O'Romeo
//
//  Created by Will morris on 6/24/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import Firebase

class CalendarController {
    
    static let shared = CalendarController()
    
    var dateLogs: [DateLog] = []
    
    let db = UserController.shared.db
    
    func createCalendarEvent(date: Date, julietName: String, event: String, address: String, personUID: String, description: String, completion: @escaping (Error?) -> Void) {
        
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
                } else {
                    guard let docID = ref?.documentID else { completion(Errors.unwrapDocumentID); return }
                    PersonController.shared.updatePersonDateLog(for: personUID, with: docID, completion: { (error) in
                        if let error = error {
                            print("There was an error: \(error.localizedDescription) : \(#function)")
                        }
                    })
                }
                completion(nil)
        })
    }
    
    func updateEvents(dateLog: DateLog, date: Date, julietName: String, event: String, address: String, description: String) {
        db.collection("dateLog").document(dateLog.dateLogUID).updateData([
            "date" : date,
            "julietName" : julietName,
            "event" : event,
            "address" : address,
            "description" : description
        ]) { (error) in
            if let error = error {
                print("There was an error updating the calendar event: \(error) : \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func fetchCalendarEventsFromFirestore(for person: Person, completion: @escaping (Error?) -> Void) {
        db.collection("dateLog").whereField("personUID", isEqualTo: person.personUID).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching calendar events: \(error) : \(error.localizedDescription) : \(#function)")
            }
            
            guard let snapshot = snapshot,
                snapshot.documents.count > 0
                else { completion(Errors.snapshotGuard); return }
            
            self.dateLogs = snapshot.documents.compactMap { DateLog(from: $0.data(), uid: $0.documentID) }
            completion(nil)
        }
    }
}
