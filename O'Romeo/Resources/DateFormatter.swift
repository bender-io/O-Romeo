//
//  DateFormatter.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/24/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

extension String {
    func asDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter.date(from: self) ?? Date()
    }
    
    func shortDateStyle() -> String {
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let date = formatter.date(from: self) ?? Date()
        return "\(date)"
    }
}
