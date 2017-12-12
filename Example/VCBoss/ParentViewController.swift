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
        view.setTitle("Present new ViewController", for: UIControlState.normal)
        view.setTitleColor(UIColor.blue, for: UIControlState.normal)
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
        
        self.view.addSubview(viewsStackView)
        
        self.setupViews()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    fileprivate func setupViews() {
        presentNewViewControllerButton.addTarget(self, action: #selector(ParentViewController.presentNewViewControllerPressed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func presentNewViewControllerPressed(_ sender: Any) {
        let newViewController = ChildViewController()
        newViewController.delegate = self
        
        self.vcboss.present(newViewController, animated: true, completion: nil)
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
    
    func dismissViewController(sender: UIViewController) {
        try! self.vcboss.dismiss(sender, animated: true, completion: nil)
    }
    
    func getNumberViewControllersInStack() -> Int {
        return self.vcboss.numViewControllersInStack
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
