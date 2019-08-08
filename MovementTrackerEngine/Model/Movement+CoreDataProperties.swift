//
//  Movement+CoreDataProperties.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//
//

import Foundation
import CoreData


extension Movement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movement> {
        return NSFetchRequest<Movement>(entityName: "Movement")
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var mode: Int16
    @NSManaged public var timeStamp: Date

}
