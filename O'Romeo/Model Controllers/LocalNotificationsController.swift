//
//  LocalNotificationsController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/24/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation
import UserNotifications

protocol LocalNotificationScheduler : class {
    func scheduleUserNotifications(for time: Date, uid: String)
    func cancelUserNotifications(for uid: String)
}

class LocalNotificationsController {
    
    // MARK: - Singleton
    static let shared = LocalNotificationsController()
    static let notificationID = "LocalNotification"
    private init() {}

}

extension LocalNotificationsController : LocalNotificationScheduler {
    func scheduleUserNotifications(for time: Date, uid: String) {
        let notificationSound = UNNotificationSound.default
        let notificationContent = UNMutableNotificationContent()
        notificationContent.badge = .init(integerLiteral: 1)
        notificationContent.title = "Ready for that date?"
        notificationContent.body = "You got this"
        notificationContent.sound = notificationSound
        
        // TODO: - Test and Replace with One Day Before
//        let oneDayBeforeDate = Date(timeInterval: -86400, since: time)
        let thirtySecondsBeforeDate = Date(timeInterval: -30, since: time)
        let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: thirtySecondsBeforeDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "LocalNotification", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(" 🐌 Snail it found in \(#function) : \(error.localizedDescription) : \(error)")
            }
        }
    }
    
    func cancelUserNotifications(for uid: String) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
