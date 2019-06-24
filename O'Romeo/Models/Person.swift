//
//  Person.swift
//  O'Romeo
//
//  Created by Will morris on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

struct Person {
    
    let name: String
    let birthday: String?
    let anniversary: String?
    let userUID: String
    let personUID: String
    var interests: [String]?
<<<<<<< HEAD
=======
    var events: [String]?
>>>>>>> added segues from events to add calendar
    
    init?(from dictionary: [String : Any], uid: String) {
        guard let name = dictionary["name"] as? String,
            let birthday = dictionary["birthday"] as? String,
            let anniversary = dictionary["anniversary"] as? String,
            let userUID = dictionary["userUID"] as? String,
<<<<<<< HEAD
            let interests = dictionary["interests"] as? [String]
=======
            let interests = dictionary["interests"] as? [String],
            let events = dictionary["events"] as? [String]
>>>>>>> added segues from events to add calendar
            else { return nil }
        
        self.name = name
        self.birthday = birthday
        self.anniversary = anniversary
        self.userUID = userUID
        self.interests = interests
        self.personUID = uid
<<<<<<< HEAD
=======
        self.events = events
>>>>>>> added segues from events to add calendar
    }
}

extension Person: Equatable {
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.personUID == rhs.personUID
    }
}
