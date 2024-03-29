//
//  SearchViewController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var placesSearchBar: UISearchBar!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var yelpResults: [Yelp] = []
    var isExpanded = false
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        placesSearchBar.delegate = self
        CurrentLocation.shared.findLocation()
        CurrentLocation.shared.locationManager.startUpdatingLocation()
        locationSearchBar.placeholder = "Current Location"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        CurrentLocation.shared.findLocation()
        CurrentLocation.shared.delegate = self
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yelpResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        let yelpRow = yelpResults[indexPath.row]
        cell.yelp = yelpRow
        cell.delegate = self
        cell.awakeFromNib()
        return cell
    }
    
    func setupUI() {
        tableView.reloadData()
        tabBarController?.tabBar.alpha = 1
        placesSearchBar.barTintColor = .primary
        placesSearchBar.tintColor = .highlights
        locationSearchBar.barTintColor = .primary
        placesSearchBar.tintColor = .highlights
        view.backgroundColor = .primary
    }
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = placesSearchBar.text, !searchText.isEmpty
            else { return }
        if searchBar.tag == 0 {
            guard let location = location else { return }
            YelpController.shared.fetchRestaurantsCurrentLocation(searchTerm: searchText, location: location) { (yelps) in
                self.yelpResults = yelps
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else if searchBar.tag == 1 {
            guard let location = locationSearchBar.text else { return }
            YelpController.shared.fetchRestaurants(searchTerm: searchText, location: location) { (yelps) in
                self.yelpResults = yelps
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
extension SearchViewController: SearchTableViewCellDelegate {
    func calendarButtonTapped(yelp: Yelp) {
        guard let addDateVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "addDateVC") as? AddDateViewController else { return }
        addDateVC.yelp = yelp
        present(addDateVC, animated: true, completion: nil)
    }
}

extension SearchViewController: CurrentLocationDelegate {
    func locationWasUpdated(location: CLLocation) {
        self.location = location
    }
}
