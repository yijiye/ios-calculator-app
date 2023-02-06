//
//  ExpressionParser.swift
//  Calculator
//
//  Created by jiye Yi on 2023/01/27.
//

enum ExpressionParser {
    static func parse(from input: String) -> Formula {
        let components = componentsByOperator(from: input)
        
        let operand: [Double] = components.compactMap { Double($0) }
        let operators: [Operator] = input.compactMap { Operator(rawValue: $0) }
        
        let operandValue = CalculatorItemQueue<Double>(items: operand)
        let operatorValue = CalculatorItemQueue<Operator>(items: operators)
        
        let result: Formula = Formula(operands: operandValue, operators: operatorValue)
        
        return result
    }
    
    private static func componentsByOperator(from input: String) -> [String] {
        var result: [String] = [input]
        
        Operator.allCases.forEach { `operator` in
            result = result.flatMap {
                $0.split(with: `operator`.rawValue)
            }
        }
        
        return result
    }
    
}

