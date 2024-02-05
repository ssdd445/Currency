//
//  Double.swift
//  Currency
//
//  Created by Saud Temp on 05/02/2024.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
