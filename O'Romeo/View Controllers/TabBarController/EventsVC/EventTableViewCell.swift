//
//  EventTableViewCell.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import MapKit

protocol EventTableViewCellDelegate: class {
    func calendarButtonTapped(event: Event)
}

class EventTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var eventImageView: CustomImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var addressButton: RomeoButtonText!
    
    @IBOutlet weak var cellViewDivider: RomeoView!
    @IBOutlet weak var cellViewFooter: RomeoView!
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: EventTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .white10
        cellViewDivider.backgroundColor = .primary
        cellViewFooter.backgroundColor = .primary
        eventNameLabel.textColor = .highlights
        cityLabel.textColor = .white100
        descriptionLabel.textColor = .white100
        dateLabel.textColor = .white100
        urlButton.setTitleColor(.highlights, for: .normal)
        addressButton.setTitleColor(.highlights, for: .normal)
    }
    
    func updateViews() {
        guard let event = event else { return }
        self.eventNameLabel.text = event.title
        self.addressButton.setTitle(event.venueAddress, for: .normal)
        self.cityLabel.text = event.cityName
        self.descriptionLabel.text = event.eventDescription
        self.dateLabel.text = event.startTime.asEventDateString()
        self.urlButton.setTitle("Click here for more details", for: .normal)
        eventImageView.fetchImageFor(eventful: event)
    }
    
    @IBAction func calendarButtonTapped(_ sender: Any) {
        guard let event = event else { return }
        delegate?.calendarButtonTapped(event: event)
    }
    
    @IBAction func urlButtonTapped(_ sender: Any) {
        guard let event = event else { return }
        let eventURL = NSURL(string: event.url!)! as URL
        UIApplication.shared.open(eventURL, options: [:], completionHandler: nil)
    }
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        guard let street = event?.venueAddress,
            let city = event?.cityName
            else { return }
        let address = street + ", " + city
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print(error)
            }
            if let location = placemarks?.first?.location, let name = self.event?.venueName{
                let coordinates = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                let option = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinates)]
                let placemark = MKPlacemark(coordinate: coordinates)
                let mapitem = MKMapItem(placemark: placemark)
                mapitem.name = name
                mapitem.openInMaps(launchOptions: option)
            }
        }
    }
}
