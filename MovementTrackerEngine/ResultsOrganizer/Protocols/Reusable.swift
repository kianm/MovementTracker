//
//  Reusable.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/5/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import Foundation

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}
