//
//  LogoutViewController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/26/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogoutViewController: UIViewController {

    // MARK: - Properties
    let login: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserController.shared.signOutUser()
        
        PersonController.shared.persons = []
        InterestController.shared.interests = []
        DateLogController.shared.dateLogs = []
        
        let loginViewController = login.instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.shared.windows.first!.rootViewController = loginViewController
    }
}
