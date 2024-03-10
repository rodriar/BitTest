//
//  BookFlowController.swift
//  BitTest
//
//  Created by Rodrigo Arsuaga on 6/3/24.
//

import Combine
import Domain
import UIKit

final class BookFlowController: UINavigationController {

    init() {
        super.init(rootViewController: UIViewController())
        goBooksListView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func goBooksListView() {
        let vm = BooksListViewModel { [weak self] output in
            switch output {
            case .openBookDetail(let book):
                self?.goToBookDetails(book: book)
            }
        }
        let vc = BooksListViewController(viewModel: vm)
        setViewControllers([vc], animated: false)
    }
    
    private func goToBookDetails(book: Book) {
        let vm = BookDetailViewModel(book: book)
        let vc = BookDetailViewController(viewModel: vm)
        
        pushViewController(vc, animated: true)
    }
   
}
