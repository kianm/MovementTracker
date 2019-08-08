//
//  Movement+CoreDataClass.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Movement)
public class Movement: NSManagedObject, ManagedObjectType {
    
    public static var entityName: String {
        return "Movement"
    }
    
    public static var defaultPredicate: NSPredicate?
    
    static func insert(intoContext: NSManagedObjectContext, fromList: [MovementRecord]) {
        
        for movementRecord in fromList {
            let record = NSManagedObject(entity: entityDescription(inContext: intoContext), insertInto: intoContext)
            guard let movementObject = record as? Movement else {
                return
            }
            movementObject.lat = movementRecord.lat
            movementObject.long = movementRecord.lon
            movementObject.mode = movementRecord.mod
            movementObject.timeStamp = movementRecord.timeStamp
        }
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        let sort1 = NSSortDescriptor(key: #keyPath(Movement.timeStamp), ascending: false)
        return [sort1]
    }
}
