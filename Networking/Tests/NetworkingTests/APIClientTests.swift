@testable import Networking
import XCTest

final class APIClientTests: XCTestCase {
    
    
    func testExecuteRequest_callback_void_success() {
        let api = APIClientMock(response: Void())
        let expectation = XCTestExpectation(description: #function)
        
        let req: APIRequest<Void> = APIRequest(url: URL(string: "www.google.com")!, method: "GET")
        
        _ = api.execute(req) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                break
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testExecuteRequest_callback_response_success() {
        struct Response: Codable, Equatable {
            let message: String
        }

        let api = APIClientMock(response: Response(message: "hello world"))
        let expectation = XCTestExpectation(description: #function)

        let req: APIRequest<Response> = APIRequest(url: URL(string: "www.google.com")!, method: "GET")

        let expectedResponse = Response(message: "hello world")

        _ = api.execute(req) { result in
            switch result {
            case .success(let response):
                if response == expectedResponse {
                    expectation.fulfill()
                }
            case .failure:
                break
            }
        }

        wait(for: [expectation], timeout: 2)
    }
    
    func testExecuteRequest_callback_decoding_failure() {
        struct Response: Codable, Equatable {
            let message: String
        }

        let api = APIClientFailingMock(error: APIError.decodingError)

        let expectation = XCTestExpectation(description: #function)

        let req: APIRequest<Response> = APIRequest(url: URL(string: "www.google.com")!, method: "GET")

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
    
    func testExecuteRequest_callback_url_failure() {
        struct Response: Codable, Equatable {
            let message: String
        }

        let api = APIClientFailingMock(error: APIError.urlError)

        let expectation = XCTestExpectation(description: #function)

        let req: APIRequest<Response> = APIRequest(url: URL(string: "www.google.com")!, method: "GET")

        _ = api.execute(req) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                if error == APIError.urlError {
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 2)
    }
    
    func testExecuteRequest_callback_server_failure() {
        struct Response: Codable, Equatable {
            let message: String
        }

        let api = APIClientFailingMock(error: APIError.serverError("error"))

        let expectation = XCTestExpectation(description: #function)

        let req: APIRequest<Response> = APIRequest(url: URL(string: "www.google.com")!, method: "GET")

        _ = api.execute(req) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                if error == APIError.serverError("error") {
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 2)
    }
    
    
    
}
