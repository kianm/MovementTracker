//
//  RecordProvider.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/4/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import CoreData

public class RecordProvider<T:ManagedObjectType, U:ConvertibleManagedObject>: NSObject, DataProvider, NSFetchedResultsControllerDelegate {
    
    public typealias Object = U
    
    
    public weak var delegate: DataProviderDelegate?

    public func set(delegate: DataProviderDelegate) {
        self.delegate = delegate
    }
    
    lazy var moc:NSManagedObjectContext = {
        guard let service = MovementTrackerManager.sharedInstance?.databaseService else {
            fatalError("database not initialized!")
        }
        return service.mainMOC! //TODO
    }()
    lazy var dataFetcher: DataFetcherType = {
        return DataFetcher<T>(moc: self.moc, delegate: self)
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        return self.dataFetcher.fetchedResultsController
    }()
    
    public func performFetch() {
        dataFetcher.performFetch()
    }
    
    var dataProviderUpdates: [DataProviderUpdate<PlainRecord>] = []
    
    public func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        guard let managedObject = fetchedResultsController.object(at: indexPath) as? T else {
            fatalError("object not the correct type at \(indexPath)")
        }

        let mor: U = U.from(object: managedObject)
        return mor
    }
    
    public func numberOfItemsInSection(_ section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    public func numberOfSections() -> Int {
        guard let count = fetchedResultsController.sections?.count else {
            return 0
        }
        return count
    }
    
    public func image(at indexPath: IndexPath, tag: String, completion: @escaping (UIImage?) -> ()) {
    }
 
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
       
        
        switch type {
        case .insert:
            guard  let newIndexPath = newIndexPath else { fatalError(".insert nil newIndexPath") }
            dataProviderUpdates.append(.insert(newIndexPath))
        case .update:
            guard  let indexPath = indexPath else { fatalError(".update nil indexPath") }
            let object = objectAtIndexPath(indexPath)
            dataProviderUpdates.append(.update(indexPath, object))
        case .move:
            guard  let newIndexPath = newIndexPath else { fatalError(".move nil newIndexPath") }
            guard  let indexPath = indexPath else { fatalError(".move nil indexPath") }
            dataProviderUpdates.append(.move(indexPath, newIndexPath))
        case .delete:
            guard  let indexPath = indexPath else { fatalError(".delete nil indexPath") }
            dataProviderUpdates.append(.delete(indexPath))
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataProviderUpdates = []
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataProviderDidUpdate(dataProviderUpdates)
    }
}

