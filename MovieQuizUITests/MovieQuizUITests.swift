//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Malik Timurkaev on 20.12.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        
    }
    func testErrorAlert() {
                sleep(2)
                let button = app.buttons["No"]
        
                for _ in 1...10 {
                    button.tap()
                    sleep(2)
                }
        
                let poster = app.images["Poster"]
                let posterData = poster.screenshot().pngRepresentation
        
                button.tap()
                sleep(2)
        
                let alert = app.alerts["Этот раунд окончен!"]
        
                alert.exists
        
                let alertButton = app.alerts["Этот раунд окончен!"].scrollViews.otherElements.buttons["Сыграть ещё раз"]
        
                alertButton.tap()
                sleep(2)
        
                let secPoster = app.images["Poster"]
                let secPosterData = secPoster.screenshot().pngRepresentation
        
                XCTAssertNotEqual(posterData, secPosterData)
        
    }
    
     func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game results"]
         let alertButton = app.alerts["Этот раунд окончен!"].scrollViews.otherElements.buttons["Сыграть ещё раз"]
         
         alertButton.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}

//func testExample() throws {
//
//    let app = XCUIApplication()
//    app.launch()
//}


//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
