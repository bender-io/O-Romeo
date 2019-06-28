//
//  YelpController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import CoreLocation

class YelpController {
    
    static let shared = YelpController()
    let apiKey = "5lGUJfWuPeOedsyXWTGUSO37-Ct3hL4XnzEXqKdUCJ0uY8CqCualyOwcX3hkh2aN88eLZvrhNkE0TDIwmSCTSFWRom4vVr3zcrZHxbqps49RaPpk-H0PuTxgDrYKXXYx"
    
    let searchBaseURL = "https://api.yelp.com/v3/businesses/search"
    
    func fetchRestaurants(searchTerm: String, location: String, completion: @escaping ([Yelp]) -> Void) {
        guard let baseURL = URL(string: searchBaseURL) else { completion([]) ; return }
        //        let latitude = location.coordinate.latitude
        //        let longitude = location.coordinate.longitude
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchItem = URLQueryItem(name: "term", value: searchTerm)
        let locationItem = URLQueryItem(name: "location", value: location)
        //        let latitudeItem = URLQueryItem(name: "latitude", value: "\(latitude)")
        //        let longitudeItem = URLQueryItem(name: "longitude", value: "\(longitude)")
        
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
}

class CustomImageView: UIImageView {
    
    var imageURLString: String?
    
    func fetchImageFor(yelp: Yelp) {
        let imageCache = NSCache<AnyObject, AnyObject>()
        guard let imageURL = yelp.imageURL,
            let baseURL = URL(string: imageURL)
            else { return }
        imageURLString = imageURL
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(YelpController.shared.apiKey)", forHTTPHeaderField: "Authorization")
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: imageURL as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data, let image = UIImage(data: data) else { return }
                let imageToCache = image
            if self.imageURLString == imageURL {
                DispatchQueue.main.async {
                    self.image = imageToCache                    
                }
            }
                imageCache.setObject(imageToCache, forKey: image)
            }.resume()
    }
}

