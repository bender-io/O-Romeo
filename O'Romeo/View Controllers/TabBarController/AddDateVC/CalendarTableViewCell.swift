//
//  CalendarTableViewCell.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/24/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    var dateLog: DateLog? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var julietNameLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .primary
        julietNameLabel.textColor = .highlights
        eventNameLabel.textColor = .white100
        addressLabel.textColor = .white100
        dateLabel.textColor = .white100
    }

    func updateViews() {
        guard let dateLog = dateLog else { return }
        self.julietNameLabel.text = dateLog.julietName
        self.eventNameLabel.text = dateLog.event
        self.addressLabel.text = dateLog.address
        self.dateLabel.text = dateLog.date
    }
}
