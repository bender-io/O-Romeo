//
//  PeopleListViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PeopleListViewController: UIViewController {
    
    var personArray: [Person] = []

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
//        let helperLabel = UILabel()

        tableView.delegate = self
        tableView.dataSource = self
//        helperLabel.text = "Looks like you don't have any hoes, click the button below to add some!"
//        if tableView.numberOfRows(inSection: 0) == 0 {
//            helperLabel.isHidden = false
//        } else {
//            helperLabel.isHidden = true
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .primary
        navigationController?.navigationBar.tintColor = .highlights
        navigationController?.navigationBar.barTintColor = .primary
        tabBarController?.tabBar.tintColor = .highlights
        tabBarController?.tabBar.barTintColor = .primary
        tableView.backgroundColor = .white10
        PersonController.shared.fetchPersonsFromFirestore { (error) in
            if let error = error {
                print("There was an error fetching persons: \(error.localizedDescription): \(#function)")
            }
            self.personArray = PersonController.shared.persons.sorted(by: { $0.name < $1.name })
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPersonDetailVC" {
            guard let index = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? PersonDetailViewController
                else { return }
            let person = personArray[index.row]
            destinationVC.person = person
        }
    }
}

// MARK: - Extensions
extension PeopleListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "relationshipCell", for: indexPath) as? PersonTableViewCell
        
        let person = personArray[indexPath.row]
        cell?.person = person

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = personArray[indexPath.row]
            PersonController.shared.deletePerson(person: person) { (error) in
                if let error = error {
                    print("There was an error deleting the person: \(error) : \(#function)")
                }
            }
            personArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
