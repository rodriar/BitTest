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

    }

    enum Output {
        case openBookDetail

    }

    func input(_ input: Input) {
        switch input {
        case .tappedBook: break

        }

    }

    var output: ((Output) -> Void)?



    init(booksManager: BooksManager = BooksManager.shared,
         output: ((Output) -> Void)?) {
        self.output = output
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
