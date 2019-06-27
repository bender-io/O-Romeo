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
    var selectedColor = ColorScheme.standard
    
    // MARK: - IBOutlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        view.backgroundColor = .primary
    }
    
    // MARK: - IBActions
    @IBAction func segmentControlTapped(_ sender: Any) {
        let currentSegment = segmentControl.selectedSegmentIndex
        
        switch currentSegment {
        case 0:
            selectedColor = ColorScheme.standard
        case 1:
            selectedColor = ColorScheme.dark
            UIColor.highlights = UIColor.DMHighlights
            UIColor.primary = UIColor.DMPrimary
            UIColor.secondary = UIColor.DMSecondary
            UIColor.white100 = UIColor.DMWhite100
            UIColor.white50 = UIColor.DMWhite50
            UIColor.white10 = UIColor.DMWhite10
            view.reloadInputViews()
        case 2:
            selectedColor = ColorScheme.light
        default:
            selectedColor = ColorScheme.standard
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserController.shared.signOutUser()
        
        PersonController.shared.persons = []
        InterestController.shared.interests = []
        DateLogController.shared.dateLogs = []
        
        let loginViewController = login.instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.shared.windows.first!.rootViewController = loginViewController
    }
}
