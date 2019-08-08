//
//  ActivityTypeTests.swift
//  MovementTrackerEngineTests
//
//  Created by kianm on 3/6/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import XCTest
@testable import MovementTrackerEngine

class ActivityTypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        var activityType = PackedActivityType(rawValue: 2)
        XCTAssertEqual(activityType.unknown, false)
        XCTAssertEqual(activityType.stationary, true)
        XCTAssertEqual(activityType.walking, false)
        XCTAssertEqual(activityType.running, false)
        XCTAssertEqual(activityType.automotive, false)
        XCTAssertEqual(activityType.cycling, false)
        
        activityType = PackedActivityType(rawValue: 18)
        XCTAssertEqual(activityType.unknown, false)
        XCTAssertEqual(activityType.stationary, true)
        XCTAssertEqual(activityType.walking, false)
        XCTAssertEqual(activityType.running, false)
        XCTAssertEqual(activityType.automotive, true)
        XCTAssertEqual(activityType.cycling, false)
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}
