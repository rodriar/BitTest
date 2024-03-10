//
//  BooksListViewModelTests.swift
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
final class BooksListViewModelTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    static let basicBook: Book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1234.56", book: "btc_mxn", minimumValue: "0.00000003", maximumAmount: "1", maximumValue: "1234.56", minimumAmount: "1", tickSize: "1")
    
    func testLoadingSuccessfully() {
        let mockAPIClient = APIClientMock(response: BooksResponse(payload: [BooksListViewModelTests.basicBook]))
        let booksManager = BooksManager(apiClient: mockAPIClient)
        
        let viewModel = BooksListViewModel(booksManager: booksManager, output: nil)
        
        let expectation = self.expectation(description: "testLoadingSuccessfullyExpectation")
        viewModel.$state.sink { output in
            switch output {
            case .loaded:
                if viewModel.books[0].book == BooksListViewModelTests.basicBook.book {
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
        
        let viewModel = BooksListViewModel(booksManager: booksManager, output: nil)
        
        let expectation = self.expectation(description: "testLoadingErrorExpectation")
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
    
    func testTimerSuccess() {
        let mockAPIClient = APIClientMock(response: BooksResponse(payload: [BooksListViewModelTests.basicBook]))
            let booksManager = BooksManager(apiClient: mockAPIClient)
            
            let viewModel = BooksListViewModel(booksManager: booksManager, timerTime: 4, output: nil)
            var loadedStateCount = 0
            
            let expectation = self.expectation(description: "expectationTimer")
            
            viewModel.$state
                .sink { output in
                    switch output {
                    case .loaded:
                        loadedStateCount += 1
                        if loadedStateCount == 3 {
                            viewModel.input(.invalidateTimer)
                            expectation.fulfill()
                        }
                    case .error(_), .loading:
                        break
                    }
                }.store(in: &cancelBag)

            wait(for: [expectation], timeout: 10)
    }
    
    func testInputRefreshSuccess() {
        let mockAPIClient = APIClientMock(response: BooksResponse(payload: [BooksListViewModelTests.basicBook]))
        let booksManager = BooksManager(apiClient: mockAPIClient)
        
        let viewModel = BooksListViewModel(booksManager: booksManager, timerTime: 2, output: nil)
        let expectation = self.expectation(description: "testInputRefreshSuccessExpectation")
        viewModel.$state
            .drop(while: { output in
                output != .loaded
            })
            .dropFirst()
            .sink { output in
            switch output {
            case .loaded:
                    expectation.fulfill()
            case .error(_):
                break
            case .loading:
                break
            }
        }.store(in: &cancelBag)
        
        viewModel.input(.refreshData)
        wait(for: [expectation], timeout: 2)
    }
    
    func testFormattedProperties() {
        let mockAPIClient = APIClientMock(response: BooksResponse(payload: [BooksListViewModelTests.basicBook]))
        let booksManager = BooksManager(apiClient: mockAPIClient)
        
        let viewModel = BooksListViewModel(booksManager: booksManager, output: nil)
        
        
        let expectation = self.expectation(description: "testFormattedPropertiesExpecation")
        viewModel.$state.sink { output in
            switch output {
            case .loaded:
                XCTAssertEqual(viewModel.getMaxPrice(book: viewModel.books.first!), "Max Price: $1.234,56")
                
                XCTAssertEqual(viewModel.getMaxValue(book: viewModel.books.first!), "Max val: $1.234,56")
                
                XCTAssertEqual(viewModel.getMinValue(book: viewModel.books.first!), "Min val: $0,00000003")
                
                XCTAssertEqual(viewModel.getName(book: viewModel.books.first!), "BTC MXN")
                
                XCTAssertNotEqual(viewModel.getMaxPrice(book: viewModel.books.first!), "Max Price: $1,234.56")
                
                XCTAssertNotEqual(viewModel.getMaxValue(book: viewModel.books.first!), "Max val: $1,234.56")
                
                XCTAssertNotEqual(viewModel.getMinValue(book: viewModel.books.first!), "Min val: $0.00000003")
                
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
        let mockAPIClient = APIClientMock(response: BooksResponse(payload: [BooksListViewModelTests.basicBook]))
        let booksManager = BooksManager(apiClient: mockAPIClient, numberFormatter: mexicoFormatter)
        
        let viewModel = BooksListViewModel(booksManager: booksManager, output: nil)
        
        
        let expectation = self.expectation(description: "testFormattedPropertiesMexicanLocaleExpectation")
        viewModel.$state.sink { output in
            switch output {
            case .loaded:
                XCTAssertNotEqual(viewModel.getMaxPrice(book: viewModel.books.first!), "Max Price: $1.234,56")
                
                XCTAssertNotEqual(viewModel.getMaxValue(book: viewModel.books.first!), "Max val: $1.234,56")
                
                XCTAssertNotEqual(viewModel.getMinValue(book: viewModel.books.first!), "Min val: $0,00000003")
                
                XCTAssertEqual(viewModel.getName(book: viewModel.books.first!), "BTC MXN")
                
                XCTAssertEqual(viewModel.getMaxPrice(book: viewModel.books.first!), "Max Price: $1,234.56")
                
                XCTAssertEqual(viewModel.getMaxValue(book: viewModel.books.first!), "Max val: $1,234.56")
                
                XCTAssertEqual(viewModel.getMinValue(book: viewModel.books.first!), "Min val: $0.00000003")
                
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
