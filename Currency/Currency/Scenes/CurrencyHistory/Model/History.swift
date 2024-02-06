//
//  History.swift
//  Currency
//
//  Created by Saud Temp on 05/02/2024.
//

import Foundation

struct History: Codable {
    let success: Bool
    let timestamp: Int
    let historical: Bool
    let base, date: String
    let rates: [String: Double]
}
