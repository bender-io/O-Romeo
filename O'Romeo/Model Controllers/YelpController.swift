//
//  YelpController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI

class YelpController {
    
    static let shared = YelpController()
    let apiKey = "5lGUJfWuPeOedsyXWTGUSO37-Ct3hL4XnzEXqKdUCJ0uY8CqCualyOwcX3hkh2aN88eLZvrhNkE0TDIwmSCTSFWRom4vVr3zcrZHxbqps49RaPpk-H0PuTxgDrYKXXYx"
    
    let searchBaseURL = "https://api.yelp.com/v3/businesses/search"
    
    func fetchRestaurants(searchTerm: String, location: String, completion: @escaping ([Yelp]) -> Void) {
        guard let baseURL = URL(string: searchBaseURL) else { completion([]) ; return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchItem = URLQueryItem(name: "term", value: searchTerm)
        let locationItem = URLQueryItem(name: "location", value: location)
        
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
                print(error.localizedDescription, error)
                completion([])
                return
            }
            }.resume()
    }
    
    func fetchRestaurantsCurrentLocation(searchTerm: String, location: CLLocation, completion: @escaping ([Yelp]) -> Void) {
        guard let baseURL = URL(string: searchBaseURL) else { completion([]) ; return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchItem = URLQueryItem(name: "term", value: searchTerm)
        let latitudeItem = URLQueryItem(name: "latitude", value: "\(latitude)")
        let longitudeItem = URLQueryItem(name: "longitude", value: "\(longitude)")
        
        // https://api.yelp.com/v3/businesses/search?location=Salt%20Lake%20City&term=restaurant
        components?.queryItems = [searchItem, latitudeItem, longitudeItem]
        
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
}
