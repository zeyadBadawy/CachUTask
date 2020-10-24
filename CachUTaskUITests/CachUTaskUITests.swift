//
//  CachUTaskUITests.swift
//  CachUTaskUITests
//
//  Created by zeyad on 10/23/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import XCTest

class CachUTaskUITests: XCTestCase {

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testTableInteraction() {
        let app = XCUIApplication()
        app.launch()
        
        // Assert that we are displaying the tableview
        let productTableView = app.tables["ProductTableView"]
        
        XCTAssertTrue(productTableView.exists, "The Product tableview exists")
        
        // Get an array of cells
        let tableCells = productTableView.cells
        print("Count of table cells \(tableCells.count)")
        
        if tableCells.count > 0 {
                   let count: Int = (tableCells.count - 1)
                   
                   let promise = expectation(description: "Wait for table cells")
                   
                   for i in stride(from: 0, to: count , by: 1) {
                       // Grab the first cell and verify that it exists and tap it
                       let tableCell = tableCells.element(boundBy: i)
                       XCTAssertTrue(tableCell.exists, "The \(i) cell is in place on the table")
                       // Does this actually take us to the next screen
                       tableCell.tap()
                       
                       if i == (count - 1) {
                           promise.fulfill()
                       }
                    addUIInterruptionMonitor(withDescription: "System Dialog") {
                      (alert) -> Bool in
                      alert.buttons["Ok"].tap()
                      return true
                    }
                   }
                   waitForExpectations(timeout: 20, handler: nil)
                   XCTAssertTrue(true, "Finished validating the table cells")
                   
               } else {
                   XCTAssert(false, "Was not able to find any table cells")
               }
    }
    
    
}
