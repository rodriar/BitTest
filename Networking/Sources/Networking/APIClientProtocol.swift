//
//  File.swift
//  
//
//  Created by Rodrigo Arsuaga on 3/3/24.
//

import Foundation



public protocol APIClientProtocol {

    @discardableResult
    func execute<T>(_ request: APIRequest<T>, callback: @escaping (Result<T, APIError>) -> Void) -> URLSessionTask?  where T : Decodable

    @discardableResult
    func execute(_ request: APIRequest<Void>, callback: @escaping (Result<Void, APIError>) -> Void) -> URLSessionTask?
}

