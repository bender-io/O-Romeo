//
//  HomeViewController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/17/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var eventType: EventType = .nightLife
    var eventResults: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue) { (event) in
            self.eventResults = event
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func eventSegmentControl(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            eventType = .nightLife
            EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue) { (event) in
                self.eventResults = event
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            eventType = .food
            EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue) { (event) in
                self.eventResults = event
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            eventType = .culture
            EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue) { (event) in
                self.eventResults = event
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 3 {
            eventType = .music
            EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue) { (event) in
                self.eventResults = event
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        let eventRow = eventResults[indexPath.row]
        cell.event = eventRow
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
