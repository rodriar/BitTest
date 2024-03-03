//
//  APIClient.swift
//
//
//  Created by Rodrigo Arsuaga on 3/3/24.
//

import Foundation

public class APIClient: APIClientProtocol {
    
    public init() {}
    
    @discardableResult
    public func execute<T>(_ request: APIRequest<T>, callback: @escaping (Result<T, APIError>) -> Void) -> URLSessionTask? where T : Decodable {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method
        urlRequest.httpBody = request.body
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    callback(.failure(.urlError))
                    return
                }
                
                guard let data = data else {
                    callback(.failure(.serverError("No data received")))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    callback(.success(decodedData))
                } catch {
                    callback(.failure(.decodingError))
                }
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    public func execute(_ request: APIRequest<Void>, callback: @escaping (Result<Void, APIError>) -> Void) -> URLSessionTask? {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method
        urlRequest.httpBody = request.body
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    callback(.failure(.urlError))
                    print(error.localizedDescription)
                } else {
                    callback(.success(()))
                }
            }
        }
        task.resume()
        return task
    }
}
