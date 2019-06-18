//
//  RomeoTextField.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class RomeoTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - TextField Methods
    func updatePlaceholderColor() {
        let currentPlaceholderText = self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: currentPlaceholderText ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white50 , NSAttributedString.Key.font : UIFont(name: FontNames.sfLight, size: 14) as Any])
    }
    
    func updateFontTo(fontName: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: fontName, size: size)
    }
    
    func setupUI() {
        updatePlaceholderColor()
        updateFontTo(fontName: FontNames.sfRegular)
        self.textColor = .highlights
        self.backgroundColor = .white10
        self.cornerRadios(10)
    }
}
