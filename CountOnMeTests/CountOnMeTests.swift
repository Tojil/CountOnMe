//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Sergio Canto  on 19/03/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountOnMeTests: XCTestCase {
    var calculator: Calculator!
    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    
    func testAdditionMethod_WhenCalculIsCorrect_ThenShouldReturnCorrectResult() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "+")
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedEqualButton()
        XCTAssertEqual(calculator.calculText, "1 + 1 = 2")
    }

    func testSubstractionMethod_WhenCalculIsCorrect_ThenShouldReturnCorrectResult() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "-")
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedEqualButton()
        XCTAssertEqual(calculator.calculText, "1 - 1 = 0")
    }

    func testDivisionMethod_WhenCalculIsCorrect_ThenShouldReturnCorrectResult() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "/")
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedEqualButton()
        XCTAssertEqual(calculator.calculText, "1 / 1 = 1")
    }

    func testDivisionMethod_WhenCalculDiviseByZero_ThenShouldNotPossibleToDivideByZero() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "/")
        calculator.tappedNumberButton(numberText: "0")
        calculator.tappedEqualButton()
        XCTAssertEqual(calculator.calculText, "1 / 0")
    }

    func testMultiplicationMethod_WhenCalculIsCorrect_ThenShouldReturnCorrectResult() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "*")
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedEqualButton()
        XCTAssertEqual(calculator.calculText, "1 * 1 = 1")
    }

    func testCanAddOperatorVariable_WhenAdditionButtonIsPressedTwoTimes_ThenSouldNotWriteTheSecondPlusOperator() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "+")
        calculator.tappedOperatorButton(operatorText: "+")
        XCTAssertEqual(calculator.calculText, "1 + ")
    }

    func testCanAddOperatorVariable_WhenSubstractionButtonIsPressedTwoTimes_ThenShouldNotWriteTheSecondLestOperator() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "-")
        calculator.tappedOperatorButton(operatorText: "-")
        XCTAssertEqual(calculator.calculText, "1 - ")
    }

    func testCanAddOperatorVariable_WhenMultiplicationButtonIsPressedTwoTimes_ThenShouldNotWriteTheSecondMultOperator() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "*")
        calculator.tappedOperatorButton(operatorText: "*")
        XCTAssertEqual(calculator.calculText, "1 * ")
    }

    func testCanAddOperatorVariable_WhenDivisionButtonIsPressedTwoTimes_ThenShouldNotWriteTheSecondDivOperator() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "/")
        calculator.tappedOperatorButton(operatorText: "/")
        XCTAssertEqual(calculator.calculText, "1 / ")
    }

    func testClearButton_WhenClearButtonPressed_ThenNumbersDisappear() {
        calculator.tappedClearButton()
        XCTAssertEqual(calculator.calculText, "")
    }

    func testCanAddEqualButton_WhenEqualButtonIsPressedImmediatelyAfterAnyOperator_ThenShouldNotWriteTheEqualButton() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "+")
        calculator.tappedEqualButton()
        XCTAssertEqual(calculator.calculText, "1 + ")
    }

    func testCanAddEqualButton_WhenEqualButtonIsPresedWithoutEnoughElement_ThenShouldNotWriteTheEqualButton() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedEqualButton()
        XCTAssertEqual(calculator.calculText, "1")
    }

    func testCanAddClearButton_WhenClearButtonIsPressed_ThenShouldEmptyResult() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedClearButton()
        XCTAssertEqual(calculator.calculText, "")
    }

    func testCanAddClearButton_WhenExpresionHaveResult_ThenShouldEmptyResult() {
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "+")
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedEqualButton()
        calculator.tappedClearButton()
        XCTAssertEqual(calculator.calculText, "")
    }

    func testCanAddClearButton_WhenClearButtonIsTapped_ThenShouldResultEmpty() {
        calculator.tappedClearButton()
        XCTAssertEqual(calculator.calculText, "")
    }

    func testCanAddNegativeNumber_WhenIsNegativeNumberAtTheBigining_ThenShouldGoodResult () {
        calculator.tappedOperatorButton(operatorText: "-")
        calculator.tappedNumberButton(numberText: "1")
        calculator.tappedOperatorButton(operatorText: "+")
        calculator.tappedNumberButton(numberText: "1")
        XCTAssertEqual(calculator.calculText, "0")
    }
}
