//
//  EventfulController.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import CoreLocation
class EventfulController {
    static let shared = EventfulController()
    var eventsArray: [Eventful] = []
    //api key WFqCdKSnVRgh3tms
    //http://api.eventful.com/json/events/search?keywords=music&location=Salt%20Lake%20City&date=Future
    let apiKey = "WFqCdKSnVRgh3tms"
    let searchBaseURL = "https://api.eventful.com/json/events/search/"
    
    func fetchEvents(searchTerm: String, location: CLLocation, completion: @escaping ([Event]) -> Void) {
        CurrentLocation.shared.getCityName(location: location) { (cityName) in
            guard let cityName = cityName else { completion([]) ; return }
            guard let baseURL = URL(string: self.searchBaseURL) else { completion([]); return }
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            let apikeyItem = URLQueryItem(name: "app_key", value: self.apiKey)
            let keywordsItem = URLQueryItem(name: "keywords", value: searchTerm)
            let locationItem = URLQueryItem(name: "location", value: cityName)
            let dateItem = URLQueryItem(name: "date", value: "Future")
            let locationRadiusItem = URLQueryItem(name: "within", value: "25")
            components?.queryItems = [keywordsItem, locationItem, dateItem, apikeyItem, locationRadiusItem]
            
            //http://api.eventful.com/json/events/search?keywords=Music&location=Salt%20Lake%20City&date=Future
            
            guard let finalURL = components?.url else { completion([]); return }
            
            print(finalURL)
            
            URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
                if let error = error {
                    print("Event data task \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let data = data else { completion([]); return }
                
                do {
                    let eventDecode = try JSONDecoder().decode(Eventful.self, from: data)
                    let eventResults = eventDecode.events
                    guard let events = eventResults?.event else { completion([]) ; return }
                    completion(events)
                } catch {
                    print("getting data \(error)")
                    completion([])
                    return
                }
                }.resume()
        }
    }
}
