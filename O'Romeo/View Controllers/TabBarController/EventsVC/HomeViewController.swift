//
//  HomeViewController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/17/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import CoreLocation

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var eventType: EventType = .nightLife
    var eventResults: [Event] = []
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        CurrentLocation.shared.findLocation()
        CurrentLocation.shared.locationManager.startUpdatingLocation()      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CurrentLocation.shared.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func eventSegmentControl(_ sender: Any) {
        guard let location = location else { return }
        if segmentedControl.selectedSegmentIndex == 0 {
            eventType = .nightLife
            EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue, location: location) { (event) in
                self.eventResults = event
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            eventType = .food
            EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue, location: location) { (event) in
                self.eventResults = event
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            eventType = .culture
            EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue, location: location) { (event) in
                self.eventResults = event
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 3 {
            eventType = .music
            EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue, location: location) { (event) in
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
        cell.delegate = self
        
        return cell
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "fromEventVC" {
            if let destinationVC = segue.destination as? AddDateViewController, let indexPath = tableView.indexPathForSelectedRow {
                let event = eventResults[indexPath.row]
                destinationVC.event = event
            }
        }
     }
}

extension EventViewController: EventTableViewCellDelegate {
    func calendarButtonTapped(event: Event) {
        guard let addDateVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "addDateVC") as? AddDateViewController else { return }
        addDateVC.event = event
        present(addDateVC, animated: true, completion: nil)
    }
}

extension EventViewController: CurrentLocationDelegate {
    func locationWasUpdated(location: CLLocation) {
        self.location = location
        
        EventfulController.shared.fetchEvents(searchTerm: eventType.rawValue, location: location) { (event) in
            self.eventResults = event
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
