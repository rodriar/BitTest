//
//  BookDetailViewModelTests.swift
//  BitTestTests
//
//  Created by Rodrigo Arsuaga on 10/3/24.
//

@testable import BitTest
import Foundation
import Networking
import XCTest
import Domain
import Combine

@MainActor
final class BookDetailViewModelTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    static let basicBook: Book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1234.56", book: "btc_mxn", minimumValue: "0.00000003", maximumAmount: "1", maximumValue: "1234.56", minimumAmount: "1", tickSize: "1")
    static let basicDetail: BookDetail = BookDetail(high: "100000", volume: "20000", ask: "123", bid: "123", change24: "122")
 
    func testLoadingSuccessfully() {
       let mockAPIClient = APIClientMock(response: BookDetailResponse(payload: BookDetailViewModelTests.basicDetail))
       let booksManager = BooksManager(apiClient: mockAPIClient)
       
       let viewModel = BookDetailViewModel(booksManager: booksManager, book: BookDetailViewModelTests.basicBook, output: nil)
       
        let expectation = self.expectation(description: "expectation")
        viewModel.$state.sink { output in
            switch output {
            case .loaded:
                 if viewModel.bookDetail?.ask == BookDetailViewModelTests.basicDetail.ask {
                    expectation.fulfill()
                }
            case .error(_):
                break
            case .loading:
                break
            }
        }.store(in: &cancelBag)

        wait(for: [expectation], timeout: 2)
        
    }
    
    func testLoadingError() {
        let mockAPIClient = APIClientMock(response: APIError.decodingError)
       let booksManager = BooksManager(apiClient: mockAPIClient)
       
       let viewModel = BookDetailViewModel(booksManager: booksManager, book: BookDetailViewModelTests.basicBook, output: nil)
       
        let expectation = self.expectation(description: "expectation")
        viewModel.$state.sink { output in
            switch output {
            case .loaded: break
            case .error(let error):
                if error  == .decodingError {
                   expectation.fulfill()
               }
            case .loading:
                break
            }
        }.store(in: &cancelBag)

        wait(for: [expectation], timeout: 2)
        
    }
    
    func testFormattedProperties() {
        let mockAPIClient = APIClientMock(response: BookDetailResponse(payload: BookDetailViewModelTests.basicDetail))
        let booksManager = BooksManager(apiClient: mockAPIClient)
       
       let viewModel = BookDetailViewModel(booksManager: booksManager, book: BookDetailViewModelTests.basicBook, output: nil)
        
        let expectation = self.expectation(description: "expectation")
        viewModel.$state.sink { output in
            switch output {
            case .loaded:
                XCTAssertEqual(viewModel.ask, "Ask: $123,00")
                
                XCTAssertEqual(viewModel.bid, "Bid: $123,00")
                
                XCTAssertEqual(viewModel.change, "Change 24hs: $122,00")
                
                XCTAssertEqual(viewModel.high, "High: $100.000,00")
                
                XCTAssertEqual(viewModel.volume, "Volume: $20.000,00")
                
                XCTAssertNotEqual(viewModel.ask, "Ask: $123.00")
                
                XCTAssertNotEqual(viewModel.bid, "Bid: $123.00")
                
                XCTAssertNotEqual(viewModel.change, "Change 24hs: $122.00")
                
                XCTAssertNotEqual(viewModel.high, "High: $100,000.00")
                
                XCTAssertNotEqual(viewModel.volume, "Volume: $20,000.00")
                
                expectation.fulfill()
            case .error(_):
                break
            case .loading:
                break
            }
        }.store(in: &cancelBag)

        wait(for: [expectation], timeout: 2)
    }
    
    func testFormattedPropertiesMexicanLocale() {
        let mexicoFormatter = NumberFormatter()
        mexicoFormatter.numberStyle = .currency
        mexicoFormatter.locale = Locale(identifier: "es_MX")
        mexicoFormatter.maximumFractionDigits = 20
        let mockAPIClient = APIClientMock(response: BookDetailResponse(payload: BookDetailViewModelTests.basicDetail))
        let booksManager = BooksManager(apiClient: mockAPIClient, numberFormatter: mexicoFormatter)
       
       let viewModel = BookDetailViewModel(booksManager: booksManager, book: BookDetailViewModelTests.basicBook, output: nil)
        
        let expectation = self.expectation(description: "expectation")
        viewModel.$state.sink { output in
            switch output {
            case .loaded:
                XCTAssertNotEqual(viewModel.ask, "Ask: $123,00")
                
                XCTAssertNotEqual(viewModel.bid, "Bid: $123,00")
                
                XCTAssertNotEqual(viewModel.change, "Change 24hs: $122,00")
                
                XCTAssertNotEqual(viewModel.high, "High: $100.000,00")
                
                XCTAssertNotEqual(viewModel.volume, "Volume: $20.000,00")
                
                XCTAssertEqual(viewModel.ask, "Ask: $123.00")
                
                XCTAssertEqual(viewModel.bid, "Bid: $123.00")
                
                XCTAssertEqual(viewModel.change, "Change 24hs: $122.00")
                
                XCTAssertEqual(viewModel.high, "High: $100,000.00")
                
                XCTAssertEqual(viewModel.volume, "Volume: $20,000.00")
                
                expectation.fulfill()
            case .error(_):
                break
            case .loading:
                break
            }
        }.store(in: &cancelBag)

        wait(for: [expectation], timeout: 2)
    }

    
}
