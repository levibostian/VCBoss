//
//  UIViewController+VCBoss.swift
//  VCBoss
//
//  Created by Levi Bostian on 12/12/17.
//

import Foundation
import UIKit

/**
 Set of UIViewController extensions to interact with VCBoss easily to make working with VCBoss easier.
 */
public extension UIViewController {
    
    /**
     Get an instance of VCBoss for the current UIViewController.
    */
    public var vcboss: VCBoss {
        return VCBossInstanceManager.shared.getBoss(self)
    }
    
}
