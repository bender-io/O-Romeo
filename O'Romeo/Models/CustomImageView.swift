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
