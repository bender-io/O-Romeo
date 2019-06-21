//
//  AddToCalendar.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

class Calendar: Equatable {
    var date: Date?
    var time: String?
    var julietName: String
    var event: String?
    var address: String
    
    init(date: Date = Date(), time: String, julietName: String, event: String, address: String) {
        self.date = date
        self.time = time
        self.julietName = julietName
        self.event = event
        self.address = address
    }
    
    static func ==(lhs: Calendar, rhs: Calendar) -> Bool {
        return lhs.date == rhs.date &&
        lhs.time == rhs.time &&
        lhs.julietName == rhs.julietName &&
        lhs.event == rhs.event &&
        lhs.address == rhs.address
    }
}
