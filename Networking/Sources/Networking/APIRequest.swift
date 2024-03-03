//
//  APIRequest.swift
//  
//
//  Created by Rodrigo Arsuaga on 3/3/24.
//

import Foundation

public enum APIError: Error {
    case urlError
    case decodingError
    case serverError(String)
}

public struct APIRequest<T> {
    
    public init(url: URL, method: String, body: Data? = nil, headers: [String : String]? = nil) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
    }
    
    let url: URL
    let method: String
    let body: Data?
    let headers: [String: String]?
    
}
