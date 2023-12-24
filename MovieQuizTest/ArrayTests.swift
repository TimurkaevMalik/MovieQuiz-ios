//
//  ArrayTests.swift
//  MovieQuizTest
//
//  Created by Malik Timurkaev on 18.12.2023.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    func testGetValueInRange () throws {
        // Given
               let array = [1, 2, 3, 4, 5]
        // When
              let result = array[safe: 2]
        // Then
              XCTAssertNotNil(result)
              XCTAssertEqual(result, array[2])
    }
    
    func testGetValueOutOfTest() throws {
        // Given
             let array = [1, 2, 3, 4, 5]
        // When
        let value = array[safe: 6]
        // Then
        XCTAssertNil(value)
    }
}
