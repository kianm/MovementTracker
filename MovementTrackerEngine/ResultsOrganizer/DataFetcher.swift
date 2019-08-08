//
//  DataFetcher.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/4/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import CoreData

protocol DataFetcherType {
    var  fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {get}
    func performFetch()
}



public class DataFetcher<E:ManagedObjectType>: DataFetcherType {
    
    var moc: NSManagedObjectContext
    var delegate: NSFetchedResultsControllerDelegate

    public init(moc: NSManagedObjectContext, delegate: NSFetchedResultsControllerDelegate) {
        self.moc = moc
        self.delegate = delegate
    }
    
    
    public lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = { [unowned self] in

        let fetchRequest = sortedFetchRequest()
        let cacheName = "DataFetcherCache"
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: cacheName)
        controller.delegate = delegate
        return controller
    }()

    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    func sortedFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return E.sortedFetchRequest
    }
}

