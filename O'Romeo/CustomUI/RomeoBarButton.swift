//
//  RomeoBarButton.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/27/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class RomeoBarButton: UIBarButtonItem {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.tintColor = .highlights
    }
}
