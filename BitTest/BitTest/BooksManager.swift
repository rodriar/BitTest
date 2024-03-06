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
    let numberFormatter = NumberFormatter()
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
        setupFormatter()
    }
    
    private func setupFormatter() {
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 20
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
    
    func getFormattedName(book: Book) -> String {
        return book.book.uppercased().replacingOccurrences(of: "_", with: " ")
    }
    
    func getFormattedMaximumPrice(book: Book) -> String {
        return getNumberOutOfBookString(value: book.maximumPrice)
    }
    
    func getFormattedMaximumValue(book: Book) -> String {
        return getNumberOutOfBookString(value: book.maximumValue)
    }
    
    func getFormattedMinimumValue(book: Book) -> String {
        return getNumberOutOfBookString(value: book.minimumValue)
    }
    
    private func getNumberOutOfBookString(value: String) -> String {
        guard let double = Double(value) else { return "--" }
        let number = NSNumber(value: double)
        return numberFormatter.string(from: number) ?? "--"
    }
    
}
