//
//  PersonDetailViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {

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

// MARK: - Extensions

extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InterestController.shared.interests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath)

        let interest = InterestController.shared.interests[indexPath.row]
        cell.textLabel?.text = interest.name
        cell.textLabel?.textColor = .highlights

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let interest = InterestController.shared.interests[indexPath.row]
            InterestController.shared.deleteInterest(interest: interest) { (error) in
                if let error = error {
                    print("There was an error deleting the interest: \(error) : \(#function)")
                }
            }
            InterestController.shared.interests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
