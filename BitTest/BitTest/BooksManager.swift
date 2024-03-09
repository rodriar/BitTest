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
    private let apiClient: APIClientProtocol
    private var numberFormatter = NumberFormatter()
    
    init(apiClient: APIClientProtocol = APIClient(), numberFormatter: NumberFormatter? = nil) {
        self.apiClient = apiClient
        if let numberFormatter = numberFormatter {
            self.numberFormatter = numberFormatter
        } else {
            setupFormatter()
        }
    }
    
    private func setupFormatter() {
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 20
    }
    
    func getBooks(completion: @escaping (Result<BooksResponse, APIError>) -> Void) { 
        apiClient.execute(APIClient.getBooks()) { result in
             completion(result)
         }
    }
    
    func getBookDetail(book: Book, completion: @escaping (Result<BookDetailResponse, APIError>) -> Void) {
        apiClient.execute(APIClient.getBookDetail(book: book), callback: { result in
            completion(result)
        })
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
    
    func getFormattedVolume(detail: BookDetail) -> String {
        return getNumberOutOfBookString(value: detail.volume)
    }
    
    
    func getFormattedHigh(detail: BookDetail) -> String {
        return getNumberOutOfBookString(value: detail.high)
    }
    
    func getFormattedChange(detail: BookDetail) -> String {
        return getNumberOutOfBookString(value: detail.change24)
    }
    
    func getFormattedAsk(detail: BookDetail) -> String {
        return getNumberOutOfBookString(value: detail.ask)
    }
    
    func getFormattedBid(detail: BookDetail) -> String {
        return getNumberOutOfBookString(value: detail.bid)
    }
    
    
    private func getNumberOutOfBookString(value: String) -> String {
        guard let double = Double(value) else { return "--" }
        let number = NSNumber(value: double)
        return numberFormatter.string(from: number) ?? "--"
    }
    
}
