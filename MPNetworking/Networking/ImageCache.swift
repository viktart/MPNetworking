//
//  ImageCache.swift
//  FoodTestTask
//
//  Created by owel on 5/28/17.
//  Copyright © 2017 owel. All rights reserved.
//

import Foundation
import UIKit

// tune cache here
open class ImageCache {
    
    public struct CachingOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let memory    = CachingOptions(rawValue: 1 << 0)
        public static let disk      = CachingOptions(rawValue: 1 << 1)
    }
    
    var cachingOptions: CachingOptions = [.memory, .disk]
    
    // MARK: -
    
    func cache(image: UIImage, absoluteUrlString string: String) {
       self.cache(image: image, absoluteUrlString: string, cachingOptions: self.cachingOptions)
    }
    
    func cache(image: UIImage, absoluteUrlString string: String, cachingOptions: CachingOptions) {
        if cachingOptions.contains(.memory) {
            MemoryCache.cache(image: image, absoluteUrlString: string)
        }
        if cachingOptions.contains(.disk) {
            DiskCache.cache(image: image, absoluteUrlString: string)
        }
    }
    
    func cachedImage(absoluteUrlString string: String) -> UIImage? {
        return self.cachedImage(absoluteUrlString: string, cachingOptions: self.cachingOptions)
    }
    
    func cachedImage(absoluteUrlString string: String, cachingOptions: CachingOptions) -> UIImage? {
        var resultImage : UIImage?
        
        if cachingOptions.contains(.memory) {
            resultImage = MemoryCache.cachedImage(absoluteUrlString: string)
        }
        if resultImage == nil && cachingOptions.contains(.disk) {
            resultImage = DiskCache.cachedImage(absoluteUrlString: string)
        }
        
        return resultImage
    }
}


fileprivate class MemoryCache {
    
    static private var memoryCache = NSCache<NSString, UIImage>()
    
    static func cache(image: UIImage, absoluteUrlString string: String) {
        let nsstring = NSString(string: string)
        memoryCache.setObject(image, forKey: nsstring)
    }
    
    static func cachedImage(absoluteUrlString string: String) -> UIImage? {
        let nsstring = NSString(string: string)
        return memoryCache.object(forKey: nsstring)
    }
}


fileprivate class DiskCache {
    
//    // TODO: improve it to reflect absolute url
//    static private func imageFileName(absoluteUrlString string: String) -> String {
//        // TODO: check if proper url
//        let components = string.components(separatedBy: "/")
//        return components.last!
//    }
//    
//    static private func imageFilePath(absoluteUrlString string: String) -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
//        let cachesDirectory = paths.first! // TODO: process error
//        let fileName = cachesDirectory + "/" + self.imageFileName(absoluteUrlString: string)
//        return fileName
//    }
    
    static func cache(image: UIImage, absoluteUrlString string: String) {
        // TODO: implement
    }
    
    static func cachedImage(absoluteUrlString string: String) -> UIImage? {
        // TODO: implement
        return nil
    }
}












