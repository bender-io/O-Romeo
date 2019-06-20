//
//  RomeoButton.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class RomeoButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Button Methods
    func updateFontTo(fontName: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: fontName, size: size)
    }
    
    func setupUI() {
        updateFontTo(fontName: FontNames.sfRegular)
        self.backgroundColor = .secondary
        self.cornerRadios()
        self.setTitleColor(.white100, for: .normal)
    }
}
