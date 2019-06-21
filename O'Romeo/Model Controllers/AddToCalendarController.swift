//
//  AddToCalendarController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

class AddToCalendarController {
    
    static let shared = AddToCalendarController()
    
    var addToCalendarArray: [Calendar] = []
    
    func addToCalendar(date: Date, time: String, julietName: String, event: String, address: String) {
        let addedToCalendar = Calendar(date: date, time: time, julietName: julietName, event: event, address: address)
        addToCalendarArray.append(addedToCalendar)
    }
    
    func deleteEvents(calendar: Calendar) {
        guard let eventsToDelete = addToCalendarArray.firstIndex(of: calendar) else { return }
        addToCalendarArray.remove(at: eventsToDelete)
    }
    
    func updateEvents(calendar: Calendar, date: Date, time: String, julietName: String, event: String, address: String) {
        calendar.date = date
        calendar.time = time
        calendar.julietName = julietName
        calendar.event = event
        calendar.address = address
    }
}
