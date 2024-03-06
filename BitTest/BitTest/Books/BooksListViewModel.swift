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

    @Published var books: [Book] = []

    enum Input {
        case tappedBook
        case refreshData

    }

    enum Output {
        case openBookDetail

    }

    func input(_ input: Input) {
        switch input {
        case .tappedBook: break

        case .refreshData:
            loadBooks()
        }

    }

    var output: ((Output) -> Void)?
    let booksManager: BooksManager


    init(booksManager: BooksManager = BooksManager.shared,
         output: ((Output) -> Void)?) {
        self.output = output
        self.booksManager = booksManager
        self.loadBooks()
    }
    
    private func loadBooks() {
        booksManager.getBooks { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let books):
                strongSelf.books = books.payload
            case .failure(let error):
                print("error")
            }
        }
    }

}
