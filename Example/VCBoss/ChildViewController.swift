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
    func dismissViewControllerUsingPresentingViewController(sender: UIViewController)
    func dismissViewControllerUsingPresentedViewController(sender: UIViewController)
    func dismissViewControllerUsingPresentedViewControllerNotUsingVCBoss(sender: UIViewController)
    func dismissAllViewControllers(sender: UIViewController)
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
        view.setTitle("Replace with new ViewController", for: UIControl.State.normal)
        view.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        return view
    }()
    
    fileprivate let forceAddViewControllerButton: UIButton = {
        let view = UIButton()
        view.setTitle("Force add new ViewController", for: UIControl.State.normal)
        view.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        return view
    }()
    
    fileprivate let addNewViewControllerButton: UIButton = {
        let view = UIButton()
        view.setTitle("Add new ViewController", for: UIControl.State.normal)
        view.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        return view
    }()
    
    fileprivate let dismissViewControllerUsingParentButton: UIButton = {
        let view = UIButton()
        view.setTitle("Dismiss current ViewController via presenting ViewController", for: UIControl.State.normal)
        view.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        view.titleLabel?.textAlignment = NSTextAlignment.center
        view.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        return view
    }()
    
    fileprivate let dismissViewControllerUsingChildButton: UIButton = {
        let view = UIButton()
        view.setTitle("Dismiss current ViewController via presented ViewController", for: UIControl.State.normal)
        view.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        view.titleLabel?.textAlignment = NSTextAlignment.center
        view.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        return view
    }()
    
    fileprivate let dismissViewControllerUsingChildButtonNotUsingVCBoss: UIButton = {
        let view = UIButton()
        view.setTitle("Dismiss current ViewController via presented ViewController *not* using VCBoss", for: UIControl.State.normal)
        view.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        view.titleLabel?.textAlignment = NSTextAlignment.center
        view.setTitleColor(UIColor.red, for: UIControl.State.normal)
        return view
    }()
    
    fileprivate let dismissAllViewControllerButton: UIButton = {
        let view = UIButton()
        view.setTitle("Dismiss all presented ViewControllers", for: UIControl.State.normal)
        view.setTitleColor(UIColor.blue, for: UIControl.State.normal)
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
        allButtonsStackView.addArrangedSubview(dismissViewControllerUsingParentButton)
        allButtonsStackView.addArrangedSubview(dismissViewControllerUsingChildButton)
        allButtonsStackView.addArrangedSubview(dismissViewControllerUsingChildButtonNotUsingVCBoss)
        allButtonsStackView.addArrangedSubview(dismissAllViewControllerButton)
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
        addNewViewControllerButton.addTarget(self, action: #selector(ChildViewController.addNewViewControllerPressed(_:)), for: UIControl.Event.touchUpInside)
        forceAddViewControllerButton.addTarget(self, action: #selector(ChildViewController.forceAddViewControllerPressed(_:)), for: UIControl.Event.touchUpInside)
        replaceViewControllerButton.addTarget(self, action: #selector(ChildViewController.replaceViewControllerPressed(_:)), for: UIControl.Event.touchUpInside)
        dismissViewControllerUsingParentButton.addTarget(self, action: #selector(ChildViewController.dismissViewControllerUsingParentPressed(_:)), for: UIControl.Event.touchUpInside)
        dismissViewControllerUsingChildButton.addTarget(self, action: #selector(ChildViewController.dismissViewControllerUsingChildPressed(_:)), for: UIControl.Event.touchUpInside)
        dismissViewControllerUsingChildButtonNotUsingVCBoss.addTarget(self, action: #selector(ChildViewController.dismissViewControllerUsingChildPressedNotUsingVCBoss(_:)), for: UIControl.Event.touchUpInside)
        dismissAllViewControllerButton.addTarget(self, action: #selector(ChildViewController.dismissAllViewControllersPressed(_:)), for: UIControl.Event.touchUpInside)
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
    
    @objc func dismissViewControllerUsingParentPressed(_ sender: Any) {
        delegate?.dismissViewControllerUsingPresentingViewController(sender: self)
        refreshView()
    }
    
    @objc func dismissViewControllerUsingChildPressed(_ sender: Any) {
        delegate?.dismissViewControllerUsingPresentedViewController(sender: self)
        refreshView()
    }
    
    @objc func dismissViewControllerUsingChildPressedNotUsingVCBoss(_ sender: Any) {
        delegate?.dismissViewControllerUsingPresentedViewControllerNotUsingVCBoss(sender: self)
        refreshView()
    }
    
    @objc func dismissAllViewControllersPressed(_ sender: Any) {
        delegate?.dismissAllViewControllers(sender: self)
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

