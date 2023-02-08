//
//  NumberFormatter.swift
//  Calculator
//
//  Created by jiye Yi on 2023/02/08.
//

import Foundation

extension NumberFormatter {
    static func applyDecimalPoint(number: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumSignificantDigits = 10
        guard let number = Double(number),
              let result = numberFormatter.string(from: NSNumber(value: number)) else { return Expression.empty }
        
        return result
    }
}
