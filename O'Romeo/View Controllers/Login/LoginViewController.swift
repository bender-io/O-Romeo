//
//  LoginViewController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
    }
}
