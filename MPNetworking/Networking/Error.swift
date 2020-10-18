//
//  Error.swift
//  FoodTestTask
//
//  Created by owel on 5/28/17.
//  Copyright © 2017 owel. All rights reserved.
//

import Foundation


// TODO: setup error logging for MPNetworking
// maybe use custom closure like this one:
// logError: (Error) -> Void
// networking.logError = { print($0) }
public func LogError(_ object : Any) {
    // TODO: add more explicated error logging
    print(object)
}


// TODO: make it MPNetworkingError
public enum CustomError : Error {
    // Network errors
    case cannotCreateURL(urlString: String)
    case noData(request: URLRequest)
    case deserialization(data: Data)
    case cannotCreateImage(urlString: String)
}
