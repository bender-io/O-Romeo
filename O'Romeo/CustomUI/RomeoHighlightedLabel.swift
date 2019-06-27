//
//  RomeoHighlightedLabel.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/27/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class RomeoHighlightedLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.textColor = .highlights
    }
}
