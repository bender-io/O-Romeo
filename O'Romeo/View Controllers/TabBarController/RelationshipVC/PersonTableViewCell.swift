//
//  PersonTableViewCell.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let person = person else { print("Couldn't unwrap person: \(#function)"); return }
        
        nameLabel.text = person.name
//        cityLabel.text = person.city
//        distanceLabel.text = person.distance
    }
}
