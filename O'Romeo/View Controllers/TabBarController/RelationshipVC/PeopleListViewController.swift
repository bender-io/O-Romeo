//
//  PeopleListViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PeopleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helperLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        helperLabel.text = "Looks like you don't have any hoes, click the button below to add some!"
        if tableView.numberOfRows(inSection: 0) == 0 {
            helperLabel.isHidden = false
        } else {
            helperLabel.isHidden = true
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPersonDetailView" {
            guard let index = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? PersonDetailViewController
                else { return }
            let person = PersonController.shared.persons[index.row]
            destinationVC.person = person
        }
    }
}

// MARK: - Extensions

extension PeopleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersonController.shared.persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        
        let person = PersonController.shared.persons[indexPath.row]
        cell.person = person
        
        return cell
    }
}
