//
//  PluggableList.swift
//  MovementTrackerEngine
//
//  Created by kianm on 3/4/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import UIKit

public protocol PluggableListDelegate {
    func scrollingReachedEnd()
    func image(at indexPath: IndexPath, tag: String, completion: @escaping (UIImage?) -> ())
    func cellSelected(at indexPath: IndexPath)
}

public protocol ListImageProvider {
    func provideImage(at indexPath: IndexPath, tag: String, completion: @escaping (UIImage?) -> ())
}

public class PluggableList<CustomCell:UITableViewCell, CellData: DataProvider> : NSObject, UITableViewDataSource, UITableViewDelegate, ListImageProvider where CustomCell: Reusable, CustomCell: Configurable, CustomCell: ImageRequester, CustomCell.Object == CellData.Object {
    
    private var tableView: UITableView!
    private var dataProvider: CellData? = nil
    private var delegate: PluggableListDelegate? = nil
    private var rowAnimation = UITableViewRowAnimation.automatic
    
    public required init(inside view: UIView, dataProvider: CellData, delegate: PluggableListDelegate? = nil, scrollable: Bool = true) {
        super.init()
        self.dataProvider = dataProvider
        setupTableView(view)
        tableView.isScrollEnabled = scrollable
        self.delegate = delegate
    }
    
    public func refresh() {
       // self.tableView.reloadData()
    }
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataProvider = dataProvider else {
            return 0
        }
        return dataProvider.numberOfItemsInSection(section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataProvider = dataProvider else {
            return 0
        }
        return dataProvider.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(indexPath: indexPath, imageProvider: self) as CustomCell
        guard let dataProvider = dataProvider else {
            return cell
        }
        
        cell.configure(object: dataProvider.objectAtIndexPath(indexPath), atIndexPath: indexPath)
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let dataProvider = dataProvider else {
            return
        }
        if indexPath.section + 1 ==  dataProvider.numberOfSections(), indexPath.row + 1 == dataProvider.numberOfItemsInSection(indexPath.section) {
            delegate?.scrollingReachedEnd()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.cellSelected(at: indexPath)
    }
    
    
}

// MARK: - Cell addition/removal

extension PluggableList: DataProviderDelegate {
    
    public func dataProviderDidUpdate(_ updates: [DataProviderUpdate<PlainRecord>]?) {
        
        guard let updates = updates else {
            return
        }

        tableView.beginUpdates()
        
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .fade)
//            case .update(let indexPath, let object):
//                guard let cell = tableView.cellForRow(at: indexPath) as? CustomCell else { break }
//                configure(cell: cell, indexPath: indexPath)
            case .move(let indexPath, let newIndexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
            default:
                break
                //TODO update not implemented
            }
        }
        
        tableView.endUpdates()
    }
    
}
// MARK: - Cell configuration

extension PluggableList {
    
    func configure(cell: CustomCell, indexPath: IndexPath) {
        guard let dataProvider = dataProvider else {
            return
        }
        cell.configure(object: dataProvider.objectAtIndexPath(indexPath), atIndexPath: indexPath)
    }
}

// MARK: - TableView Setup

extension PluggableList {
    
    func setupTableView(_ view: UIView) {
        tableView = UITableView()
        view.addSubview(tableView)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12.0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2.0).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.registerReusableCell(CustomCell.self)
    }
}

// MARK: - Controls

extension PluggableList {
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - ListImageProvider

extension PluggableList {
    
    public func provideImage(at indexPath: IndexPath, tag: String, completion: @escaping (UIImage?) -> ()) {
        dataProvider?.image(at: indexPath, tag: tag) { image in
            completion(image)
        }
        
    }
}
