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
    static let primary = UIColor(named: "Primary")!
    static let secondary = UIColor(named: "Secondary")!
    static let highlights = UIColor(named: "Highlights")!
    static let white10 = UIColor(named: "White10")!
    static let white50 = UIColor(named: "White50")!
    static let white100 = UIColor(named: "White100")!
}
