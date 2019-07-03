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
        formatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
        let date = formatter.date(from: self)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let newDate = formatter.string(from: date!)
        return formatter.date(from: newDate)!
    }
    
    func asDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let date = formatter.date(from: self)
        return "\(date!)"
    }
    
    func asEventDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: self)
        formatter.dateFormat = "MMM dd, yyyy 'at' hh:mm a"
        return formatter.string(from: date!)
    }
    }
