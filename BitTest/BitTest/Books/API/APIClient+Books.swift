//
//  APIClient+Books.swift
//  BitTest
//
//  Created by Rodrigo Arsuaga on 9/3/24.
//

import Foundation
import Networking
import Domain

extension APIClient {
    
    static public func getBooks() -> APIRequest<BooksResponse> {
        let url = URL(string: "https://api.bitso.com/v3/available_books/")!
        return APIRequest<BooksResponse>(url: url, method: "GET", body: nil, headers: nil)
    }
    
    static public func getBookDetail(book: Book) -> APIRequest<BookDetailResponse> {
         let url = URL(string: "https://api.bitso.com/v3/ticker?book=\(book.book)")!
         return APIRequest<BookDetailResponse>(url: url, method: "GET", body: nil, headers: nil)
    }
}


