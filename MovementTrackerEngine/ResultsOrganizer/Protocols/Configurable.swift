//
//  Configurable.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/5/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import UIKit

public protocol Configurable {
    
    associatedtype Object
    func configure(object: Object, atIndexPath: IndexPath?)
}

public protocol ImageRequester {
    var listImageProvider: ListImageProvider? {get set}
}


extension UITableView {
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath, imageProvider: ListImageProvider) -> T where T: Reusable, T: ImageRequester {
        var cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
        cell.listImageProvider = imageProvider
        return cell
    }
}
