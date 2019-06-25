//
//  Yelp.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/18/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import Foundation

struct TopLevelJSON: Codable {
    let businesses: [Yelp]
}

struct Yelp: Codable {
    let name: String
    let imageURL: String?
    let displayPhone: String?
    let rating: Double?
    let location: Location?
    let price: Price?
    let categories: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case name, location, rating, price, categories
        case imageURL = "image_url"
        case displayPhone = "display_phone"
    }
}

struct Location: Codable {
    
    let displayAddress: [String]
    
    enum CodingKeys: String, CodingKey {
        case displayAddress = "display_address"
    }
}

enum Price: String, Codable {
    case cheap = "$"
    case moderate = "$$"
    case pricey = "$$$"
}

struct Category: Codable {
    let alias: String
    let title: String
}
