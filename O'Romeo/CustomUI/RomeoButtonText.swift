//
//  RomeoButtonText.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/27/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class RomeoButtonText: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Button Methods
    func setupUI() {
        self.setTitleColor(.highlights, for: .normal)
    }
}
