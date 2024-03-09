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
    
    private func getAlert() -> Alert {
        switch viewModel.state {
        case .loaded, .loading:
            return Alert(title: Text("Something went wrong"))
        case .error(let vMError):
            switch vMError {
            case .decodingError:
                return  Alert(
                       title: Text("Oops"),
                       message: Text("Please update to the latest version of the app"),
                       primaryButton: .default(Text("Update")) {
                           // Send to store
                       },
                       secondaryButton: .default(Text("Contact Us")) {
                           // open email
                       }
                   )
            case .noDataError, .connectionError:
             return  Alert(
                    title: Text("Oops"),
                    message: Text("Something went wrong loading the data"),
                    dismissButton: .default(Text("Try Again")) {
                        viewModel.input(.refreshData)
                    }
                )
            }
        }
    }
    
    
    var body: some View {
        title
        if viewModel.isLoading{
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .scaleEffect(2)
        } else {
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
                    .onTapGesture {
                        viewModel.input(.tappedBook(book))
                    }
                    .padding()
                }
            }
            .padding(.vertical)
            .refreshable {
                viewModel.input(.refreshData)
            }
            .alert(isPresented: $viewModel.showError, content: {
                getAlert()
            })
        }
    }
}



struct BooksListView_Previews: PreviewProvider {
    static var previews: some View {
        BooksListView(viewModel: BooksListViewModel(output: nil))
    }
}
