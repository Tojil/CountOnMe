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

    var calculText: String = "1 + 1 = 2" {
        didSet {
            calculatorDisplayDelegate?.updateCalcul(calculText: calculText)
        }
    }
    
    var elements: [String] {
        var elements = calculText.split(separator: " ").map { "\($0)" }
        if elements.first == "-" {
            // devoir verifier que elements[1] est bien un chiffre si non envoyer une alerte
            if elements[1] != "\(canAddOperator)" {
                elements[1] = "-\(elements[1])"
                elements.removeFirst()
            } else {
                calculatorDisplayDelegate?.showAlert(message: "Un operateur est déja mis !")
            }
        }
        return elements
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "*"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "*"
    }
    
    var expressionHaveResult: Bool {
        return calculText.firstIndex(of: "=") != nil
    }
    
    var expressionHaveDivisionByZero: Bool {
        return calculText.contains("/ 0")
    }
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 3
        return numberFormatter
    }()
    
    
    func tappedClearButton() {
        calculText = ""
    }
    
    func tappedNumberButton(numberText: String) {
        if expressionHaveResult {
            calculText = ""
        }
        
        calculText.append(numberText)
    }
    
//    func tappedAdditionButton() {
//
//        if expressionHaveResult {
//            tappedClearButton()
//        }
//
//        if canAddOperator && !calculText.isEmpty {
//            calculText.append(" + ")
//        } else {
//            calculatorDisplayDelegate?.showAlert(message: "Un operateur est déja mis !")
//        }
//    }
    
//    func tappedSubstractionButton() {
//        if expressionHaveResult {
//                   tappedClearButton()
//               }
//        if canAddOperator {
//            calculText.append(" - ")
//        } else {
//            calculatorDisplayDelegate?.showAlert(message: "Un operateur est déja mis !")
//        }
//    }
    
//    func tappedDivisionButton() {
//
//        if expressionHaveResult {
//            tappedClearButton()
//        }
//
//        if canAddOperator && !calculText.isEmpty {
//            calculText.append(" / ")
//        } else {
//            calculatorDisplayDelegate?.showAlert(message: "Impossible de damarrer avec / !")
//        }

//    }
//
//    func tappedMultiplicationButton() {
//
//        if expressionHaveResult {
//            tappedClearButton()
//        }
//
//        if canAddOperator && !calculText.isEmpty {
//            calculText.append(" * ")
//        } else {
//            calculatorDisplayDelegate?.showAlert(message: "Impossible de damarrer avec * !")
//        }
//    }
    
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
    
    func priorityCalcul(elements: [String]) -> [String] {
        var tempElements = elements
        // Ici devoir faire un boucle while qui va chequer si tempElements contien un multipliant ou contien un diviser
        while tempElements.contains("*") || tempElements.contains("/") {
                    //Ici je vais recuperer l'index du premier signe multiplier ou diviser que je rencontre
            if let index = tempElements.firstIndex(where: { $0 == "*" || $0 == "/"}) {
                //maintenant qu'on a l'index on va recuperer la valeur de cette index
                let mathOperator = tempElements[index]
                        //aller recuperer le chifre a gauche (index - 1) et ensuite
                guard let leftNumber = Double(tempElements[index - 1]) else { return [] }
                       //ensuite recuperer le chifre a droite avec (index + 1)
                guard let rightNumber = Double(tempElements[index + 1]) else { return [] }
                  // si l'operteur est un multiplier alors chifre de gauche multiplier par chifre de droite si non chifre de gauche diviser par chifr de droite et on stocke le resultat du calcul dans une variable
                let result: Double
                if mathOperator == "*" {
                    result = leftNumber * rightNumber
                } else {
                    result = leftNumber / rightNumber
                }
                // Maintenant qu'on a le resultat du calcul on va remplacer le chifre de gauche par le resultat du calcul
                tempElements[index - 1] = String(result)
                        // on va suprimer le chifre de droite
                tempElements.remove(at: index + 1)
                        // et on suprime l'operateur
                tempElements.remove(at: index)
            }
        }
        return tempElements
    }
}

