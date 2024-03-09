//
//  BookDetailViewController.swift
//  BitTest
//
//  Created by Rodrigo Arsuaga on 6/3/24.
//

import Foundation
import UIKit
import SwiftUI

class BookDetailViewController: UIViewController {
    
    private var hostingController: UIHostingController<BookDetailView>?
    
    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }

    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let viewModel: BookDetailViewModel

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    private func configureUI() {
        let v = BookDetailView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: v)
        
        self.hostingController = hostingController
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
    }
}
