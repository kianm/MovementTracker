//
//  MovementCell.swift
//  MovementTracker
//
//  Created by kianm on 3/4/18.
//  Copyright © 2018 KIAN. All rights reserved.
//
import MovementTrackerEngine

class MovementCell<V>: UITableViewCell, Reusable, Configurable, ImageRequester {
    
    var listImageProvider: ListImageProvider?
    
    var timeLabel: UILabel!
    var modLabel: UILabel!
    var latLabel: UILabel!
    var lonLabel: UILabel!
    var modLable: UILabel!
    
    func configure(object: MovementRecord, atIndexPath: IndexPath?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: object.timeStamp)
        timeLabel.text = dateString
        modLabel.text = PackedActivityType.stringValue(object.mod)
        latLabel.text = String(format: "%.3f,", object.lat)
        lonLabel.text = String(format: "%.3f", object.lon)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup(inside: self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(inside  v: UIView) {
        
        let topView = UIView()
        v.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 0.0).isActive = true
        topView.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: 0.0).isActive = true
        topView.topAnchor.constraint(equalTo: v.topAnchor, constant: 0.0).isActive = true
        
        let bottomView = UIView()
        v.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 0.0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: 0.0).isActive = true
        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: 0.0).isActive = true
        
        timeLabel = UILabel()
        topView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2.0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2.0).isActive = true
        timeLabel.font = UIFont.boldSystemFont(ofSize: timeLabel.font.pointSize)
        
        
        
        latLabel = UILabel()
        bottomView.addSubview(latLabel)
        latLabel.translatesAutoresizingMaskIntoConstraints = false
        latLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 2.0).isActive = true
        latLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2.0).isActive = true
        latLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -2.0).isActive = true
        
        lonLabel = UILabel()
        bottomView.addSubview(lonLabel)
        lonLabel.translatesAutoresizingMaskIntoConstraints = false
        lonLabel.leadingAnchor.constraint(equalTo: latLabel.trailingAnchor, constant: 4.0).isActive = true
        lonLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2.0).isActive = true
        lonLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -2.0).isActive = true
        
        modLabel = UILabel()
        bottomView.addSubview(modLabel)
        modLabel.translatesAutoresizingMaskIntoConstraints = false
        modLabel.leadingAnchor.constraint(equalTo: lonLabel.trailingAnchor, constant: 8.0).isActive = true
        modLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2.0).isActive = true
        modLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -2.0).isActive = true        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

