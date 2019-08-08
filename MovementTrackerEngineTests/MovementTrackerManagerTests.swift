//
//  MovementTrackerEngineTests.swift
//  MovementTrackerEngineTests
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import XCTest
@testable import MovementTrackerEngine

class MovementTrackerManagerTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        let locationService = MockLocationService(desiredAccuracy: 100.0)
        let manager = MovementTrackerManager(locationService: locationService)
        MovementTrackerManager.reset()
        var date = Date()
        let record1 = MovementRecord(lat: 52.5, lon: 13.4, mod: 2, timeStamp: date)
        date = date.addingTimeInterval(5.0)
        let record2 = MovementRecord(lat: 52.6, lon: 13.5, mod: 0, timeStamp: date)
        date = date.addingTimeInterval(5.0)
        let record3 = MovementRecord(lat: 52.4, lon: 13.7, mod: 18, timeStamp: date)
        date = date.addingTimeInterval(5.0)
        let record4 = MovementRecord(lat: 52.8, lon: 13.9, mod: 0, timeStamp: date)
        let records = [record1, record2, record3, record4]
        locationService.setMovementRecords(records)
        manager.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let movements = MovementTrackerManager.retrieveAllRecords()
        XCTAssertEqual(movements.count, 4)
        var movement = movements[0]
        XCTAssertEqual(movement.lat, 52.8)
        XCTAssertEqual(movement.long, 13.9)
        XCTAssertEqual(movement.mode, 18)
        movement = movements[1]
        XCTAssertEqual(movement.lat, 52.4)
        XCTAssertEqual(movement.long, 13.7)
        XCTAssertEqual(movement.mode, 18)
        movement = movements[2]
        XCTAssertEqual(movement.lat, 52.6)
        XCTAssertEqual(movement.long, 13.5)
        XCTAssertEqual(movement.mode, 2)
        movement = movements[3]
        XCTAssertEqual(movement.lat, 52.5)
        XCTAssertEqual(movement.long, 13.4)
        XCTAssertEqual(movement.mode, 2)
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
}
