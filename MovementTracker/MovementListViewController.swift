//
//  MovementListViewController.swift
//  MovementTracker
//
//  Created by kianm on 3/3/18.
//  Copyright © 2018 KIAN. All rights reserved.
//

import UIKit

class MovementListViewController: UIViewController {

    var topView, bottomView: UIView!
    
    var interactor: MovementDataInteractorType!
    var resetBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movement List"
        self.view.backgroundColor = .white
        self.setupViews()
        self.interactor = MovementDataInteractor(inside: self.bottomView)
        self.interactor.update()

    }

    @objc func resetBtnAction(sender: UIButton!) {
//        self.interactor.reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

// MARK: View Creation

extension MovementListViewController {
    
    func setupViews() {
        topView = UIView()
        self.view.addSubview(topView)
        
        let margins = self.view.layoutMarginsGuide
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
        topView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        
        resetBtn = UIButton()
        topView.addSubview(resetBtn)
        resetBtn.translatesAutoresizingMaskIntoConstraints = false
        resetBtn.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 5.0).isActive = true
        resetBtn.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2.0).isActive = true
        resetBtn.setTitle("", for: .normal)
        resetBtn.setTitleColor(.black, for: .normal)
        resetBtn.addTarget(self, action: #selector(resetBtnAction), for: .touchUpInside)

        bottomView = UIView()
        self.view.addSubview(bottomView)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0.0).isActive = true
        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
    }

}
