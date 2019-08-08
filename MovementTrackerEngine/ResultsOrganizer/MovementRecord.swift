//
//  MovementRecord.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/4/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import Foundation

public protocol PlainRecord {
}

public protocol ConvertibleManagedObject: PlainRecord {
    associatedtype T: ManagedObjectType
    associatedtype U: PlainRecord
    static func from<T: ManagedObjectType, U: PlainRecord>(object: T) -> U
}

public struct MovementRecord: ConvertibleManagedObject {
    
    public typealias T = Movement
    public typealias U = MovementRecord
    
    public static func from<T, U>(object: T) -> U where T : ManagedObjectType, U : PlainRecord {
        guard let movement = object as? Movement else {
            fatalError("wrong object passed to MovementRecord.from")
        }
        return MovementRecord(lat: movement.lat, lon: movement.long, mod: movement.mode, timeStamp: movement.timeStamp) as! U
    }
    
    
    public let lat: Double
    public let lon: Double
    public var mod: Int16
    public let timeStamp: Date
}
