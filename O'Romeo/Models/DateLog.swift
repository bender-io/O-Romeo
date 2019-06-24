//
//  AddToCalendar.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

struct DateLog {
    var date: Date?
    var julietName: String?
    var event: String?
    var address: String?
    let personUID: String
    let dateLogUID: String
    var description: String?
        
    init?(from dictionary: [String: Any], uid: String) {
        guard let date = dictionary["date"] as? Date,
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
}

extension DateLog: Equatable {
    
    static func ==(lhs: DateLog, rhs: DateLog) -> Bool {
        return lhs.dateLogUID == rhs.dateLogUID
    }
}