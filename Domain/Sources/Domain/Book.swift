//
//  Book.swift
//  
//
//  Created by Rodrigo Arsuaga on 3/3/24.
//

import Foundation

public struct BooksResponse: Codable {
    public let payload: [Book]
}

public struct Book: Codable {
    
    public let defaultChart: String
    public let minimumPrice: String
    public let maximumPrice: String
    public let book: String
    public let minimumValue: String
    public let maximumAmount: String
    public let maximumValue: String
    public let minimumAmount: String
    public let tickSize: String

    enum CodingKeys: String, CodingKey {
        case defaultChart = "default_chart"
        case minimumPrice = "minimum_price"
        case maximumPrice = "maximum_price"
        case book
        case minimumValue = "minimum_value"
        case maximumAmount = "maximum_amount"
        case maximumValue = "maximum_value"
        case minimumAmount = "minimum_amount"
        case tickSize = "tick_size"
    }
}
