//
//  LocationService.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

protocol LocationServiceUpdatesDelegate: class {
    
    func locationUpdated(_ movements: [MovementRecord])
    func motionActivityUpdated(_ activity: PackedActivityType)
}

protocol LocationServiceType {
    init(desiredAccuracy: Double)
    func startUpdatingLocation(updatesDelegate: LocationServiceUpdatesDelegate)
}

class LocationService: NSObject, LocationServiceType {
    
    private weak var locationServiceUpdateDelegete: LocationServiceUpdatesDelegate?
    private var desiredAccuracy: Double = 100.0
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = desiredAccuracy
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        return locationManager
    }()
    
    //    confidence,2,unknown,0,stationary,1,walking,0,running,0,automotive,0,cycling,0
    private lazy var motionActivityManager: CMMotionActivityManager? = {
        if !CMMotionActivityManager.isActivityAvailable() {
            return nil
        }
        let motionActivityManager = CMMotionActivityManager()
        motionActivityManager.startActivityUpdates(to: OperationQueue.main, withHandler: motionActivityDidUpdate)
        return motionActivityManager
    }()
    
    required convenience init(desiredAccuracy: Double) {
        self.init()
        locationManager.delegate = self
        self.desiredAccuracy = desiredAccuracy
    }

    func startUpdatingLocation(updatesDelegate: LocationServiceUpdatesDelegate){
        self.locationServiceUpdateDelegete = updatesDelegate
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
}

//MARK: CLLocationManagerDelegate delegates

extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]){
        var records: [MovementRecord] = []
        for location in locations {
            records.append(MovementRecord(lat: location.coordinate.latitude, lon: location.coordinate.longitude, mod: 0, timeStamp: location.timestamp))
        }
        self.locationServiceUpdateDelegete?.locationUpdated(records)
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue{
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
        if status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            _ = motionActivityManager
        }
    }
}

//MARK: CMMotionActivityManager

extension LocationService {
    
    private func motionActivityDidUpdate(activity: CMMotionActivity?)  {
        guard let activity = activity else {
            return
        }
        self.locationServiceUpdateDelegete?.motionActivityUpdated(PackedActivityType(cmMotionActivity: activity))
    }
    
    //TODO might need to call this for the periods the app was in background, in case the above callback
    //is not active while background? Seems it's not necessary.
//    private func motionActivityForBackgroundPeriod(from: Date, to: Date) {
//        
//        motionActivityManager?.queryActivityStarting(from: from, to: to, to: OperationQueue.main) {activities, error in
//            guard let activities = activities else {
//                return
//            }
//            for activity in activities {
//                print(activity, activity.startDate)
//            }
//        }
//        
//    }
}


