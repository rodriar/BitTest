//
//  BooksListView.swift
//  BitTest
//
//  Created by Rodrigo Arsuaga on 5/3/24.
//


import SwiftUI

struct BooksListView: View {

    @ObservedObject var viewModel: BooksListViewModel
    @Environment(\.colorScheme) private var colorScheme


    init(viewModel: BooksListViewModel) {
        self.viewModel = viewModel
    }

    private var title: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Your lists of books")
                    .font(.system(size: 42))
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }


    var body: some View {
     title
        List {
            ForEach(viewModel.books, id: \.self) { book in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(viewModel.getName(book: book))
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Text(viewModel.getMaxPrice(book: book))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text(viewModel.getMaxValue(book: book))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(viewModel.getMinValue(book: book))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .padding(.vertical)
        .refreshable {
            viewModel.input(.refreshData)
        }
    }
}

struct BooksListView_Previews: PreviewProvider {
    static var previews: some View {
        BooksListView(viewModel: BooksListViewModel(output: nil))
    }
}
