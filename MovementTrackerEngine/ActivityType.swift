//
//  PackedActivityType.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import Foundation
import CoreMotion

enum ConfidenceLevel: Int16 {
    case low =      1
    case medium =   2
    case high =     3
}

struct ActivityType {
    var unknown: Bool
    var stationary: Bool
    var walking: Bool
    var running: Bool
    var automotive: Bool
    var cycling: Bool
    var confidence: ConfidenceLevel
}

public struct PackedActivityType {
    
    var rawValue: Int16 = 0
    
    var unknown: Bool {
        get {
            return (rawValue & (1 << 0)) != 0
        }
        set(newValue) {
            rawValue |= newValue ? (1 << 0) : 0
        }
    }
    var stationary: Bool {
        get {
            return (rawValue & (1 << 1)) != 0
        }
        set(newValue) {
            rawValue |= newValue ? (1 << 1) : 0
        }
    }
    var walking: Bool {
        get {
            return (rawValue & (1 << 2)) != 0
        }
        set(newValue) {
            rawValue |= newValue ? (1 << 2) : 0
        }
    }
    var running: Bool {
        get {
            return (rawValue & (1 << 3)) != 0
        }
        set(newValue) {
            rawValue |= newValue ? (1 << 3) : 0
        }
    }
    var automotive: Bool {
        get {
            return (rawValue & (1 << 4)) != 0
        }
        set(newValue) {
            rawValue |= newValue ? (1 << 4) : 0
        }
    }
    var cycling: Bool {
        get {
            return (rawValue & (1 << 5)) != 0
        }
        set(newValue) {
            rawValue |= newValue ? (1 << 5) : 0
        }
    }
    var confidence: ConfidenceLevel? {
        get {
            return ConfidenceLevel(rawValue: (rawValue & (3 << 6)) >> 6)
        }
        set(newValue) {
            if let value = newValue {
                rawValue |= value.rawValue << 6
            }
        }
    }
    
    init(cmMotionActivity: CMMotionActivity) {
        
        self.unknown = cmMotionActivity.unknown
        self.stationary = cmMotionActivity.stationary
        self.walking = cmMotionActivity.walking
        self.running = cmMotionActivity.running
        self.automotive = cmMotionActivity.automotive
        self.cycling = cmMotionActivity.running
        
        switch cmMotionActivity.confidence {
        case .low:
            self.confidence = .low
        case .medium:
            self.confidence = .medium
        case .high:
            self.confidence = .high
        }
    }
    
    init(activityType: ActivityType) {
        self.unknown = activityType.unknown
        self.stationary = activityType.stationary
        self.walking = activityType.walking
        self.running = activityType.running
        self.automotive = activityType.automotive
        self.cycling = activityType.cycling
        self.confidence = activityType.confidence
    }
    
    init(rawValue: Int16) {
        self.rawValue = rawValue
    }
    
    public static func stringValue(_ rawValue: Int16) -> String {
        
        let packedActivity = PackedActivityType(rawValue: rawValue)
        var s: String = ""
        s += packedActivity.unknown ? "UNKNOWN." : ""
        s += packedActivity.stationary ? "STAT." : ""
        s += packedActivity.walking ? "WALK." : ""
        s += packedActivity.running ? "RUN." : ""
        s += packedActivity.automotive ? "AUTO." : ""
        s += packedActivity.cycling ? "CYCL." : ""
        if s.isEmpty {
            s = "UNKNOWN."
        }
        return s
    }
}

