//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    // MARK: - PROPERTIES
    
    private let calculator = Calculator()
    
    // MARK: - View Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.calculatorDisplayDelegate = self
    }
    
    
    // MARK: - ACTIONS
    
    @IBAction func tappedClearButton(_ sender: UIButton) {
        calculator.tappedClearButton()
    }
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.tappedNumberButton(numberText: numberText)
    }
    
    @IBAction func teppedOperatorButton(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else { return }
        calculator.tappedOperatorButton(operatorText: operatorText)
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.tappedEqualButton()
        
    }
    
}

// MARK: - Calculator Display

extension ViewController: CalculatorDisplay {
    func updateCalcul(calculText: String) {
        textView.text = calculText
        
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
}

