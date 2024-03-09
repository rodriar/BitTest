//
//  APIClient+BooksTests.swift
//  BitTestTests
//
//  Created by Rodrigo Arsuaga on 9/3/24.
//

@testable import BitTest
import Foundation
import Networking
import XCTest
import Domain

final class APIClientBooksTests: XCTestCase {

    func testExecuteRequest_getBooks_success() {
        let book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1", book: "1", minimumValue: "1", maximumAmount: "1", maximumValue: "1", minimumAmount: "1", tickSize: "1")
        let bookResponse = BooksResponse(payload: [book])

        let api = APIClientMock(response: bookResponse)
        let expectation = XCTestExpectation(description: #function)

        let req: APIRequest<BooksResponse> = APIClient.getBooks()

        let expectedResponse = BooksResponse(payload: [book])

        _ = api.execute(req) { result in
            switch result {
            case .success(let response):
                if response.payload[0].book == expectedResponse.payload[0].book {
                    expectation.fulfill()
                }
            case .failure:
                break
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testExecuteRequest_getBookDetail_success() {
        let book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1", book: "1", minimumValue: "1", maximumAmount: "1", maximumValue: "1", minimumAmount: "1", tickSize: "1")
        
        let bookDetail = BookDetail(high: "1", volume: "1", ask: "1", bid: "1", change24: "1")
        let bookResponse = BookDetailResponse(payload: bookDetail)

        let api = APIClientMock(response: bookResponse)
        let expectation = XCTestExpectation(description: #function)

        let req: APIRequest<BookDetailResponse> = APIClient.getBookDetail(book: book)

        let expectedResponse = BookDetailResponse(payload: bookDetail)

        _ = api.execute(req) { result in
            switch result {
            case .success(let response):
                if response.payload.ask == expectedResponse.payload.ask {
                    expectation.fulfill()
                }
            case .failure:
                break
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testExecuteRequest_getBooks_failure() {
        let book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1", book: "1", minimumValue: "1", maximumAmount: "1", maximumValue: "1", minimumAmount: "1", tickSize: "1")
        let bookResponse = BooksResponse(payload: [book])

        let api = APIClientFailingMock(error: APIError.decodingError)
        let expectation = XCTestExpectation(description: #function)

        let req: APIRequest<BooksResponse> = APIClient.getBooks()

        let expectedResponse = BooksResponse(payload: [book])

        _ = api.execute(req) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                if error == APIError.decodingError {
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testExecuteRequest_getBookDetail_failure() {
        let book = Book(defaultChart: "1", minimumPrice: "1", maximumPrice: "1", book: "1", minimumValue: "1", maximumAmount: "1", maximumValue: "1", minimumAmount: "1", tickSize: "1")
        
        let bookDetail = BookDetail(high: "1", volume: "1", ask: "1", bid: "1", change24: "1")
        let bookResponse = BookDetailResponse(payload: bookDetail)

        let expectation = XCTestExpectation(description: #function)

        let api = APIClientFailingMock(error: APIError.decodingError)

        let expectedResponse = BookDetailResponse(payload: bookDetail)
        let req: APIRequest<BooksResponse> = APIClient.getBooks()

        _ = api.execute(req) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                if error == APIError.decodingError {
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 2)
    }

}
