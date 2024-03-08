//
//  File.swift
//  
//
//  Created by Rodrigo Arsuaga on 6/3/24.
//

import Foundation

public struct BookDetailResponse: Codable {
    public let payload: BookDetail
}


public struct BookDetail: Codable {
    public let high: String?
    public let last: String?
    public let createdAt: String?
    public let book: String?
    public let volume: String?
    public let vwap: String?
    public let low: String?
    public let ask: String?
    public let bid: String?
    public let change24: String?

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
