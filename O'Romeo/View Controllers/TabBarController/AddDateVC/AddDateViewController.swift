//
//  AddDateViewController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/21/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class AddDateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    var dateLog: DateLog?
    var event: Event?
    var person: Person?
    var yelp: Yelp?
    var personUID : String?
    var newPerson: Person?
    var personArray: [Person] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var julietNameTF: RomeoHighlightedTextField!
    @IBOutlet weak var dateTF: RomeoHighlightedTextField!
    @IBOutlet weak var eventTF: RomeoHighlightedTextField!
    @IBOutlet weak var dateLocationTF: RomeoHighlightedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personArray = PersonController.shared.persons.sorted(by: { $0.name < $1.name })
        updateViews()
        setupPicker()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .primary
        if PersonController.shared.persons.isEmpty {
            presentAlert()
        }
    }
    
    // MARK: - Methods
    func updateViews() {
        if let event = event {
            julietNameTF.text = ""
            dateTF.text = event.startTime.asEventDateString()
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
    
    func presentAlert() {
        let alert = UIAlertController(title: "No Relationships", message: "Please create a relationship", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay! Take me there.", style: .default) { (_) in
            let tab = self.presentingViewController as? UITabBarController
            tab?.selectedIndex = 3
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
    
    // MARK: - DatePicker Methods
    @IBAction func datePickerSelected(_ sender: RomeoHighlightedTextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.backgroundColor = .black
        datePickerView.setValue(UIColor.highlights, forKeyPath: "textColor")
        datePickerView.addTarget(self, action: #selector(AddDateViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
        if let text = dateTF.text, !text.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let date = dateFormatter.date(from: text)
            datePickerView.date = date!
        } else {
            datePickerValueChanged(sender: datePickerView)
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateTF.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - DropDownPicker Methods
    func setupPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.backgroundColor = .black
        julietNameTF.inputView = pickerView
        if let text = julietNameTF.text, text.isEmpty {
        julietNameTF.text = personArray.first?.name
            personUID = personArray.first?.personUID
            newPerson = personArray.first
        } else {
            guard let index = personArray.firstIndex(where: { $0.personUID == dateLog?.personUID }) else { return }
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return personArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return personArray[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        julietNameTF.text = personArray[row].name
        personUID = personArray[row].personUID
        newPerson = personArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let person = personArray[row].name
        return NSAttributedString(string: person, attributes: [NSAttributedString.Key.foregroundColor: UIColor.highlights])
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let julietName = julietNameTF.text, !julietName.isEmpty, let date = dateTF.text, !date.isEmpty, let event = eventTF.text, let address = dateLocationTF.text
            else { return }
        
        if let dateLog = dateLog {
            DateLogController.shared.updateDateLog(dateLog: dateLog, date: date, person: newPerson, event: event, address: address, description: "") { (error) in
                if let error = error {
                    print("There was an error updating the dateLog: \(error) : \(#function)")
                }
            }
        } else {
            guard let personUID = personUID else { return }
            DateLogController.shared.createDateLog(date: date, julietName: julietName, event: event, address: address, personUID: personUID, description: "") { (error) in
                if let error = error {
                    print("Error saving to calendar 🤬 \(error.localizedDescription) : \(#function)")
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
