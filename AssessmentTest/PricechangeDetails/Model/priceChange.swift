//
//  priceChange.swift
//  AssessmentTest
//
//  Created by Viabhav Powar on 23/05/22.
//

import Foundation
// MARK: - Welcome
struct priceChange: Codable {
   
    let priceChange: [Double]
    let symbol: [String]
    let price: [Double]
   
    enum CodingKeys: String, CodingKey {
        case priceChange = "price_change"
        case symbol, price
    }
    init(priceChange: [Double], symbol: [String], price: [Double]) {
        self.priceChange = priceChange
        self.symbol = symbol
        self.price = price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let symbol = try container.decode([String].self, forKey: .symbol)

        let priceChangeString = try container.decode([String].self, forKey: .priceChange)
        let priceChange = priceChangeString.map{$0.double() ?? 0}


        let priceString = try container.decode([String].self, forKey: .price)
        let price = priceString.map{$0.double() ?? 0}
        

        self.init(priceChange: priceChange, symbol: symbol, price: price)
    }

}

