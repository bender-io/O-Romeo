//
//  AddDateViewController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class AddDateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var julietNameTF: RomeoTextField!
    @IBOutlet weak var dateTF: RomeoTextField!
    @IBOutlet weak var eventTF: RomeoTextField!
    @IBOutlet weak var dateLocationTF: RomeoTextField!
    
    // MARK: - Properties
    var dateLog: DateLog?
    var event: Event?
    var person: Person?
    var yelp: Yelp?
    var personUID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setupPicker()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Methods
    func updateViews() {
        if let event = event {
            julietNameTF.text = ""
            dateTF.text = event.startTime
            eventTF.text = event.title
            dateLocationTF.text = event.venueName
        } else if let yelp = yelp {
            julietNameTF.text = ""
            dateTF.text = ""
            eventTF.text = yelp.name
            dateLocationTF.text = yelp.location!.displayAddress.first
        } else if let dateLog = dateLog {
            julietNameTF.text = dateLog.julietName
            dateTF.text = "\(dateLog.date)"
            eventTF.text = dateLog.event
            dateLocationTF.text = dateLog.address
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return resignFirstResponder()
    }
    
    // MARK: - DatePicker Methods
    @IBAction func datePickerSelected(_ sender: RomeoTextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.backgroundColor = .black
        datePickerView.setValue(UIColor.highlights, forKeyPath: "textColor")
        datePickerView.addTarget(self, action: #selector(AddDateViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateTF.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - // MARK: - DropDownPicker Methods
    func setupPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = .black
        julietNameTF.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PersonController.shared.persons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PersonController.shared.persons[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        julietNameTF.text = PersonController.shared.persons[row].name
        personUID = PersonController.shared.persons[row].personUID
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let person = PersonController.shared.persons[row].name
        return NSAttributedString(string: person, attributes: [NSAttributedString.Key.foregroundColor: UIColor.highlights])
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let julietName = julietNameTF.text, let date = dateTF.text, let event = eventTF.text, let address = dateLocationTF.text, let personUID = personUID
            else { return }
        
        if let dateLog = dateLog {
            DateLogController.shared.updateDateLog(dateLog: dateLog, date: date.asDate(), julietName: julietName, event: event, address: address, description: "")
        } else {
            DateLogController.shared.createDateLog(date: date, julietName: julietName, event: event, address: address, personUID: personUID, description: "") { (error) in
                if let error = error {
                    print("Error saving to calendar 🤬 \(error.localizedDescription)")
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
