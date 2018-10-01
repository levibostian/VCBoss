//
//  ParentViewController.swift
//  VCBoss_Example
//
//  Created by Levi Bostian on 12/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ParentViewController: UIViewController {
    
    fileprivate var didSetupContaints = false
    
    fileprivate let presentNewViewControllerButton: UIButton = {
        let view = UIButton()
        view.setTitle("Present new ViewController", for: UIControl.State.normal)
        view.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        return view
    }()
    
    fileprivate let presentNewViewControllerNotUsingVCBossButton: UIButton = {
        let view = UIButton()
        view.setTitle("Present new ViewController *not* using VCBoss", for: UIControl.State.normal)
        view.setTitleColor(UIColor.red, for: UIControl.State.normal)
        view.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        view.titleLabel?.textAlignment = NSTextAlignment.center
        return view
    }()
    
    fileprivate let viewsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsStackView.addArrangedSubview(presentNewViewControllerButton)
        viewsStackView.addArrangedSubview(presentNewViewControllerNotUsingVCBossButton)
        
        self.view.addSubview(viewsStackView)
        
        self.setupViews()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    fileprivate func setupViews() {
        presentNewViewControllerButton.addTarget(self, action: #selector(ParentViewController.presentNewViewControllerPressed(_:)), for: UIControl.Event.touchUpInside)
        presentNewViewControllerNotUsingVCBossButton.addTarget(self, action: #selector(ParentViewController.presentNewViewControllerNotUsingVCBossPressed(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func presentNewViewControllerPressed(_ sender: Any) {
        let newViewController = ChildViewController()
        newViewController.delegate = self
        
        self.vcboss.present(newViewController, animated: true, completion: nil)
    }
    
    @objc func presentNewViewControllerNotUsingVCBossPressed(_ sender: Any) {
        let newViewController = ChildViewController()
        newViewController.delegate = self
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    override func updateViewConstraints() {
        if !didSetupContaints {
            viewsStackView.snp.makeConstraints({ (make) in
                make.size.equalToSuperview()
                make.center.equalToSuperview()
            })
            
            didSetupContaints = true
        }
        
        super.updateViewConstraints()
    }
    
}

extension ParentViewController: ChildViewControllerDelegate {
    
    func dismissViewControllerUsingPresentingViewController(sender: UIViewController) {
        self.vcboss.dismiss(sender, animated: true, completion: nil)
    }
    
    func dismissViewControllerUsingPresentedViewController(sender: UIViewController) {
        sender.vcboss.dismiss(animated: true, completion: nil)
    }
    
    func dismissViewControllerUsingPresentedViewControllerNotUsingVCBoss(sender: UIViewController) {
        sender.dismiss(animated: true, completion: nil)
    }
    
    func dismissAllViewControllers(sender: UIViewController) {
        self.vcboss.dismissAll(animated: true, completion: nil)
    }
    
    func getNumberViewControllersInStack() -> Int {
        return self.vcboss.numViewControllersPresenting
    }    
    
    func replaceWithNewViewController(sender: UIViewController) {
        let newViewController = ChildViewController()
        newViewController.delegate = self
        
        self.vcboss.replace(with: newViewController, animated: true, completion: nil)
    }
    
    func forceAddViewController(sender: UIViewController) {
        let newViewController = ChildViewController()
        newViewController.delegate = self
        
        self.vcboss.present(newViewController, animated: true, completion: nil, force: true)
    }
    
    func addNewViewController(sender: UIViewController) {
        let newViewController = ChildViewController()
        newViewController.delegate = self
        
        self.vcboss.present(newViewController, animated: true, completion: nil)
    }
    
}
