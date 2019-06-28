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

    @IBOutlet weak var searchImageView: CustomImageView!
    @IBOutlet weak var searchNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: RomeoButtonText!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var yelp: Yelp? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SearchTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .white10
    }
    
    func updateViews() {
        guard let yelp = yelp,
            let rating = yelp.rating,
            let categories = yelp.categories?.first?.title,
            let location = yelp.location?.displayAddress.first
            else { return }
        self.searchNameLabel.text = yelp.name
        self.ratingLabel.text = "Rating: \(rating)"
        self.categoriesLabel.text = categories
        self.directionsLabel.text = location
        self.phoneNumberButton.setTitle(yelp.displayPhone, for: .normal)
        self.distanceLabel.text = "\((yelp.distance / 1609.344).rounded(.down)) mi"
        searchImageView.fetchImageFor(yelp: yelp)
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        guard let yelp = yelp else { return }
        delegate?.calendarButtonTapped(yelp: yelp)
    }
    
    @IBAction func phoneNumberButtonTapped(_ sender: Any) {
        guard let yelp = yelp, let yelpNumber = yelp.displayPhone else { return }
        let number = yelpNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
