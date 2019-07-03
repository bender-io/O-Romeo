//
//  Interest.swift
//  O'Romeo
//
//  Created by Will morris on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

struct Interest {
    
    // MARK: - Properties
    var name: String
    var description: String
    let personUID: String
    let interestUID: String
    
    init?(from dictionary: [String : Any], uid: String) {
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let personUID = dictionary["personUID"] as? String
            else { return nil }
        
        self.name = name
        self.description = description
        self.personUID = personUID
        self.interestUID = uid
    }
}

extension Interest: Equatable {
    
    static func ==(lhs: Interest, rhs: Interest) -> Bool {
        return lhs.name == rhs.name
    }
}

