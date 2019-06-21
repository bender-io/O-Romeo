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
    }
    
    // MARK: - IBActions
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        guard let emailText = emailTextField.text,
            let passwordText = passwordTextField.text
            else { print("Couldnt unwrap email and password text: \(#function)"); return }
        UserController.shared.createUserWith(email: emailText, password: passwordText) { (error) in
            if let error = error {
                print("There was an error creating a new user: \(error.localizedDescription): \(#function)")
                self.presentSignupErrorAlert()
            }
        }
    }
    
    // MARK: - Methods
    
    func presentSignupErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Signup Failed", message: "This Email address belongs to another account", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
}
