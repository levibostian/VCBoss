
//
//  VCBossInstanceManager.swift
//  FBSnapshotTestCase
//
//  Created by Levi Bostian on 12/8/17.
//
import Foundation

/**
 Each ViewController needs it's own instance of VCBoss. So, this class manages all of the instances to get the existing instance of VCBoss or to create a new one.
 */
internal class VCBossInstanceManager {
    
    internal static let shared = VCBossInstanceManager()
    
    private var bossInstances: [Int: VCBoss] = [:]
    
    private init() {
    }
    
    func getBoss(_ viewController: UIViewController) -> VCBoss {
        let identifier = viewController.hashValue
        
        if bossInstances[identifier] == nil {
            bossInstances[identifier] = VCBoss(viewController: viewController)
        }
        
        return bossInstances[identifier]!
    }
    
}

