//
//  AddDateViewController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class AddDateViewController: UIViewController {
    
    @IBOutlet weak var julietNameTF: RomeoTextField!
    @IBOutlet weak var dateTF: RomeoTextField!
    @IBOutlet weak var eventTF: RomeoTextField!
    @IBOutlet weak var dateLocationTF: RomeoTextField!
    
    var calendar: Calendar? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard let calendar = calendar else { return }
        julietNameTF.text = calendar.julietName
        dateTF.text = calendar.date
        eventTF.text = calendar.event
        dateLocationTF.text = calendar.address
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let julietName = julietNameTF.text, let date = dateTF.text, let event = eventTF.text, let address = dateLocationTF.text else { return }
        AddToCalendarController.shared.addToCalendar(date: date, julietName: julietName, event: event, address: address)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
