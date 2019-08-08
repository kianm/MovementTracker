//
//  MovementDataInteractor.swift
//  MovementTracker
//
//  Created by kianm on 3/4/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import UIKit
import MovementTrackerEngine
import CoreData

protocol MovementDataInteractorType {
    init(inside view: UIView)
    func update()
    func reset()
}

class MovementDataInteractor: MovementDataInteractorType {
    
    let desiredAccuracy = 100.0
    
    var enclosingView: UIView
    
    lazy var dataProvider: RecordProvider<Movement, MovementRecord> = {
        return RecordProvider()
    }()
    
    
    lazy var movementDataList: PluggableList<MovementCell<MovementRecord>, RecordProvider<Movement, MovementRecord>> = {
        return PluggableList(inside: self.enclosingView, dataProvider: self.dataProvider)
    }()
    
    
    required init(inside view: UIView) {
        self.enclosingView = view
        dataProvider.set(delegate: movementDataList)
        
        
        MovementTrackerManager.launch(accuracy: desiredAccuracy)
        //MovementTrackerManager.launchEmulated(accuracy: desiredAccuracy)
    }
    
    
    
    func update() {
        self.dataProvider.performFetch()
    }
    
    func reset() {
        MovementTrackerManager.reset()
    }
    
}



