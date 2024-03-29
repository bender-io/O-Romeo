//
//  LaunchScreenViewController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchScreenViewController: UIViewController {
    
    // MARK: - Properties
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    // MARK: - IBOutlets
    @IBOutlet weak var launchLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchColorScheme()
        animateLayers()
        launchLogo.center = self.view.center
        view.backgroundColor = .primary
        
        // MARK: - Fetch Data
        PersonController.shared.fetchPersonsFromFirestore { (error) in
            if let error = error {
                print("There was an error fetching persons: \(error.localizedDescription): \(#function)")
            }
            // MARK: - Screen Segues
            let login: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let home: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let _ = Auth.auth().currentUser {
                    let homeViewController = home.instantiateViewController(withIdentifier: "HomeViewController")
                    UIApplication.shared.windows.first!.rootViewController = homeViewController
                } else {
                    let loginViewController = login.instantiateViewController(withIdentifier: "LoginViewController")
                    UIApplication.shared.windows.first!.rootViewController = loginViewController
                }
            }
        }
    }
    
    // MARK: - UserDefaults Methods
    func fetchColorScheme() {
        let scheme = UserDefaults.standard.string(forKey: "ColorScheme")
        
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
    
    // MARK: - Animation Methods
    func animateLayers() {
        createShapeLayer()
        createTrackLayer()
        runAnimation()
    }
    
    func createShapeLayer() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 90, startAngle: (-CGFloat.pi / 2), endAngle: (2 * CGFloat.pi), clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.highlights.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    func createTrackLayer() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 90, startAngle: (-CGFloat.pi / 2), endAngle: (2 * CGFloat.pi), clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.white10.cgColor
        trackLayer.lineWidth = 10
        view.layer.addSublayer(trackLayer)
    }
    
    func runAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}
