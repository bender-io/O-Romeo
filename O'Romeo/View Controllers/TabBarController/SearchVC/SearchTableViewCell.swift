//
//  SearchTableViewCell.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate: class {
    func calendarButtonTapped(yelp: Yelp)
}

class SearchTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

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
    
    weak var delegate: SearchTableViewCellDelegate?

    func updateViews() {
        guard let yelp = yelp,
            let rating = yelp.rating,
            let categories = yelp.categories?.first?.title,
            let location = yelp.location?.displayAddress.first
            else { return }
        self.searchNameLabel.text = yelp.name
        self.ratingLabel.text = String(rating)
        self.categoriesLabel.text = categories
        self.directionsLabel.text = location
        self.phoneNumberLabel.text = yelp.displayPhone
        YelpController.shared.fetchImageFor(yelp: yelp) { (image) in
            DispatchQueue.main.async {
                self.searchImageView.image = image
            }
        }
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        guard let yelp = yelp else { return }
        delegate?.calendarButtonTapped(yelp: yelp)
    }
}
