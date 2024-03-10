//
//  BooksListViewModel.swift
//  BitTest
//
//  Created by Rodrigo Arsuaga on 5/3/24.
//

import Foundation
import Domain
import SwiftUI

@MainActor
final class BooksListViewModel: ObservableObject {

    @Published private(set) var books: [Book] = []
    @Published private(set) var state: State = .loading
    @Published var showError: Bool = false
    
    enum Input {
        case tappedBook(Book)
        case refreshData
        case invalidateTimer
    }

    enum Output {
        case openBookDetail(Book)
    }

    func input(_ input: Input) {
        switch input {
        case .tappedBook(let book):
            output?(.openBookDetail(book))
        case .refreshData:
            loadBooks()
        case .invalidateTimer:
            timer?.invalidate()
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
   
    var output: ((Output) -> Void)?
    private let booksManager: BooksManager
    private weak var timer: Timer? = nil


    init(booksManager: BooksManager = BooksManager.shared,
         timerTime: Double = 30.0,
         output: ((Output) -> Void)?) {
        self.output = output
        self.booksManager = booksManager
        self.loadBooks()
        self.timer = Timer.scheduledTimer(timeInterval: timerTime, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    private func loadBooks() {
        booksManager.getBooks { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let books):
                strongSelf.books = books.payload
                strongSelf.state = .loaded
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
    
    func getName(book: Book) -> String {
       return booksManager.getFormattedName(book: book)
    }
    
    func getMaxPrice(book: Book) -> String {
       return "Max Price: \(booksManager.getFormattedMaximumPrice(book: book))"
    }
    
    func getMaxValue(book: Book) -> String {
       return "Max val: \(booksManager.getFormattedMaximumValue(book: book))"
    }
    
    func getMinValue(book: Book) -> String {
       return "Min val: \(booksManager.getFormattedMinimumValue(book: book))"
    }

    @objc private func fireTimer() {
        self.loadBooks()
    }
}
