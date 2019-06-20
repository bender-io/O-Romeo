//
//  SearchViewController.swift
//  O'Romeo
//
//  Created by Brian Hersh on 6/19/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var placesSearchBar: UISearchBar!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var yelpResults: [Yelp] = []
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesSearchBar.delegate = self
    }
    
    
    // TODO: - Add function to Model Controller
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

        return cell
    }
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.tag == 0 {
            guard let searchText = searchBar.text, !searchText.isEmpty else { return }
            YelpController.shared.fetchRestaurants(searchTerm: searchText) { (yelps) in
                self.yelpResults = yelps
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
