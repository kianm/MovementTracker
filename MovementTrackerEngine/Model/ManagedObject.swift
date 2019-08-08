//
//  ManagedObject.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import CoreData


public protocol ManagedObjectType {
    static var  entityName: String { get }
    static var  defaultSortDescriptors: [NSSortDescriptor] { get }
    static var  defaultPredicate: NSPredicate? { get }
}

extension ManagedObjectType {
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var defaultPredicate: NSPredicate? {
        return nil
    }
}


extension ManagedObjectType {
    
    static func entityDescription(inContext: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: inContext)!
    }
}

extension ManagedObjectType {
    
    public static var sortedFetchRequest: NSFetchRequest<NSFetchRequestResult> {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = defaultPredicate
        request.fetchBatchSize = 60
        return request
    }
    
    
    static func fetchRequest(id: Int) ->NSFetchRequest<NSFetchRequestResult>? {
        
        let request = sortedFetchRequest
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        return request
        
    }
    
    static func fetchRecord(id: Int, withContext: NSManagedObjectContext) -> [NSManagedObject]? {
        
        var result: [NSManagedObject]?
        guard let request = fetchRequest(id: id) else {
            return result
        }
        
        do {
            let records = try withContext.fetch(request)
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entityName  ).")
        }
        return result
    }
    
    
}


