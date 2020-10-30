//
//  Calculator.swift
//  CountOnMe
//
//  Created by Sergio Canto  on 25/03/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDisplay {
    func updateCalcul(calculText: String)
    func showAlert(message: String)
}

class Calculator {
    var calculatorDisplayDelegate: CalculatorDisplay?
    
    /// It is the element that stores the calculation
    var calculText: String = "1 + 1 = 2" {
        didSet {
            calculatorDisplayDelegate?.updateCalcul(calculText: calculText)
        }
    }
    /// Transforms the calculText  into an array of String
    private var elements: [String] {
        var elements = calculText.split(separator: " ").map { "\($0)" }
        if elements.first == "-" {
            if elements.count >= 2 {
                elements[1] = "-\(elements[1])"
                elements.removeFirst()
            }
        }
        return elements
    }
    
    
    ///Check if expression is correct
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "*"
    }
    
    ///Check if expression have enough elements
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    ///Check if we can add operator to calculation
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "*"
    }
    
    ///Check if expression have result
    private var expressionHaveResult: Bool {
        return calculText.firstIndex(of: "=") != nil
    }
    
    ///Check if expression divides by zero
    private var expressionHaveDivisionByZero: Bool {
        var tempElements = elements
        while let index = tempElements.firstIndex(of: "/") {
            if tempElements[index + 1] == "0" {
                return true
            }
            tempElements.remove(at: index)
        }
        return false
    }
    
    /// Format the result of the calculation
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 3
        return numberFormatter
    }()
    
    /// Reset the calcul
    func tappedClearButton() {
        calculText = ""
    }
    
    /// Add new number to the calcul
    func tappedNumberButton(numberText: String) {
        if expressionHaveResult {
            calculText = ""
        }
        
        calculText.append(numberText)
    }
    
    /// Add new operator to the calcul
    func tappedOperatorButton(operatorText: String) {
        if expressionHaveResult {
            tappedClearButton()
        }
 
        if (canAddOperator && !calculText.isEmpty) || (calculText.isEmpty && operatorText == "-") {
            calculText.append(" \(operatorText) ")
        } else {
            calculatorDisplayDelegate?.showAlert(message: "Impossible de damarrer avec \(operatorText) !")
        }
    }
    /// Add equals and perform the operation
    func tappedEqualButton() {
        guard expressionIsCorrect else {
            calculatorDisplayDelegate?.showAlert(message: "Entrez une expression correcte !")
            return
        }
        guard expressionHaveEnoughElement else {
            calculatorDisplayDelegate?.showAlert(message: "Démarrez un nouveau calcul !")
            return
        }
        
        guard !expressionHaveDivisionByZero else {
            calculatorDisplayDelegate?.showAlert(message: "Impossible de diviser par zero !")
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = priorityCalcul(elements: elements)
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            guard let left = Double(operationsToReduce[0]) else { return}
            let operand = operationsToReduce[1]
            guard let right = Double(operationsToReduce[2]) else { return}
            
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: return
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        guard let result = operationsToReduce.first else {return}
        guard let resultDoubled = Double(result) else { return }
        guard let resultFormatted = numberFormatter.string(from: NSNumber(value: resultDoubled)) else { return }
        calculText.append(" = \(resultFormatted)")
    }
    
    /// Execute all multiplications and divides in the calcul
    private func priorityCalcul(elements: [String]) -> [String] {
        var tempElements = elements
        while tempElements.contains("*") || tempElements.contains("/") {
            if let index = tempElements.firstIndex(where: { $0 == "*" || $0 == "/"}) {
                let mathOperator = tempElements[index]
                guard let leftNumber = Double(tempElements[index - 1]) else { return [] }
                guard let rightNumber = Double(tempElements[index + 1]) else { return [] }
                let result: Double
                if mathOperator == "*" {
                    result = leftNumber * rightNumber
                } else {
                    result = leftNumber / rightNumber
                }
                tempElements[index - 1] = String(result)
                tempElements.remove(at: index + 1)
                tempElements.remove(at: index)
            }
        }
        return tempElements
    }
}

