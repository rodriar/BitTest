//
//  BookDetailView.swift
//  BitTest
//
//  Created by Rodrigo Arsuaga on 6/3/24.
//

import SwiftUI

struct BookDetailView: View {
    
    @ObservedObject var viewModel: BookDetailViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    
    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
    }
    
    private var title: some View {
        Text(viewModel.title)
              .font(.largeTitle)
              .fontWeight(.bold)
              .foregroundColor(Color.primary)
              .padding(.bottom, 20)
    }
    
    private func row(value: String) -> some View {
        Text(value)
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
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
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .scaleEffect(2)
        } else {
            VStack(spacing: 30) {
                title
                VStack(spacing: 10) {
                    row(value: viewModel.volume)
                    row(value: viewModel.high)
                    row(value: viewModel.change)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
                
                Divider()
                
                VStack(spacing: 10) {
                    row(value: viewModel.ask)
                    row(value: viewModel.bid)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
            }
            .padding()
            Spacer()
        }
    }
}



struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(viewModel: BookDetailViewModel(book: nil, output: nil))
    }
}
