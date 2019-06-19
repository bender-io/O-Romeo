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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        return cell
    }
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.tag == 0 {
            YelpController.shared.fetchRestaurants(searchTerm: searchText) { (yelps) in
                for yelp in yelps {
                    YelpController.shared.fetchImageFor(yelp: yelp, completion: { (image) in
                        print("\(yelp) \(String(describing: image))")
                    })
                }
            }
        }
    }
}


