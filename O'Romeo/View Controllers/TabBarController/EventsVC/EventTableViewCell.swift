//
//  EventTableViewCell.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let event = event else { return }
        self.eventNameLabel.text = event.title
        self.eventAddressLabel.text = event.venueAddress
        self.cityLabel.text = event.cityName
        self.descriptionLabel.text = event.eventDescription
        self.dateLabel.text = event.startTime
        self.urlButton.titleLabel?.text = event.url
        
        EventfulController.shared.fetchImageFor(eventful: event) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.eventImageView.image = image
                }
            }
        }
    }
}
