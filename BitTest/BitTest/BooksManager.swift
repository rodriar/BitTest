//
//  BooksManager.swift
//  BitTest
//
//  Created by Rodrigo Arsuaga on 3/3/24.
//

import Foundation
import Domain
import Networking

class BooksManager {
    
    static let shared = BooksManager()
    let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getBooks(completion: @escaping (Result<BooksResponse, APIError>) -> Void) {
        guard let url = URL(string: "https://api.bitso.com/v3/available_books/") else {
             completion(.failure(.urlError))
             return
         }
         let request = APIRequest<BooksResponse>(url: url, method: "GET", body: nil, headers: nil)
         
        apiClient.execute(request) { result in
             completion(result)
         }
    }
}
