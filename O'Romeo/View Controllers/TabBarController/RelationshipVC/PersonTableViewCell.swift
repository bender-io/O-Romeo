//
//  PersonTableViewCell.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var anniversaryLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    // TODO: - Drag View Outlet & Change Color
    // TODO: - Link RomeoBarButton UI

    var person: Person? {
        didSet {
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .white10
        nameLabel.textColor = .highlights
        anniversaryLabel.textColor = .white100
        birthdayLabel.textColor = .white100
    }
    
    // MARK: - Cell Methods
    func updateViews() {
        guard let person = person else { print("Couldn't unwrap person: \(#function)"); return }
        nameLabel.text = person.name
        anniversaryLabel.text = person.anniversary
        birthdayLabel.text = person.birthday
    }
}
