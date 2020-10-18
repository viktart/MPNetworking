//
//  NetworkManager.swift
//  FoodTestTask
//
//  Created by owel on 5/28/17.
//  Copyright © 2017 owel. All rights reserved.
//

import Foundation

open class NetworkManager {

    // TODO: do we really need this typealiases?
    typealias Request = URLRequest
    typealias DataDictionary = [String : Any]
    
    public enum HttpMethod : String {
        case get = "GET"
        case post = "POST"
    }
    
    var imageCache = ImageCache()
    
    public var session : URLSession = URLSession.shared
    public var serverURL : URL = URL(string: "http://localhost")!
    
    // MARK: - Init
    
    public static var defaultManager: NetworkManager = {
        return NetworkManager()
    }()
    
    private init() {
    }
    
    public init(serverUrl: URL) {
        self.serverURL = serverUrl
    }
    
    // MARK: - requests

    internal func composeRequest(relativeURLString: String, httpMethod: HttpMethod) throws -> Request {
        guard let url = URL(string: relativeURLString, relativeTo: serverURL) else {
            let error = CustomError.cannotCreateURL(urlString: relativeURLString)
            LogError(error)
            throw error
        }
        return self.composeRequest(url: url, httpMethod: httpMethod)
    }
    
    internal func composeRequest(absoluteURLString: String, httpMethod: HttpMethod) throws -> Request {
        guard let url = URL(string: absoluteURLString) else {
            let error = CustomError.cannotCreateURL(urlString: absoluteURLString)
            LogError(error)
            throw error
        }
        return self.composeRequest(url: url, httpMethod: httpMethod)
    }
    
    internal func composeRequest(url: URL, httpMethod: HttpMethod) -> Request {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
    
    // MARK: -
    
    // This method can be easily changed in order to tune networking mechanism
    internal func performDataRequest( request: Request, callback: @escaping (Data?,URLResponse?,Error?)->Void ) {
        let task = self.session.dataTask(with: request) { (data, response, error) in
            callback(data,response,error)
        }
        task.resume()
    }
}


// TODO: do we really need this as an extension?
extension NetworkManager {
    /// - parameter callback : Either dictionary or error is equal to nil (not both)
    internal func perform( request : Request, callback : @escaping (DataDictionary?, Error?) -> Void ) {
        
        self.performDataRequest(request: request) { (data, response, error) in
            guard error == nil else {
                LogError(error!)
                callback(nil, error)
                return
            }
            
            guard data != nil else {
                LogError(String(format: "Data is nil\n%@", response ?? ""))
                callback(nil, CustomError.noData(request: request))
                return
            }
            
            do {
                let dataObj = try JSONSerialization.jsonObject(with: data!, options: .init(rawValue: 0))
                guard let dictionary = dataObj as? DataDictionary else {
                    let error = CustomError.deserialization(data: data!)
                    LogError("Error in serialization: \(error)")
                    callback(nil, error)
                    return
                }
                
                callback(dictionary, nil)
                
            } catch let error {
                LogError(error)
                callback(nil, error)
            }
        }
    }
}
