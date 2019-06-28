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
    let login : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let splashScreen : UIStoryboard = UIStoryboard(name: "SplashScreen", bundle: nil)
    var selectedColor = ColorScheme.standard
    
    // MARK: - IBOutlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        tabBarController?.tabBar.tintColor = .highlights
        tabBarController?.tabBar.barTintColor = .primary
        navigationController?.navigationBar.tintColor = .highlights
        navigationController?.navigationBar.barTintColor = .primary
        segmentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "CurrentSegment") 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // MARK: - IBActions
    @IBAction func segmentControlTapped(_ sender: Any) {
        let currentSegment = segmentControl.selectedSegmentIndex
        
        switch currentSegment {
        case 0:
            selectedColor = ColorScheme.standard
            
        case 1:
            selectedColor = ColorScheme.standard
            colorPicker(scheme: selectedColor)
            UserDefaults.standard.set(currentSegment, forKey: "CurrentSegment")
            loadView()
            viewDidLoad()
            
        case 2:
            selectedColor = ColorScheme.dark
            colorPicker(scheme: selectedColor)
            UserDefaults.standard.set(currentSegment, forKey: "CurrentSegment")
            loadView()
            viewDidLoad()

        case 3:
            selectedColor = ColorScheme.light
            colorPicker(scheme: selectedColor)
            UserDefaults.standard.set(currentSegment, forKey: "CurrentSegment")
            loadView()
            viewDidLoad()
            
        default:
            selectedColor = ColorScheme.standard
        }
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(selectedColor, forKey: "ColorScheme")
        print("Color \(selectedColor) saved to UserDefaults")
        let splashScreenViewController = splashScreen.instantiateViewController(withIdentifier: "SplashScreenVC")
        UIApplication.shared.windows.first!.rootViewController = splashScreenViewController
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserController.shared.signOutUser()
        
        PersonController.shared.persons = []
        InterestController.shared.interests = []
        DateLogController.shared.dateLogs = []
        
        let loginViewController = login.instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.shared.windows.first!.rootViewController = loginViewController
    }
    
    func colorPicker(scheme: String?) {
        
        switch scheme {
        case ColorScheme.standard:
            UIColor.highlights = UIColor.STHighlights
            UIColor.primary = UIColor.STPrimary
            UIColor.secondary = UIColor.STSecondary
            UIColor.white100 = UIColor.STWhite100
            UIColor.white50 = UIColor.STWhite50
            UIColor.white10 = UIColor.STWhite10
            
        case ColorScheme.dark:
            UIColor.highlights = UIColor.DMHighlights
            UIColor.primary = UIColor.DMPrimary
            UIColor.secondary = UIColor.DMSecondary
            UIColor.white100 = UIColor.DMWhite100
            UIColor.white50 = UIColor.DMWhite50
            UIColor.white10 = UIColor.DMWhite10
            
        case ColorScheme.light:
            UIColor.highlights = UIColor.LMHighlights
            UIColor.primary = UIColor.LMPrimary
            UIColor.secondary = UIColor.LMSecondary
            UIColor.white100 = UIColor.LMWhite100
            UIColor.white50 = UIColor.LMWhite50
            UIColor.white10 = UIColor.LMWhite10
            
        default:
            UIColor.highlights = UIColor.STHighlights
            UIColor.primary = UIColor.STPrimary
            UIColor.secondary = UIColor.STSecondary
            UIColor.white100 = UIColor.STWhite100
            UIColor.white50 = UIColor.STWhite50
            UIColor.white10 = UIColor.STWhite10
        }
    }
}
