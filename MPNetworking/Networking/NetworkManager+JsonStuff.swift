//
//  NetworkManager+JsonStuff.swift
//  FoodTestTask
//
//  Created by owel on 12/31/17.
//  Copyright © 2017 owel. All rights reserved.
//

import Foundation

public extension NetworkManager {
    
    typealias RequestParameters = Dictionary<String, String>?
    typealias CallbackType<CT: Decodable> = ((CT?, Error?)->Void)?
    
    // MARK: - Compose Request
    
    private func composeJSONRequest(url: URL,
                                    httpMethod: HttpMethod,
                                    parameters: RequestParameters) throws -> Request {
        var request = self.composeRequest(url: url, httpMethod: httpMethod)
        
        var headers =  request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        if let parameters = parameters {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(parameters)
            request.httpBody = jsonData
        }
            
        return request
    }
    
    private func composeJSONRequest(relativeURLString: String,
                                    httpMethod: HttpMethod,
                                    parameters: RequestParameters) throws -> Request {
        guard let url = URL(string: relativeURLString, relativeTo: serverURL) else {
            let error = CustomError.cannotCreateURL(urlString: relativeURLString)
            LogError(error)
            throw error
        }
        return try self.composeJSONRequest(url: url, httpMethod: httpMethod, parameters: parameters)
    }
    
    // MARK: - Perform request
    
    func performJSONRequest<CT: Decodable>(relativeURLString: String,
                                           httpMethod: HttpMethod,
                                           parameters: RequestParameters,
                                           callback: CallbackType<CT>) {
        let request = try! self.composeJSONRequest(relativeURLString: relativeURLString, httpMethod: httpMethod, parameters: parameters)
        self.performJSONRequest(request: request) { (responseObject, error) in
            callback?(responseObject, error)
        }
    }
    
    func performJSONRequest<CT: Decodable>(url: URL,
                                           httpMethod: HttpMethod,
                                           parameters: RequestParameters,
                                           callback: CallbackType<CT>) {
        let request = try! self.composeJSONRequest(url: url, httpMethod: httpMethod, parameters: parameters)
        self.performJSONRequest(request: request, callback: callback)
    }
    
    internal func performJSONRequest<CT: Decodable>(request: Request,
                                           callback: CallbackType<CT>) {
        
        self.performDataRequest(request: request) { (data, response, error) in
            guard error == nil else {
                LogError(error!)
                callback?(nil, error)
                return
            }
            
            guard let data = data else {
                LogError(String(format: "Data is nil\n%@", response ?? ""))
                callback?(nil, CustomError.noData(request: request))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(CT.self, from: data)
                callback?(responseObject, nil)
            } catch let error {
                LogError(error)
                callback?(nil, error)
            }
        }
    }
    
}
