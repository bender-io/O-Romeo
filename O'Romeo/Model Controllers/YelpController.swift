//
//  YelpController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class YelpController {
    
    static let shared = YelpController()
    let apiKey = "5lGUJfWuPeOedsyXWTGUSO37-Ct3hL4XnzEXqKdUCJ0uY8CqCualyOwcX3hkh2aN88eLZvrhNkE0TDIwmSCTSFWRom4vVr3zcrZHxbqps49RaPpk-H0PuTxgDrYKXXYx"

    let searchBaseURL = "https://api.yelp.com/v3/businesses/search"
        
    func fetchRestaurants(searchTerm: String, completion: @escaping ([Yelp]) -> Void) {
        guard let baseURL = URL(string: searchBaseURL) else { completion([]) ; return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchItem = URLQueryItem(name: "term", value: searchTerm)
        let locationItem = URLQueryItem(name: "location", value: "Salt Lake City")
        
        // https://api.yelp.com/v3/businesses/search?location=Salt%20Lake%20City&term=restaurant
        components?.queryItems = [searchItem, locationItem]
        
        guard let requestURL = components?.url else { completion([]) ; return }
        
        var request = URLRequest(url: requestURL)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion([])
                return
            }
            
            guard let data = data else { completion([]); return }
            
            do {
                let yelpDecode = try JSONDecoder().decode(TopLevelJSON.self, from: data)
                let yelpResults = yelpDecode.businesses
                completion(yelpResults)
            } catch {
                print(error.localizedDescription)
                completion([])
                return
            }
            }.resume()
    }
    
    func fetchImageFor(yelp: Yelp, completion: @escaping((UIImage?) -> Void)) {
        guard let baseURL = URL(string: yelp.imageURL) else { return }
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else { completion(nil); return }
            let image = UIImage(data: data)
            completion(image)
            }.resume()
    }
}

