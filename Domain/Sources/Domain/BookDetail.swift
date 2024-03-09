//
//  File.swift
//  
//
//  Created by Rodrigo Arsuaga on 6/3/24.
//

import Foundation

public struct BookDetailResponse: Codable {
    public init(payload: BookDetail) {
        self.payload = payload
    }
    
    public let payload: BookDetail
}


public struct BookDetail: Codable {
    public init(high: String, last: String? = nil, createdAt: String? = nil, book: String? = nil, volume: String, vwap: String? = nil, low: String? = nil, ask: String, bid: String, change24: String) {
        self.high = high
        self.last = last
        self.createdAt = createdAt
        self.book = book
        self.volume = volume
        self.vwap = vwap
        self.low = low
        self.ask = ask
        self.bid = bid
        self.change24 = change24
    }
    
    public let high: String
    public let last: String?
    public let createdAt: String?
    public let book: String?
    public let volume: String
    public let vwap: String?
    public let low: String?
    public let ask: String
    public let bid: String
    public let change24: String

    enum CodingKeys: String, CodingKey {
         case high
         case last
         case createdAt
         case book
         case volume
         case vwap
         case low
         case ask
         case bid
         case change24 = "change_24"
     }
}
