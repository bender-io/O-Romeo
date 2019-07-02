//
//  CustomImageView.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/28/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var imageURLString: String?
    
    func fetchImageForYelp(yelp: Yelp) {
        let imageCache = NSCache<AnyObject, AnyObject>()
        guard let imageURL = yelp.imageURL,
            let baseURL = URL(string: imageURL)
            else { return }
        imageURLString = imageURL
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(YelpController.shared.apiKey)", forHTTPHeaderField: "Authorization")
        
        image = UIImage(named: "Logo")
        
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
    
    func ratingsToYelpStarRating(yelp: Yelp) -> UIImage? {
        guard let rating = yelp.rating else { return nil }
        var image: UIImage?
        if rating == 0 {
            image = UIImage(named: "zero")
        } else if rating == 1 {
            image = UIImage(named: "onestar")
        } else if rating == 1.5 {
            image = UIImage(named: "oneandhalfstar")
        } else if rating == 2 {
            image = UIImage(named: "twostars")
        } else if rating == 2.5 {
            image = UIImage(named: "twoandhalfstar")
        } else if rating == 3 {
            image = UIImage(named: "threestars")
        } else if rating == 3.5 {
            image = UIImage(named: "threeandhalfstars")
        } else if rating == 4 {
            image = UIImage(named: "fourstars")
        } else if rating == 4.5 {
            image = UIImage(named: "fourandhalfstars")
        } else if rating == 5 {
            image = UIImage(named: "fivestars")
        }
        return image
    }
    
    func fetchImageFor(eventful: Event) {
        // unwrpa image first
        let imageCache = NSCache<AnyObject, AnyObject>()
        guard let imageURL = eventful.image?.medium.url else { return }
        //        imageURL.removeFirst()
        let finalURL = "https:" + imageURL
        imageURLString = finalURL
        //        print(imageURL)
        guard let baseURL = URL(string: finalURL) else { return }
        //        guard let baseURL = URL(string: eventful.image.medium.url) else { return }
        //        print(baseURL)
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("fetching image \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            let imageToCache = image
            if self.imageURLString == finalURL {
                DispatchQueue.main.async {
                    self.image = imageToCache
                }
            }
            imageCache.setObject(imageToCache, forKey: image)
            }.resume()
    }
    
}
