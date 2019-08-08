//
//  DBService.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import CoreData

public final class DBService {
        
    private let modelName = "MovementTracker"
    
    public func newPrivateMOC() -> NSManagedObjectContext? {
        let parentContext = self.mainMOC
        
        if parentContext == nil {
            return nil
        }
        
        let privateQueueContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateQueueContext.parent = parentContext
        privateQueueContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return privateQueueContext
    }
    
    lazy var mainMOC: NSManagedObjectContext? = {
        let parentContext = self.masterContext
        
        if parentContext == nil {
            return nil
        }
        
        var mainMOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainMOC.parent = parentContext
        mainMOC.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return mainMOC
    }()
    
    private lazy var masterContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        
        let masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = coordinator
        masterContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        return masterContext
    }()
    
    // MARK: - Setting up Core Data stack
    
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        guard let bundle = Bundle(identifier: "KIAN.MovementTrackerEngine") else {
            fatalError("Unable to find bundle")
        }
        
        guard let modelURL = bundle.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        print(persistentStoreURL)
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
}

extension NSManagedObjectContext {
    func saveRecursively() {
        performAndWait {
            if self.hasChanges {
                self.saveThisAndParentContexts()
            }
        }
    }
    
    func saveThisAndParentContexts() {
        do {
            try save()
            parent?.saveRecursively()
        } catch {
            let saveError = error as NSError
            print("Unable to Save Changes of Managed Object Context")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
}


extension DBService {
    
    public func deleteAllRecords(ofEntity: String?=nil) {
        let entitesByName = persistentStoreCoordinator.managedObjectModel.entitiesByName
        
        for (entity, _) in entitesByName {
            if let entityToDelete = ofEntity, entityToDelete != entity {
                continue
            }
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            if let newPrivateMOC = newPrivateMOC()
            {
                newPrivateMOC.performAndWait {
                    do {
                        try newPrivateMOC.execute(deleteRequest)
                    } catch {
                        print ("There was an error deleting \(entity)")
                    }
                }
                newPrivateMOC.saveRecursively()
            }
        }
    }
    
}

