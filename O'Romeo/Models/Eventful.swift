//
//  Eventful.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

// MARK: - Eventful
struct Eventful: Codable {
    let events: Events?
}

// MARK: - Events
struct Events: Codable {
    let event: [Event]?
}

// MARK: - Event
struct Event: Codable {
    let url: String?
    let startTime: String
    let eventDescription: String?
    let title: String
    let venueAddress: String
    let cityName: String?
    let regionAbbr: String?
    let postalCode: String?
    let countryAbbr: String?
    let image: Image?
    let venueName: String?
    let venueURL: String?
    
    enum CodingKeys: String, CodingKey {
        case url
        case startTime = "start_time"
        case eventDescription = "description"
        case title
        case venueAddress = "venue_address"
        case cityName = "city_name"
        case regionAbbr = "region_abbr"
        case postalCode = "postal_code"
        case countryAbbr = "country_abbr"
        case image
        case venueName = "venue_name"
        case venueURL = "venue_url"
    }
}

// MARK: - Image
struct Image: Codable {
    let medium: Medium
}

// MARK: - Medium
struct Medium: Codable {
    let url: String
}
