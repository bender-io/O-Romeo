//
//  extensions.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

extension UIView {
    
    func cornerRadios(_ radius: CGFloat = 5) {
        self.layer.cornerRadius = radius
    }
    
    func rotate(by radians: CGFloat = (-CGFloat.pi / 2)) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}

enum FontNames {
    static let sfBlack = "SF-Compact-Rounded-Black"
    static let sfBold = "SF-Compact-Rounded-Bold"
    static let sfHeavy = "SF-Compact-Rounded-Heavy"
    static let sfLight = "SF-Compact-Rounded-Light"
    static let sfMedium = "SF-Compact-Rounded-Medium"
    static let sfRegular = "SF-Compact-Rounded-Regular"
    static let sfSemibold = "SF-Compact-Rounded-Semibold"
    static let sfThin = "SF-Compact-Rounded-Thin"
    static let sfUltralight = "SF-Compact-Rounded-Ultralight"
}

extension UIColor {
    static var primary = UIColor(named: "Primary")!
    static var secondary = UIColor(named: "Secondary")!
    static var highlights = UIColor(named: "Highlights")!
    static var white10 = UIColor(named: "White10")!
    static var white50 = UIColor(named: "White50")!
    static var white100 = UIColor(named: "White100")!
    
    static var DMPrimary = UIColor(named: "DMPrimary")!
    static var DMSecondary = UIColor(named: "DMSecondary")!
    static var DMHighlights = UIColor(named: "DMHighlights")!
    static var DMWhite10 = UIColor(named: "DMWhite10")!
    static var DMWhite50 = UIColor(named: "DMWhite50")!
    static var DMWhite100 = UIColor(named: "DMWhite100")!
}
