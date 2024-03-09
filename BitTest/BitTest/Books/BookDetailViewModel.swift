//
//  BookDetailViewModel.swift
//  BitTest
//
//  Created by Rodrigo Arsuaga on 6/3/24.
//

import Foundation
import Domain
import SwiftUI

@MainActor
final class BookDetailViewModel: ObservableObject {

    private var book: Book?
    @Published private(set) var bookDetail: BookDetail? = nil
    @Published private(set) var state: State = .loading
    @Published var showError: Bool = false
    
    enum Input {
        case refreshData
    }

    enum Output {
       
    }

    func input(_ input: Input) {
        switch input {

        case .refreshData:
            guard let book = book else { return }
            getBookDetails(book: book)
        }

    }
    
    enum VMError: Equatable {
        case connectionError
        case noDataError
        case decodingError
    }
    
    enum State: Equatable {
        case loaded
        case error(VMError)
        case loading
    }

    var isLoading: Bool { state == .loading }
    
    func getName(book: Book) -> String {
       return booksManager.getFormattedName(book: book)
    }
    
    var title: String {
        guard let book = book else { return "--" }
        return "\(booksManager.getFormattedName(book: book)) Details"
    }
    
    
    var volume: String {
        guard let bookDetail = bookDetail else { return "--" }
        return "Volume: \(booksManager.getFormattedVolume(detail: bookDetail))"
    }

    var high: String {
        guard let bookDetail = bookDetail else { return "--" }
        return "High: \(booksManager.getFormattedHigh(detail: bookDetail))"
    }

    var change: String {
        guard let bookDetail = bookDetail else { return "--" }
        return "Change 24hs: \(booksManager.getFormattedChange(detail: bookDetail))"
    }

    var ask: String {
        guard let bookDetail = bookDetail else { return "--" }
        return "Ask: \(booksManager.getFormattedAsk(detail: bookDetail))"
    }

    var bid: String {
        guard let bookDetail = bookDetail else { return "--" }
        return "Bid: \(booksManager.getFormattedBid(detail: bookDetail))"
    }

   
    var output: ((Output) -> Void)?
    private let booksManager: BooksManager


    init(booksManager: BooksManager = BooksManager.shared,
         book: Book?,
         output: ((Output) -> Void)?) {
        self.output = output
        self.booksManager = booksManager
        self.book = book
        self.getBookDetails(book: book!)
      
    }
    
    
    private func getBookDetails(book: Book) {
        booksManager.getBookDetail(book: book) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let book):
                strongSelf.state = .loaded
                strongSelf.bookDetail = book.payload
            case .failure(let error):
                switch error {
                case .decodingError:
                    strongSelf.state = .error(.decodingError)
                case .serverError:
                    strongSelf.state = .error(.noDataError)
                case .urlError:
                    strongSelf.state = .error(.connectionError)
                }
                strongSelf.showError = true
            }
        }
    }

}
