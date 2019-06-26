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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    // STILL NOT WORKING
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
                self.tableView.reloadData()
                
            }
        }
    }

// MARK: - Table view data source

override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DateLogController.shared.dateLogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datesCell", for: indexPath) as! CalendarTableViewCell
        
        let sortedDates = dateLogs.sorted(by: { $0.date.asDate() < $1.date.asDate() })
        let date = sortedDates[indexPath.row]
        cell.dateLog = date

        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editDateDetailVC" {
            if let destinationVC = segue.destination as? AddDateViewController, let indexPath = tableView.indexPathForSelectedRow {
                let sortedDates = dateLogs.sorted(by: { $0.date < $1.date })
                let date = sortedDates[indexPath.row]
                destinationVC.dateLog = date
            }
        }
    }
}
