//
//  Calculator - ViewController.swift
//  Created by 리지.
//  Copyright © yagom. All rights reserved.

import UIKit

final class CalculatorViewController: UIViewController {
    
    @IBOutlet weak private var operatorInput: UILabel!
    @IBOutlet weak private var numberInput: UILabel!
    @IBOutlet weak private var calculatorItemsStackView: UIStackView!
    @IBOutlet weak private var calculatorItemsScrollView: UIScrollView!
    
    private var isFinishedCalculating: Bool = false
    private var currentNumber: String = Expression.zero {
        didSet {
            numberInput.text = NumberFormatter.applyDecimalPoint(number: currentNumber)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func operatorButtonTapped(_ sender: UIButton) {
        restartCalculate() //
        guard let senderSign = sender.currentTitle,
              let operand = numberInput.text else { return }
        let isNotZeroOperand = ![Expression.zero, Expression.doubleZero].contains(operand)
        let isFinishedDot = !operand.hasSuffix(Expression.dot)
        let hasStackViewOrOperad = !calculatorItemsStackView.subviews.isEmpty && !isNotZeroOperand
        
        if isNotZeroOperand && isFinishedDot {
            addStackView()
            operatorInput.text = senderSign
        } else if hasStackViewOrOperad {
            operatorInput.text = senderSign
        }
        currentNumber = Expression.zero
    }
    
    @IBAction private func numberButtonTapped(_ sender: UIButton) {
        restartCalculate()
        guard let number = sender.currentTitle,
              let operand = numberInput.text else { return }
        if numberInput.text == Expression.zero || numberInput.text == Expression.doubleZero  {
            numberInput.text = number
        } else {
            numberInput.text = operand + number
        }
    }
    
    @IBAction private func dotButtonTapped(_ sender: UIButton) {
        guard let dot = sender.currentTitle,
              let operand = numberInput.text else { return }
        guard !operand.contains(dot) else { return }
        numberInput.text = operand + dot
    }
    
    @IBAction private func changeSignButtonTapped(_ sender: UIButton) {
        guard var currentNumber = numberInput.text,
              currentNumber != Expression.zero,
              currentNumber != Expression.nan else { return }
        
        if let minus = currentNumber.firstIndex(of: Character(Expression.minus)) {
            currentNumber.remove(at: minus)
            numberInput.text = currentNumber
        } else {
            numberInput.text = Expression.minus + currentNumber
        }
    }
    
    @IBAction private func CEButtonTapped(_ sender: UIButton) {
        numberInput.text = Expression.zero
    }
    
    @IBAction private func ACButtonTapped(_ sender: UIButton) {
        resetCalculatorItemsView()
        resetNubmerInput()
        resetOperatorInput()
    }
    
    @IBAction private func equalButtonTapped(_ sender: UIButton) {
        if isFinishedCalculating == false {
            currentNumber = calculate()
            resetOperatorInput()
        }
        isFinishedCalculating = true
    }
    
    private func addStackView() {
        guard let operand = numberInput.text,
              let operatorStackLabel = operatorInput.text,
              let operandLabel = Double(operand) else {  return  }
        
        let operandStackLabel = NumberFormatter.applyDecimalPoint(number: String(operandLabel))
        let stackLabel = UILabel()
        stackLabel.text = operatorStackLabel + Expression.blank + operandStackLabel
        stackLabel.adjustsFontForContentSizeCategory = true
        stackLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        stackLabel.textColor = .white
        calculatorItemsStackView.addArrangedSubview(stackLabel)
        setScrollView()
    }
    
    private func restartCalculate() {
        if isFinishedCalculating == true {
            resetNubmerInput()
            resetCalculatorItemsView()
            isFinishedCalculating = false
        }
    }
    
    private func resetCalculatorItemsView() {
        calculatorItemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func resetNubmerInput() {
        currentNumber = Expression.zero
    }
    
    private func resetOperatorInput() {
        operatorInput.text = Expression.blank
    }
    
    private func setScrollView() {
        let bottomOffset: CGPoint = CGPointMake(0, calculatorItemsScrollView.contentSize.height)
        calculatorItemsScrollView.setContentOffset(bottomOffset, animated: false)
        calculatorItemsScrollView.layoutSubviews()
    }
    
    private func calculate() -> String {
        let calculateItem = arrangeCalculateItems()
        var formula = ExpressionParser.parse(from: calculateItem)
        guard let resultValue = formula.result() else { return Expression.empty }
        
        return String(resultValue)
    }
    
    private func arrangeCalculateItems() -> String {
        addStackView()
        var calculateItems: [String] = []
        calculatorItemsStackView.arrangedSubviews.forEach { view in
            if let label = view as? UILabel {
                guard let value = label.text else { return }
                calculateItems.append(value)
            }
        }
       
        return calculateItems.map { $0.components(separatedBy: Expression.blank).joined() }.joined(separator: Expression.empty)
    }
}

