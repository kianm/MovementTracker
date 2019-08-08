//
//  MovementTrackerManager.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import Foundation
import CoreData

public class MovementTrackerManager {
    
    public static var desiredAccuracy: Double = 100.0
    
    public static var sharedInstance: MovementTrackerManager?
    
    private var locationService: LocationServiceType?
    public var databaseService: DBService?
    private var startTime: Date = Date()
    
    private var currentActivityType = PackedActivityType(activityType:ActivityType(unknown: true, stationary: false, walking: false, running: false, automotive: false, cycling: false, confidence: .low))
    
    private var launched: Bool = false
    
    public class func launch(accuracy: Double) {
        if sharedInstance == nil {
            _ = MovementTrackerManager(locationService: LocationService(desiredAccuracy: accuracy))
        }
        if let instance = sharedInstance {
            instance.launch()
        }
    }
    
    public class func launchEmulated(accuracy: Double) {
        if sharedInstance == nil {
            _ = MovementTrackerManager(locationService: EMLocationService())
        }
        if let instance = sharedInstance {
            instance.launch()
        }
    }
    
    func launch() {
        if launched {
            return
        }
        if let instance = MovementTrackerManager.sharedInstance {
            instance.locationService?.startUpdatingLocation(updatesDelegate: instance)
            launched = true
            startTime = Date()
        }
    }
    
    public class func reset() {
        
        if let instance = sharedInstance {
            if !instance.launched {
                instance.databaseService?.deleteAllRecords()
            }
        }
    }
    
    init(locationService: LocationServiceType) {
        if MovementTrackerManager.sharedInstance != nil {
            return
        }
        self.locationService = locationService
        self.databaseService = DBService()
        MovementTrackerManager.sharedInstance = self
    }
}


extension MovementTrackerManager: LocationServiceUpdatesDelegate {
    
    //TODO filter out the "too close" locations when we have multiple records
    func locationUpdated(_ movements: [MovementRecord]) {
        
        var movementsUpdated: [MovementRecord] = []
        for var movement in movements {
            movement.mod = self.currentActivityType.rawValue
            movementsUpdated.append(movement)
        }
        if let newPrivateMOC = databaseService?.newPrivateMOC()
        {
            newPrivateMOC.performAndWait {
                Movement.insert(intoContext: newPrivateMOC, fromList: movementsUpdated)
                newPrivateMOC.saveRecursively()
            }
        }
    }
    
    func motionActivityUpdated(_ activity: PackedActivityType) {
        self.currentActivityType = activity
    }
}

// MARK: Helper Methods
extension MovementTrackerManager {
    
    class func retrieveAllRecords() ->[Movement]  {
        var movements: [Movement] = []
        let databaseService = MovementTrackerManager.sharedInstance?.databaseService
        if let newPrivateMOC = databaseService?.mainMOC
        {
            newPrivateMOC.performAndWait {
                if let request: NSFetchRequest<Movement> = Movement.sortedFetchRequest as? NSFetchRequest<Movement> {
                do {
                    movements = try newPrivateMOC.fetch(request)
                } catch {
                }
            }
        }
    }
    return movements
}

}

