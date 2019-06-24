//
//  AddDateViewController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class AddDateViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var julietNameTF: RomeoTextField!
    @IBOutlet weak var dateTF: RomeoTextField!
    @IBOutlet weak var eventTF: RomeoTextField!
    @IBOutlet weak var dateLocationTF: RomeoTextField!
    
    var dateLog: DateLog?
        
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    func updateViews() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return resignFirstResponder()
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let julietName = julietNameTF.text, let date = dateTF.text?.asDate(), let event = eventTF.text, let address = dateLocationTF.text, let person = person
        else { return }
        DateLogController.shared.createCalendarEvent(date: date, julietName: julietName, event: event, address: address, personUID: person.personUID, description: "") { (error) in
            if let error = error {
                print("Error saving to calendar 🤬 \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
