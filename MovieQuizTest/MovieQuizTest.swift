//
//  MovieQuizTest.swift
//  MovieQuizTest
//
//  Created by Malik Timurkaev on 17.12.2023.
//

import XCTest


struct ArithmeticOperations {
    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler( num1 + num2)
        }
    }
    
    func subtraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func multiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 * num2)
        }
    }
}


final class MovieQuizTest: XCTestCase {

    func testAddition() throws {
        let arithmeticalOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        let expectation = expectation(description: "Addition Function Expectetion")
        
        let result = arithmeticalOperations.addition(num1: num1, num2: num2) { result in
            XCTAssertEqual(result, 3)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}
