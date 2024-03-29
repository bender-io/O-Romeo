//
//  PersonDetailViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    var interestArray: [Interest] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var julietNameTF: UITextField!
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var anniversaryTF: UITextField!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var addMoreButton: UIButton!
    @IBOutlet weak var interestsLabel: UILabel!

    // MARK: - Landing Pad
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .primary
        tableView.backgroundColor = .white10
        updateViews()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        InterestController.shared.interests = []
    }

    // MARK: - IBActions
    @IBAction func birthdayFieldTapped(_ sender: RomeoHighlightedTextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.backgroundColor = .black
        datePickerView.setValue(UIColor.highlights, forKeyPath: "textColor")
        datePickerView.addTarget(self, action: #selector(AddDateViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
        if let text = birthdayTF.text, !text.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            let date = dateFormatter.date(from: text)
            datePickerView.date = date!
        } else {
            datePickerValueChanged(sender: datePickerView)
        }
    }
    
    @IBAction func anniversaryFieldTapped(_ sender: RomeoHighlightedTextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        datePickerView.backgroundColor = .black
        datePickerView.setValue(UIColor.highlights, forKeyPath: "textColor")
        datePickerView.addTarget(self, action: #selector(AddDateViewController.datePickerValueChanged), for: UIControl.Event.valueChanged)
        if let text = anniversaryTF.text, !text.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            let date = dateFormatter.date(from: text)
            datePickerView.date = date!
        } else {
            datePickerValueChanged(sender: datePickerView)
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        if birthdayTF.isFirstResponder {
            birthdayTF.text = dateFormatter.string(from: sender.date)
        }
        else if anniversaryTF.isFirstResponder {
            anniversaryTF.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = julietNameTF.text, let anniversary = anniversaryTF.text, let birthday = birthdayTF.text  else { return }
        if let person = person {
            PersonController.shared.updatePersonInfo(for: person.personUID, name: name, birthday: birthday, anniversary: anniversary) {
                (error) in
                if let error = error {
                    print("There was an error updating the person info: \(error.localizedDescription): \(#function)")
                }
            }

        } else {
            PersonController.shared.createPersonWith(name: name, anniversary: anniversary, birthday: birthday) { (error) in
                if let error = error {
                    print("\(error.localizedDescription): \(#function)")
                }

            }
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addMoreButtonTapped(_ sender: Any) {

    }

    func updateViews() {
        if let person = person {
            tableView.isHidden = false
            addMoreButton.isHidden = false
            interestsLabel.isHidden = false
            julietNameTF.text = person.name
            birthdayTF.text = person.birthday
            anniversaryTF.text = person.anniversary
            InterestController.shared.fetchInterestsFromFirestore(for: person) { (error) in
                if let error = error {
                    print("There was an error fetching interests: \(error.localizedDescription): \(#function)")
                }
                self.interestArray = InterestController.shared.interests
                self.tableView.reloadData()
            }
        } else {
            tableView.isHidden = true
            addMoreButton.isHidden = true
            interestsLabel.isHidden = true
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInterestDetailView" {
            guard let destinationVC = segue.destination as? InterestDetailViewController,
                let index = tableView.indexPathForSelectedRow

                else { return }
            let interest = InterestController.shared.interests[index.row]
            destinationVC.interest = interest
        }

        if segue.identifier == "toAddMoreVC" {
            guard let destinationVC = segue.destination as? InterestDetailViewController else { return }
            destinationVC.person = person
        }

    }
}

extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath)
        let interest = interestArray[indexPath.row]
        cell.textLabel?.text = interest.name
        cell.textLabel?.textColor = .highlights
        cell.backgroundColor = .white10
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let interest = interestArray[indexPath.row]
            let index = interestArray.firstIndex(of: interest)
            interestArray.remove(at: index!)
            InterestController.shared.deleteInterest(interest: interest, interestUID: nil) { (error) in
                if let error = error {
                    print("There was an error deleting the interest: \(error) : \(#function)")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
