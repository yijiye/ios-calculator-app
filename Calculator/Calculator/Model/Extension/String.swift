//
//  Extension.swift
//  Calculator
//
//  Created by jiye Yi on 2023/01/27.
//

extension String {
    func split(with target: Character) -> [String] {
        return split(separator: target).map { String($0) }
    }
}

extension String: CalculateItemProtocol { }
