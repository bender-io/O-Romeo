//
//  InterestDetailViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class InterestDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: RomeoHighlightedTextField!

    // MARK: - Properties
    var interest: Interest?
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        guard let interest = interest else { print("Could not unwrap interest: \(#function)"); return }
        nameTextField.text = interest.name
        descriptionTextField.text = interest.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .primary
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill in the name and description", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            !name.isEmpty,
            let description = descriptionTextField.text,
            !description.isEmpty
            else { print("Couldn't unwrap textfields: \(#function)"); presentAlert(); return }

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
