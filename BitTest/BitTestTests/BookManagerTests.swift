//
//  BookManagerTests.swift
//  BitTestTests
//
//  Created by Rodrigo Arsuaga on 9/3/24.
//

@testable import BitTest
import Foundation
import Networking
import XCTest
import Domain

final class BooksManagerTests: XCTestCase {
    
    func testGetBooksSuccess() {
        let book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1", book: "1", minimumValue: "1", maximumAmount: "1", maximumValue: "1", minimumAmount: "1", tickSize: "1")
        let bookResponse = BooksResponse(payload: [book])
        let mockAPIClient = APIClientMock(response: bookResponse)
        let manager = BooksManager(apiClient: mockAPIClient)
        
        
        let expectation = self.expectation(description: "Fetch books succeeds")
        
        manager.getBooks { result in
            if case .success(let response) = result, response.payload == [book] {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testGetFormattedPropertiesBook() {
        let book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1234.56", book: "btc_mxn", minimumValue: "0.00000003", maximumAmount: "1", maximumValue: "1234.56", minimumAmount: "1", tickSize: "1")
        let manager = BooksManager()
        
        XCTAssertEqual(manager.getFormattedName(book: book), "BTC MXN")
        
        XCTAssertEqual(manager.getFormattedMaximumPrice(book: book), "$1.234,56")
        
        XCTAssertEqual(manager.getFormattedMaximumValue(book: book), "$1.234,56")
        
        XCTAssertEqual(manager.getFormattedMinimumValue(book: book), "$0,00000003")
        
        XCTAssertNotEqual(manager.getFormattedMaximumPrice(book: book), "$1,234.56")
        
        XCTAssertNotEqual(manager.getFormattedMaximumValue(book: book), "$1,234.56")
        
        XCTAssertNotEqual(manager.getFormattedMinimumValue(book: book), "$0.00000003")
        
        
    }
    func testGetFormattedPropertiesBookMexicanLocale() {
        let book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1234.56", book: "btc_mxn", minimumValue: "0.00000003", maximumAmount: "1", maximumValue: "1234.56", minimumAmount: "1", tickSize: "1")
        
        let mexicoFormatter = NumberFormatter()
        mexicoFormatter.numberStyle = .currency
        mexicoFormatter.locale = Locale(identifier: "es_MX")
        mexicoFormatter.maximumFractionDigits = 20
        let manager = BooksManager(numberFormatter: mexicoFormatter)
        
        XCTAssertEqual(manager.getFormattedMaximumPrice(book: book), "$1,234.56")
        
        XCTAssertEqual(manager.getFormattedMaximumValue(book: book), "$1,234.56")
        
        XCTAssertEqual(manager.getFormattedMinimumValue(book: book), "$0.00000003")
        
        XCTAssertNotEqual(manager.getFormattedMaximumPrice(book: book), "$1.234,56")
        
        XCTAssertNotEqual(manager.getFormattedMaximumValue(book: book), "$1.234,56")
        
        XCTAssertNotEqual(manager.getFormattedMinimumValue(book: book), "$0,00000003")
        
        
    }
    
    func testGetFormattedPropertiesBookDetails() {
        let bookDetail = BookDetail(high: "100000", volume: "20000", ask: "123", bid: "123", change24: "122")
        let manager = BooksManager()
        
        
        XCTAssertEqual(manager.getFormattedAsk(detail: bookDetail), "$123,00")
        
        XCTAssertEqual(manager.getFormattedBid(detail: bookDetail), "$123,00")
        
        XCTAssertEqual(manager.getFormattedHigh(detail: bookDetail), "$100.000,00")
        
        XCTAssertEqual(manager.getFormattedChange(detail: bookDetail), "$122,00")
        
        XCTAssertEqual(manager.getFormattedVolume(detail: bookDetail), "$20.000,00")
        
        XCTAssertNotEqual(manager.getFormattedAsk(detail: bookDetail), "$123.00")
        
        XCTAssertNotEqual(manager.getFormattedBid(detail: bookDetail), "$123.00")
        
        XCTAssertNotEqual(manager.getFormattedHigh(detail: bookDetail), "$100,000.00")
        
        XCTAssertNotEqual(manager.getFormattedChange(detail: bookDetail), "$122.00")
        
        XCTAssertNotEqual(manager.getFormattedVolume(detail: bookDetail), "$20,000.00")
        
    }
    
    func testGetFormattedPropertiesBookDetailsMexicanLocale() {
        let bookDetail = BookDetail(high: "100000", volume: "20000", ask: "123", bid: "123", change24: "122")
        let mexicoFormatter = NumberFormatter()
        mexicoFormatter.numberStyle = .currency
        mexicoFormatter.locale = Locale(identifier: "es_MX")
        mexicoFormatter.maximumFractionDigits = 20
        let manager = BooksManager(numberFormatter: mexicoFormatter)
        
        
        XCTAssertEqual(manager.getFormattedAsk(detail: bookDetail), "$123.00")
        
        XCTAssertEqual(manager.getFormattedBid(detail: bookDetail), "$123.00")
        
        XCTAssertEqual(manager.getFormattedHigh(detail: bookDetail), "$100,000.00")
        
        XCTAssertEqual(manager.getFormattedChange(detail: bookDetail), "$122.00")
        
        XCTAssertEqual(manager.getFormattedVolume(detail: bookDetail), "$20,000.00")
        
        XCTAssertNotEqual(manager.getFormattedAsk(detail: bookDetail), "$123,00")
        
        XCTAssertNotEqual(manager.getFormattedBid(detail: bookDetail), "$123,00")
        
        XCTAssertNotEqual(manager.getFormattedHigh(detail: bookDetail), "$100.000,00")
        
        XCTAssertNotEqual(manager.getFormattedChange(detail: bookDetail), "$122,00")
        
        XCTAssertNotEqual(manager.getFormattedVolume(detail: bookDetail), "$20.000,00")
        
    }
}
