
//
//  VCBoss.swift
//  FBSnapshotTestCase
//
//  Created by Levi Bostian on 12/8/17.
//
import Foundation

/**
 Errors that VCBoss can throw.
 */
public enum VCBossError: Error, LocalizedError {
    /**
     If you try to dismiss a UIViewController that was never presented using VCBoss. You either forgot to present it, or you used `self.present()` instead of `self.vcboss.present()` to present the UIViewController.
    */
    case dismissViewControllerNeverPresented
    
    public var errorDescription: String? {
        switch self {
        case .dismissViewControllerNeverPresented:
            return NSLocalizedString("ViewController was never presented. Cannot dismiss it.", comment: "")
        }
    }
}

/**
 Class used by a UIViewController to manage presenting and dismissing of UIViewControllers in a safe way. iOS throws errors if you try to call `self.present()` inside of a UIViewController when another UIViewController is already being shown. Replace all of your existing `self.present()` calls with using VCBoss and be safe knowing only 1 ViewController will be shown at a time.
 
 Note: This class *does not* know about any UIViewControllers that you have already shown in it with `self.present()`. Make sure to place *all* existing `self.present()` calls with using VCBoss to assert you will not have any issues.
 */
public class VCBoss {
    
    public weak var parentViewController: UIViewController? // The UIViewController doing the presenting. You can think of this as the "parent" UIViewController and all the UIViewControllers presented as the "children".
    
    private var queue: VCQueue = VCQueue()
    
    private init() {
    }
    
    /**
     Use to get instance of VCBoss for UIViewController doing all of the presenting of UIViewControllers. You can think of this as the "parenet" UIViewController showing "children" UIViewController's modally.
    */
    public class func instance(for: UIViewController) -> VCBoss {
        return VCBossInstanceManager.shared.getBoss(`for`)
    }
    
    internal init(viewController: UIViewController) {
        self.parentViewController = viewController
    }
    
    /**
     If you are interested to see how many UIViewControllers are in the stack of UIViewControllers to show modally.
    */
    public var numViewControllersInStack: Int {
        get {
            return queue.count
        }
    }
    
    /**
     Present this UIViewController now if no other UIViewController is presented, or show it in the future when it's turn is next.
     
     @param force: Bool This param is used to say this UIViewController needs to be presented right now. Dismiss the UIViewController currently shown (if there is one), show this new UIViewController, then present the one I replaced again. Default: false
     */
    public func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?, force: Bool = false) {
        if viewControllerToPresent.hashValue == self.parentViewController?.hashValue {
            fatalError("You cannot present yourself. You must provide a new UIViewController to present.")
        }
        if self.queue.contains(viewControllerToPresent) {
            return // We are already presenting that UIViewController. Do not attempt to present it again.
        }
        
        if force {
            if let viewControllerCurrentlyShown = self.queue.peek() {
                viewControllerCurrentlyShown.viewControllerToPresent.dismiss(animated: false, completion: {
                    self.parentViewController?.present(viewControllerToPresent, animated: animated, completion: completion)
                })
            } else {
                self.parentViewController?.present(viewControllerToPresent, animated: animated, completion: completion)
            }
        } else {
            if self.queue.isEmpty() {
                self.parentViewController?.present(viewControllerToPresent, animated: animated, completion: completion)
            }
        }
        
        self.queue.put(QueueItem(viewControllerToPresent: viewControllerToPresent, animated: animated, completion: completion), forceInsertFirst: force)
    }
    
    /**
     If another UIViewController is already being shown, ignore showing this one. Else, present it.
     */
    public func presentOnlyIfNothingAlreadyShown(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if viewControllerToPresent.hashValue == self.parentViewController?.hashValue {
            fatalError("You cannot present yourself. You must provide a new UIViewController to present.")
        }
        if self.queue.contains(viewControllerToPresent) {
            return // We are already presenting that UIViewController. Do not attempt to present it again.
        }
        
        if self.queue.isEmpty() {
            self.present(viewControllerToPresent, animated: animated, completion: completion)
        }
    }
    
    /**
     Internal use. Used usually when we dismiss a viewcontroller and it's time to show the next one in line.
     */
    fileprivate func presentNextInQueue() {
        if let nextInLine: QueueItem = self.queue.peek() {
            self.parentViewController?.present(nextInLine.viewControllerToPresent, animated: nextInLine.animated, completion: nextInLine.completion)
        }
    }
    
    /**
     Take the currently shown ViewController, dismiss it, and force show this one immediately after.
     */
    public func replace(with viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if viewController.hashValue == self.parentViewController?.hashValue {
            fatalError("You cannot replace with yourself. You must give a new UIViewController to replace.")
        }
        if self.queue.contains(viewController) {
            return // We are already presenting that UIViewController. Do not attempt to present it again.
        }
        
        if let currentlyShownViewController = self.queue.peek() {
            try! self.dismissWithoutPresentingNextInQueue(currentlyShownViewController.viewControllerToPresent, animated: animated, dismissCompletion: {
                self.present(viewController, animated: animated, completion: completion, force: true)
            })
        } else {
            self.present(viewController, animated: animated, completion: completion, force: true)
        }
    }
    
    fileprivate func dismissWithoutPresentingNextInQueue(_ viewController: UIViewController, animated: Bool, dismissCompletion: (() -> Void)? = nil) throws {
        guard let queueItem = self.queue.peek(for: viewController) else {
            throw VCBossError.dismissViewControllerNeverPresented
        }
        if self.queue.isFirst(queueItem.viewControllerToPresent) {
            queueItem.viewControllerToPresent.dismiss(animated: animated) {
                self.queue.remove(queueItem.viewControllerToPresent)
                dismissCompletion?()
                queueItem.completion?()
            }
        } else {
            // Do not actually dimiss the ViewController if it's not being shown. Just remove from stack.
            self.queue.remove(queueItem.viewControllerToPresent)
            dismissCompletion?()
            queueItem.completion?()
        }
    }    
    
    /**
     Dismiss this UIViewController given. Then, present the next one in line if there is one.
     
     `dismissCompletion` and the completion handler given when this ViewController to dismiss was presented will both be called.
     
     If the viewController was never actually presented, an error will be thrown.
     */
    public func dismiss(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) throws {
        if viewController.hashValue == self.parentViewController?.hashValue {
            fatalError("You cannot dismiss yourself using VCBoss. You need to dismiss a UIViewController that your parent UIViewController presented.")
        }
        
        try self.dismissWithoutPresentingNextInQueue(viewController, animated: animated, dismissCompletion: {
            self.presentNextInQueue()
            completion?()
        })
    }
    
}

