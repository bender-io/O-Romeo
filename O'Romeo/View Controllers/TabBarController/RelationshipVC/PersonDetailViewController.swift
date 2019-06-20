//
//  PersonDetailViewController.swift
//  O'Romeo
//
//  Created by Will morris on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    @IBOutlet weak var interestTableView: UITableView!
    
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        interestTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        interestTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInterestDetailView" {
            guard let index = interestTableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? InterestDetailViewController
                else { return }
            let interest = InterestController.shared.interests[index.row]
            destinationVC.interest = interest
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
        
        return cell
    }
    
    
}
