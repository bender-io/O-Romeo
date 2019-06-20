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
    @IBOutlet weak var favoriteColorTF: UITextField!
    @IBOutlet weak var favoriteFlowerTF: UITextField!
    @IBOutlet weak var makeYourOwnTF: UITextField!
    
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        julietNameTF.text = person?.name
        birthdayTF.text = person?.bday
        anniversaryTF.text = person?.anniversary
        //        favoriteColorTF.text = person.
        //        favoriteFlowerTF.text = person.
        //        makeYourOwnTF.text = [person.interests]
//        interestTableView.delegate = self
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = julietNameTF.text, let anniversary = anniversaryTF.text, let birthday = birthdayTF.text, let interests = makeYourOwnTF.text else { return }
        PersonController.shared.createPersonWith(name: name, anniversary: anniversary, birthday: birthday, interests: [interests]) { (success) in
            if !success {
                print("Error!")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard let person = person else { return }
        julietNameTF.text = person.name
        birthdayTF.text = person.bday
        anniversaryTF.text = person.anniversary
        //        favoriteColorTF.text = person.
        //        favoriteFlowerTF.text = person.
//        makeYourOwnTF.text = [person.interests]
    }
    
}
    
    // MARK: - Navigation
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toInterestDetailView" {
//            guard let index = interestTableView.indexPathForSelectedRow,
//                let destinationVC = segue.destination as? InterestDetailViewController
//                else { return }
//            let interest = InterestController.shared.interests[index.row]
//            destinationVC.interest = interest
//        }
//    }
//}
//
//// MARK: - Extensions
//
//extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return InterestController.shared.interests.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath)
//
//        let interest = InterestController.shared.interests[indexPath.row]
//        cell.textLabel?.text = interest.name
//
//        return cell
//    }
//
//
//}
