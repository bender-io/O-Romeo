//
//  TapGestures.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/22/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Keyboard Dismiss Method
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
