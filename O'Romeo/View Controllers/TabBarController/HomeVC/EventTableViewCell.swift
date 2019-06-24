//
//  EventTableViewCell.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let event = event else { return }
        self.eventNameLabel.text = event.title
        self.eventAddressLabel.text = event.venueAddress

        EventfulController.shared.fetchImageFor(eventful: event) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.eventImageView.image = image
                }
            }
        }
    }
}
