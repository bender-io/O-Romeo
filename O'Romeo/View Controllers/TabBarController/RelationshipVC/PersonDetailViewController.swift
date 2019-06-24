//
//  PersonDetailViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
<<<<<<< HEAD
=======
    // MARK: - IBOutlets
>>>>>>> added segues from events to add calendar
    @IBOutlet weak var julietNameTF: UITextField!
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var anniversaryTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
<<<<<<< HEAD
    
=======
    @IBOutlet weak var addMoreButton: UIButton!
    @IBOutlet weak var interestsLabel: UILabel!
    
    // MARK: - Landing Pad
>>>>>>> added segues from events to add calendar
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        InterestController.shared.interests = []
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = julietNameTF.text, let anniversary = anniversaryTF.text, let birthday = birthdayTF.text  else { return }
        PersonController.shared.createPersonWith(name: name, anniversary: anniversary, birthday: birthday) { (success) in
            if !success {
                print("There was an error creating the person: \(#function)")
=======
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        InterestController.shared.interests = []
    }
    
    // MARK: - IBActions
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
>>>>>>> added segues from events to add calendar
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMoreButtonTapped(_ sender: Any) {
<<<<<<< HEAD
        InterestDetailViewController.shared.person = person
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
            guard let index = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? InterestDetailViewController
=======
    }
    
    func updateViews() {
        if let person = person {
//            tableView.isHidden = false
//            addMoreButton.isHidden = false
//            interestsLabel.isHidden = false
            julietNameTF.text = person.name
            birthdayTF.text = person.birthday
            anniversaryTF.text = person.anniversary
            InterestController.shared.fetchInterestsFromFirestore(for: person) { (error) in
                if let error = error {
                    print("There was an error fetching interests: \(error.localizedDescription): \(#function)")
                }
                self.tableView.reloadData()
            }
        } else {
//            tableView.isHidden = true
//            addMoreButton.isHidden = true
//            interestsLabel.isHidden = true
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInterestDetailView" {
            guard let destinationVC = segue.destination as? InterestDetailViewController,
                let index = tableView.indexPathForSelectedRow
>>>>>>> added segues from events to add calendar
                else { return }
            let interest = InterestController.shared.interests[index.row]
            destinationVC.interest = interest
        }
<<<<<<< HEAD
=======
        if segue.identifier == "toAddMoreVC" {
            guard let destinationVC = segue.destination as? InterestDetailViewController else { return }
            destinationVC.person = person
        }
>>>>>>> added segues from events to add calendar
    }
}

// MARK: - Extensions
<<<<<<< HEAD

=======
>>>>>>> added segues from events to add calendar
extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InterestController.shared.interests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath)

        let interest = InterestController.shared.interests[indexPath.row]
        cell.textLabel?.text = interest.name
<<<<<<< HEAD
=======
        cell.textLabel?.textColor = .highlights
>>>>>>> added segues from events to add calendar

        return cell
    }
}
