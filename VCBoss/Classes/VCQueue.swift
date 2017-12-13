
//
//  VCQueue.swift
//  FBSnapshotTestCase
//
//  Created by Levi Bostian on 12/8/17.
//
import Foundation

struct QueueItem {
    var viewControllerToPresent: UIViewController
    var animated: Bool = true
    var completion: (() -> Void)? = nil
}

internal class VCQueue {
    
    private var queue: [QueueItem] = []
    
    func removeAllBefore(viewController: UIViewController) {
        for (index, queueItem) in self.queue.enumerated() {
            if queueItem.viewControllerToPresent.hashValue == viewController.hashValue {
                return
            } else {
                self.queue.remove(at: index)
            }
        }
    }
    
    func clear() {
        queue.removeAll()
    }
    
    internal var count: Int {
        get {
            return queue.count
        }
    }
    
    func isFirst(_ viewController: UIViewController) -> Bool {
        if queue.isEmpty {
            return false
        }
        
        return self.peek()?.viewControllerToPresent.hashValue == viewController.hashValue
    }
    
    func remove(_ viewController: UIViewController) -> Bool {
        for (index, queueItem) in self.queue.enumerated() {
            if queueItem.viewControllerToPresent.hashValue == viewController.hashValue {
                self.queue.remove(at: index)
                return true
            }
        }
        return false
    }
    
    func peek(for viewController: UIViewController) -> QueueItem? {
        for (index, queueItem) in self.queue.enumerated() {
            if queueItem.viewControllerToPresent.hashValue == viewController.hashValue {
                return queueItem
            }
        }
        return nil
    }        
    
    func put(_ queueItem: QueueItem, forceInsertFirst: Bool = false) {
        if forceInsertFirst {
            self.queue.insert(queueItem, at: 0)
        } else {
            self.queue.append(queueItem)
        }
    }
    
    func peek() -> QueueItem? {
        return queue.first
    }
    
    func get() -> QueueItem? {
        if self.queue.isEmpty {
            return nil
        }
        
        return self.queue.removeFirst()
    }
    
}

