//
//  LocalNotificationsController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/24/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import UserNotifications

protocol CalendarScheduler : class {
    func scheduleUserNotifications(for calendar: Calendar)
    func cancelUserNotifications(for calendar: Calendar)
}

class LocalNotificationsController {
    
    var isOn : Bool = true
    
    // MARK: - Singleton
    static let shared = LocalNotificationsController()
    
    // MARK: - CRUD Methods
    func createDateReminderFor(name: String, time: Date?, at event: String?, address: String?, isON: Bool = true) {
        let calendar = Calendar(date: <#T##String#>, julietName: <#T##String#>, event: <#T##String#>, address: <#T##String#>)
        scheduleUserNotifications(for: calendar)
    }
}

extension LocalNotificationsController : CalendarScheduler {
    func scheduleUserNotifications(for calendar: Calendar) {
        let notificationSound = UNNotificationSound.default
        let notificationContent = UNMutableNotificationContent()
        notificationContent.badge = .init(integerLiteral: 1)
        notificationContent.title = "Ready for that date?"
        notificationContent.body = "You got this"
        notificationContent.sound = notificationSound
        
//        let dateComponents = Calendar.
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: false)
    }
    
    func cancelUserNotifications(for calendar: Calendar) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
