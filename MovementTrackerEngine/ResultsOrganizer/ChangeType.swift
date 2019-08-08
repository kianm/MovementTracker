//
//  ChangeType.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/4/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import CoreData

public enum ChangeType {
    case insert
    case delete
    case move
    case update
    init (type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self = .insert
        case .update:
            self = .update
        case .move:
            self = .move
        case .delete:
            self = .delete
        }
    }
}



