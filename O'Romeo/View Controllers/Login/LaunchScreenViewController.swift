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
    var window : UIWindow?
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createShapeLayer()
        createTrackLayer()
        runAnimation()
        
        // MARK: - Screen Segues
        let login: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let _ = Auth.auth().currentUser {
                let homeViewController = home.instantiateViewController(withIdentifier: "HomeViewController")
                UIApplication.shared.windows.first!.rootViewController = homeViewController
                self.window?.makeKeyAndVisible()
            } else {
                let loginViewController = login.instantiateViewController(withIdentifier: "LoginViewController")
                self.window?.rootViewController = loginViewController
                self.window?.makeKeyAndVisible()
            }
        }
    }
    

// MARK: - Animation Methods
func createShapeLayer() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: (-CGFloat.pi / 2), endAngle: (2 * CGFloat.pi), clockwise: true)        
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
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: (-CGFloat.pi / 2), endAngle: (2 * CGFloat.pi), clockwise: true)
        
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
