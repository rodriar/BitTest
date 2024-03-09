//
//  Book.swift
//  
//
//  Created by Rodrigo Arsuaga on 3/3/24.
//

import Foundation

public struct BooksResponse: Codable {
    public init(payload: [Book]) {
        self.payload = payload
    }
    
    public let payload: [Book]
}

public struct Book: Codable, Hashable {
    
    public init(defaultChart: String, minimumPrice: String, maximumPrice: String, book: String, minimumValue: String, maximumAmount: String, maximumValue: String, minimumAmount: String, tickSize: String) {
        self.defaultChart = defaultChart
        self.minimumPrice = minimumPrice
        self.maximumPrice = maximumPrice
        self.book = book
        self.minimumValue = minimumValue
        self.maximumAmount = maximumAmount
        self.maximumValue = maximumValue
        self.minimumAmount = minimumAmount
        self.tickSize = tickSize
    }
    
    
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
