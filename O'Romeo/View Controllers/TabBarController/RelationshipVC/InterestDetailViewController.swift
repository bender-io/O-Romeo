//
//  InterestDetailViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class InterestDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: RomeoTextField!
    
    var interest: Interest?
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let interest = interest else { print("Could not unwrap interest: \(#function)"); return }
        nameTextField.text = interest.name
        descriptionTextField.text = interest.description
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            let description = descriptionTextField.text
            else { print("Couldn't unwrap textfields: \(#function)"); return }
        
        if let interest = interest {
            InterestController.shared.updateInterest(interest: interest, name: name, description: description)
        } else if let person = person {
            InterestController.shared.createInterestFor(personUID: person.personUID, name: name, description: description) { (error) in
                if let error = error {
                    print("There was an error creating an interest: \(error.localizedDescription): \(#function)")
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

