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
    let apiKey = "eFXOAyct4_UkcfVl7f9s43kknuHxWYop6_9D7hy3PL-5_5toxG0k4jtNIUAPTEHNrvAl_eCjT6WzCoLKPrZsTFKw0oxxq5Q4f576N1MjSqItKEIM2hyBvC2KDsUHXXYx"
    let searchBaseURL = "https://api.yelp.com/v3/businesses/search"
    
    func fetchRestaurants(searchTerm: String, completion: @escaping ([Yelp]) -> Void) {
        guard let baseURL = URL(string: searchBaseURL) else { completion([]) ; return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let locationItem = URLQueryItem(name: "location", value: "Salt Lake City")
        let searchItem = URLQueryItem(name: "term", value: searchTerm)
        // https://api.yelp.com/v3/businesses/search?location=Salt%20Lake%20City&term=restaurant
        components?.queryItems = [locationItem, searchItem]
        
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

