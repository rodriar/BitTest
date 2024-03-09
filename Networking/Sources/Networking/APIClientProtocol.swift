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


open class APIClientMock<Response>: APIClientProtocol {

    public private(set) var numberOfExecutions = 0

    private let response: Response
    private let delay: TimeInterval

    public func execute<T>(_ request: APIRequest<T>, callback: @escaping (Result<T, APIError>) -> Void) -> URLSessionTask? {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.numberOfExecutions = self.numberOfExecutions + 1
            guard let response = self.response as? T else { return callback(.failure(APIError.decodingError)) }
            callback(.success(response))
        }
        return nil
    }

    public func execute(_ request: APIRequest<Void>, callback: @escaping (Result<Void, APIError>) -> Void) -> URLSessionTask? {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.numberOfExecutions = self.numberOfExecutions + 1
            callback(.success(()))
        }
        return nil
    }

    public init(response: Response, delay: TimeInterval = 0.01) {
        self.response = response
        self.delay = delay
    }
}

open class APIClientFailingMock: APIClientProtocol {

    public private(set) var numberOfExecutions = 0

    private let error: APIError
    private let delay: TimeInterval

    public func execute<T>(_ request: APIRequest<T>, callback: @escaping (Result<T, APIError>) -> Void) -> URLSessionTask? {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.numberOfExecutions = self.numberOfExecutions + 1
            callback(.failure(self.error))
        }
        return nil
    }

    public func execute(_ request: APIRequest<Void>, callback: @escaping (Result<Void, APIError>) -> Void) -> URLSessionTask? {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.numberOfExecutions = self.numberOfExecutions + 1
            callback(.failure(self.error))
        }
        return nil
    }

    public init(error: APIError, delay: TimeInterval = 0.01) {
        self.error = error
        self.delay = delay
    }
}
