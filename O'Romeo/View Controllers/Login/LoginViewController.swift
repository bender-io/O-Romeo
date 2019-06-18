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
        guard let loginText = loginTextField.text,
            let passwordText = passwordTextField.text
            else { print("Couldn't unwrap textfield text: \(#function)"); return }
        UserController.shared.signInUserWith(email: loginText, password: passwordText) { (error) in
            if let error = error {
                print("There was an error: \(error) : \(#function)")
                self.presentLoginErrorAlert()
            }
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Methods
    
    func presentLoginErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Login Failed", message: "The Email or Password is Incorrect", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
}
