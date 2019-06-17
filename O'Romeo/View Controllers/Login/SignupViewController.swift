//
//  SignupViewController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/15/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 5
    }
    
    // MARK: - IBActions
    @IBAction func signupButtonTapped(_ sender: UIButton) {
    }
}
