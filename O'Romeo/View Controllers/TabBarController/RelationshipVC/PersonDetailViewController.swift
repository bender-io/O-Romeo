//
//  PersonDetailViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    @IBOutlet weak var julietNameTF: UITextField!
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var anniversaryTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = julietNameTF.text, let anniversary = anniversaryTF.text, let birthday = birthdayTF.text  else { return }
        PersonController.shared.createPersonWith(name: name, anniversary: anniversary, birthday: birthday) { (success) in
            if !success {
                print("There was an error creating the person: \(#function)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMoreButtonTapped(_ sender: Any) {
    }
    
    func updateViews() {
        guard let person = person else { print("There was an error unwrapping the person: \(#function)"); return }
        julietNameTF.text = person.name
        birthdayTF.text = person.birthday
        anniversaryTF.text = person.anniversary
        InterestController.shared.fetchInterestsFromFirestore(for: person) {
            self.tableView.reloadData()
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
}
