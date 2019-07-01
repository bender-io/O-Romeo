//
//  CalendarTableViewController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/24/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CalendarTableViewController: UITableViewController {
    
    var dateLogs = [DateLog]()
    
    @IBOutlet weak var emptyCalendarLabel: UILabel!
    @IBOutlet weak var addButton: RomeoBarButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        view.backgroundColor = .primary
        navigationController?.navigationBar.barTintColor = .primary
        navigationController?.navigationBar.tintColor = .highlights
        tabBarController?.tabBar.tintColor = .highlights
        tabBarController?.tabBar.barTintColor = .primary
        addButton.tintColor = .highlights
        PersonController.shared.fetchPersonsFromFirestore { (error) in
            if let error = error {
                print("There was an error fetching the people: \(error) : \(#function)")
            }
            self.loadData()
        }
    }
    
    func loadData() {
        let dispatchGroup = DispatchGroup()
        DateLogController.shared.dateLogs = []
        
        for person in PersonController.shared.persons {
            dispatchGroup.enter()
            DateLogController.shared.fetchDateLogFromFirestore(for: person) { (error) in
                if let error = error {
                    print("fetching date log \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.dateLogs = DateLogController.shared.dateLogs
                self.dateLogs.sort(by: { $0.date.asDate() < $1.date.asDate() })
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateLogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datesCell", for: indexPath) as! CalendarTableViewCell
        
        let dateLog = dateLogs[indexPath.row]
        cell.dateLog = dateLog
        cell.awakeFromNib()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let dateLog = dateLogs[indexPath.row]
            DateLogController.shared.deleteDateLog(dateLog: dateLog, dateLogUID: nil) { (error) in
                if let error = error {
                    print("There was an error deleting the datelog: \(error) : \(#function)")
                }
            }
            dateLogs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDateDetailVC" {
            if let destinationVC = segue.destination as? AddDateViewController, let indexPath = tableView.indexPathForSelectedRow {
                let dateLog = dateLogs[indexPath.row]
                destinationVC.dateLog = dateLog
            }
        }
    }
    
    func emptyCalendar() {
        if dateLogs.count == 0 {
            let alert = UIAlertController(title: "Welcome", message: "To get started add a Juliet in the Relationship Tab", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
