//
//  SearchTableViewCell.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var yelp: Yelp? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let yelp = yelp else { return }
        self.searchNameLabel.text = yelp.name
        self.ratingLabel.text = String(yelp.rating)
        self.categoriesLabel.text = yelp.categories.first?.title
        self.directionsLabel.text = yelp.location.displayAddress.first
        self.phoneNumberLabel.text = yelp.displayPhone
        
    }
}
