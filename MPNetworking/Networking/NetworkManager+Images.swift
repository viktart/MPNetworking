//
//  NetworkManager+Images.swift
//  FoodTestTask
//
//  Created by owel on 5/28/17.
//  Copyright © 2017 owel. All rights reserved.
//

import Foundation
import UIKit

public extension NetworkManager {
    
    func downloadImage(absoluteUrlString: String, callback: @escaping (UIImage?,Error?) -> Void) {
        self.downloadImage(absoluteUrlString: absoluteUrlString, cachingOptions: self.imageCache.cachingOptions, callback: callback)
    }
    
    func downloadImage(absoluteUrlString: String,
                       cachingOptions: ImageCache.CachingOptions,
                       callback: @escaping (UIImage?,Error?) -> Void) {
        do {
            //check cache
            if let cachedImage = self.imageCache.cachedImage(absoluteUrlString: absoluteUrlString, cachingOptions: cachingOptions) {
                callback(cachedImage, nil)
                return
            }
            
            let request = try self.composeRequest(absoluteURLString: absoluteUrlString, httpMethod: .get)
            
            self.performDataRequest(request: request) { (data, response, error) in
                guard error == nil else {
                    LogError(error!)
                    callback(nil, error)
                    return
                }
                
                guard let data = data else {
                    LogError(String(format: "Data is nil\n%@", response ?? ""))
                    callback(nil, CustomError.noData(request: request))
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    LogError("Error creating image")
                    callback(nil, CustomError.cannotCreateImage(urlString: absoluteUrlString))
                    return
                }
                
                self.imageCache.cache(image: image, absoluteUrlString: absoluteUrlString, cachingOptions: cachingOptions)
                
                callback(image, nil)
            }
        } catch {
            LogError(error)
        }
    }
}
