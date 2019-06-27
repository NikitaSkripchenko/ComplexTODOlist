//
//  StepikTests.swift
//  StepikTests
//
//  Created by iosdev on 6/27/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import XCTest
@testable import Stepik

class StepikTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let note = Note(title: "", content: "", priority: .base)
        let title = note.title
        
        XCTAssertEqual("", title )
        XCTAssertNotNil(note.uid)
        XCTAssertEqual(UIColor.white, note.color)
        XCTAssertEqual(Priority.base, note.priority)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
