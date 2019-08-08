//
//  MockLocationService.swift
//  MovementTrackerEngineTests
//
//  Created by Kian Mehravaran on 3/5/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import Foundation
@testable import MovementTrackerEngine

import Foundation

class MockLocationService: LocationServiceType {
    
    private weak var locationServiceUpdateDelegete: LocationServiceUpdatesDelegate?
    
    let timeInterval: TimeInterval = 5.0
    var autoUploadTimer: Timer!
    var desiredAccuracy: Double = 100.0
    var movementRecords: [MovementRecord] = []
    
    required convenience init(desiredAccuracy: Double) {
        self.init()
        self.desiredAccuracy = desiredAccuracy
    }
    
    func setMovementRecords(_ records: [MovementRecord]) {
        self.movementRecords = records
    }
    
    func startUpdatingLocation(updatesDelegate: LocationServiceUpdatesDelegate) {
        
        self.locationServiceUpdateDelegete = updatesDelegate
        
        for movement in self.movementRecords {
            if movement.mod != 0 {
                self.locationServiceUpdateDelegete?.motionActivityUpdated(PackedActivityType(rawValue: movement.mod))
            }
            self.locationServiceUpdateDelegete?.locationUpdated([movement])
        }
    }
}
