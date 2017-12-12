//
//  ViewController.swift
//  VCBoss
//
//  Created by Levi Bostian on 12/12/2017.
//  Copyright (c) 2017 Levi Bostian. All rights reserved.
//

import UIKit
import VCBoss
import SnapKit

protocol ChildViewControllerDelegate: AnyObject {
    func replaceWithNewViewController(sender: UIViewController)
    func forceAddViewController(sender: UIViewController)
    func addNewViewController(sender: UIViewController)
    func dismissViewController(sender: UIViewController)
    func getNumberViewControllersInStack() -> Int
}

class ChildViewController: UIViewController {
    
    fileprivate var didSetupContaints = false
    
    weak var delegate: ChildViewControllerDelegate? = nil 
    
    fileprivate let numViewControllersInStack: UILabel = {
        let view = UILabel()
        return view
    }()
    
    fileprivate let replaceViewControllerButton: UIButton = {
        let view = UIButton()
        view.setTitle("Replace with new ViewController", for: UIControlState.normal)
        view.setTitleColor(UIColor.blue, for: UIControlState.normal)
        return view
    }()
    
    fileprivate let forceAddViewControllerButton: UIButton = {
        let view = UIButton()
        view.setTitle("Force add new ViewController", for: UIControlState.normal)
        view.setTitleColor(UIColor.blue, for: UIControlState.normal)
        return view
    }()
    
    fileprivate let addNewViewControllerButton: UIButton = {
        let view = UIButton()
        view.setTitle("Add new ViewController", for: UIControlState.normal)
        view.setTitleColor(UIColor.blue, for: UIControlState.normal)
        return view
    }()
    
    fileprivate let dismissViewControllerButton: UIButton = {
        let view = UIButton()
        view.setTitle("Dismiss current ViewController", for: UIControlState.normal)
        view.setTitleColor(UIColor.blue, for: UIControlState.normal)
        return view
    }()
    
    fileprivate let allButtonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        allButtonsStackView.addArrangedSubview(numViewControllersInStack)
        allButtonsStackView.addArrangedSubview(addNewViewControllerButton)
        allButtonsStackView.addArrangedSubview(forceAddViewControllerButton)
        allButtonsStackView.addArrangedSubview(replaceViewControllerButton)
        allButtonsStackView.addArrangedSubview(dismissViewControllerButton)
        self.view.addSubview(allButtonsStackView)
        
        self.setupViews()
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshView()
    }
    
    fileprivate func refreshView() {
        self.numViewControllersInStack.text = "Number of ViewControllers in stack: \(delegate!.getNumberViewControllersInStack())"
    }
    
    fileprivate func setupViews() {
        addNewViewControllerButton.addTarget(self, action: #selector(ChildViewController.addNewViewControllerPressed(_:)), for: UIControlEvents.touchUpInside)
        forceAddViewControllerButton.addTarget(self, action: #selector(ChildViewController.forceAddViewControllerPressed(_:)), for: UIControlEvents.touchUpInside)
        replaceViewControllerButton.addTarget(self, action: #selector(ChildViewController.replaceViewControllerPressed(_:)), for: UIControlEvents.touchUpInside)
        dismissViewControllerButton.addTarget(self, action: #selector(ChildViewController.dismissViewControllerPressed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func forceAddViewControllerPressed(_ sender: Any) {
        delegate?.forceAddViewController(sender: self)
        refreshView()
    }
    
    @objc func addNewViewControllerPressed(_ sender: Any) {
        delegate?.addNewViewController(sender: self)
        refreshView()
    }
    
    @objc func replaceViewControllerPressed(_ sender: Any) {
        delegate?.replaceWithNewViewController(sender: self)
        refreshView()
    }
    
    @objc func dismissViewControllerPressed(_ sender: Any) {
        delegate?.dismissViewController(sender: self)
        refreshView()
    }

    override func updateViewConstraints() {
        if !didSetupContaints {
            allButtonsStackView.snp.makeConstraints({ (make) in
                make.size.equalToSuperview()
                make.center.equalToSuperview()
            })
            
            didSetupContaints = true
        }
        
        super.updateViewConstraints()
    }

}

