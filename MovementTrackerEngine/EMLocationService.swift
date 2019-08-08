//
//  EMLocationService.swift
//  MovementTrackerEngine
//
//  Created by Kian Mehravaran on 3/5/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import Foundation

class EMLocationService: LocationServiceType {
    
    private weak var locationServiceUpdateDelegete: LocationServiceUpdatesDelegate?

    let timeInterval: TimeInterval = 5.0 
    var autoUploadTimer: Timer!
    var desiredAccuracy: Double = 100.0
    
    required convenience init(desiredAccuracy: Double) {
        self.init()
        self.desiredAccuracy = desiredAccuracy
    }
    
    func startUpdatingLocation(updatesDelegate: LocationServiceUpdatesDelegate) {
       
        self.locationServiceUpdateDelegete = updatesDelegate

        self.autoUploadTimer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                               repeats: true,
                                               block: { [weak self] timer in
                                                self?.timerTriggered(timer: timer)
        })
        
    }
    
    func timerTriggered(timer: Timer) {
        
        var records: [MovementRecord] = []
        let lat = Double(Double(arc4random()) / Double(UINT32_MAX)) * 360.0 - 180.0
        let lon = Double(Double(arc4random()) / Double(UINT32_MAX)) * 360.0 - 180.0
        records.append(MovementRecord(lat: lat, lon: lon, mod: 0, timeStamp: Date()))
        self.locationServiceUpdateDelegete?.locationUpdated(records)
        var activity = PackedActivityType(rawValue: 0)
        activity.automotive = true
        activity.stationary = true
        self.locationServiceUpdateDelegete?.motionActivityUpdated(activity)
    }
}
