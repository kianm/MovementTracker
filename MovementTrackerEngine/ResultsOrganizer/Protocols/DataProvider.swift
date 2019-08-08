//
//  DataProvider.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/4/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import Foundation

public protocol DataProvider {
    associatedtype Object
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object
    func numberOfItemsInSection(_ section: Int) -> Int
    func numberOfSections() -> Int
    func image(at indexPath: IndexPath, tag: String, completion: @escaping (UIImage?) -> ())
}


public protocol DataProviderDelegate: class {
    func dataProviderDidUpdate(_ updates: [DataProviderUpdate<PlainRecord>]?)
}

public enum DataProviderUpdate<Object> {
    case insert(IndexPath)
    case update(IndexPath, Object)
    case move(IndexPath, IndexPath)
    case delete(IndexPath)
}
