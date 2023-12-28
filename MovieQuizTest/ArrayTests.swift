//
//  ArrayTests.swift
//  MovieQuizTest
//
//  Created by Malik Timurkaev on 18.12.2023.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {

    func testGetValueInRange () throws {
        
        let array = [1, 2, 3, 4, 5]
    
        let result = array[safe: 2]
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, array[2])
    }
    
    func testGetValueOutOfTest() throws {
        
        let array = [1, 2, 3, 4, 5]
        
        let value = array[safe: 6]
        
        XCTAssertNil(value)
    }
}
