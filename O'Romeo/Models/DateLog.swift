//
//  AddToCalendar.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

struct DateLog {
    var date: String
    var julietName: String?
    var event: String?
    var address: String?
    let personUID: String?
    let dateLogUID: String
    var description: String?
    
//    init(date: Date, julietName: String)
    init(date: String, julietName: String, event: String, address: String, personUID: String, dateLogUID: String, description: String) {
        self.date = date
        self.julietName = julietName
        self.event = event
        self.address = address
        self.personUID = personUID
        self.dateLogUID = dateLogUID
        self.description = description
    }
    
    init?(from dictionary: [String: Any], uid: String) {
        guard let date = dictionary["date"] as? String,
            let julietName = dictionary["julietName"] as? String,
            let event = dictionary["event"] as? String,
            let address = dictionary["address"] as? String,
            let personUID = dictionary["personUID"] as? String,
            let description = dictionary["description"] as? String
            else { return nil }
        
        self.date = date
        self.julietName = julietName
        self.event = event
        self.address = address
        self.personUID = personUID
        self.description = description
        self.dateLogUID = uid
    }
    
    init(event: Event, personUID: String, dateLogUID: String, julietName: String) {
        //self.date = event.startTime.asDate()
        self.date = event.startTime
        self.event = event.title
        self.address = event.venueAddress
        self.personUID = personUID
        self.dateLogUID = UUID().uuidString
        self.julietName = julietName
    }
}

extension DateLog: Equatable {
    
    static func ==(lhs: DateLog, rhs: DateLog) -> Bool {
        return lhs.dateLogUID == rhs.dateLogUID
    }
}
