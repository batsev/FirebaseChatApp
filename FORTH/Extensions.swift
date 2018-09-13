//
//  Extensions.swift
//  FORTH
//
//  Created by Никита Бацев on 11.05.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String){
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {return}
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
                
            }
            
            }.resume()
    }
}
