
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
    /**
     If you try to dismiss a UIViewController that was not presented modally, this error is thrown. This UIViewController does not have an instance of `presentingViewController`.
     */
    case dismissViewControllerNotPresentedModally
    
    public var errorDescription: String? {
        switch self {
        case .dismissViewControllerNeverPresented:
            return NSLocalizedString("ViewController was never presented. Cannot dismiss it.", comment: "")
        case .dismissViewControllerNotPresentedModally:
            return NSLocalizedString("ViewController was not presented modally. Cannot dismiss it.", comment: "")
        }
    }
}

/**
 Class used by a UIViewController to manage presenting and dismissing of UIViewControllers in a safe way. iOS throws errors if you try to call `self.present()` inside of a UIViewController when another UIViewController is already being shown. Replace all of your existing `self.present()` calls with using VCBoss and be safe knowing only 1 ViewController will be shown at a time.
 
 Note: This class *does not* know about any UIViewControllers that you have already shown in it with `self.present()`. Make sure to place *all* existing `self.present()` calls with using VCBoss to assert you will not have any issues.
 */
public class VCBoss {
    
    /**
     The UIViewController doing the presenting of other UIViewControllers modally *or* the UIViewController presented modally...or both.
     
     This is the UIViewController that was used in the `instance(for:)` constructor.
    */
    public weak var viewController: UIViewController?
    
    private var queueViewControllersPresenting: VCQueue = VCQueue()
    
    private init() {
    }
    
    /**
     Use to get instance of VCBoss for UIViewController. Internally, this class will get you a singleton of VCBoss for your UIViewController instance.
     
     *Note: UIViewController used here is saved `weak`. Be sure to hold a reference to it until you no longer need it.*
    */
    public class func instance(for: UIViewController) -> VCBoss {
        return VCBossInstanceManager.shared.getBoss(`for`)
    }
    
    internal init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    /**
     If you are interested to see how many UIViewControllers are in the stack of UIViewControllers to present modally.
     */
    public var numViewControllersPresenting: Int {
        get {
            return queueViewControllersPresenting.count
        }
    }
    
    fileprivate func isViewControllerAlreadyPresented(_ checkIfPresented: UIViewController) -> Bool {
        return self.queueViewControllersPresenting.isFirst(checkIfPresented) && self.viewController?.presentedViewController?.hashValue == checkIfPresented.hashValue
    }
    
    /**
     Present this UIViewController now if no other UIViewController is presented, or show it in the future when it's turn is next.
     
     @param force: Bool This param is used to say this UIViewController needs to be presented right now. Dismiss the UIViewController currently shown (if there is one), show this new UIViewController, then present the one I replaced again. Default: false
     */
    public func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?, force: Bool = false) {
        if viewControllerToPresent.hashValue == self.viewController?.hashValue {
            fatalError("You cannot present yourself. You must provide a new UIViewController to present.")
        }
        syncQueueWithPresentingViewController()
        if isViewControllerAlreadyPresented(viewControllerToPresent) {
            return // We are already presenting that UIViewController. Do not attempt to present it again.
        }
        
        if force {
            if let viewControllerCurrentlyShown = self.viewController?.presentedViewController {
                viewControllerCurrentlyShown.dismiss(animated: animated, completion: {
                    self.viewController?.present(viewControllerToPresent, animated: animated, completion: completion)
                })
            } else {
                self.viewController?.present(viewControllerToPresent, animated: animated, completion: completion)
            }
        } else {
            if self.viewController?.presentedViewController == nil {
                self.viewController?.present(viewControllerToPresent, animated: animated, completion: completion)
            }
        }
        
        self.queueViewControllersPresenting.put(QueueItem(viewControllerToPresent: viewControllerToPresent, animated: animated, completion: completion), forceInsertFirst: force)
    }
    
    /**
     If another UIViewController is already being presented, ignore showing this one. Else, present it.
     */
    public func presentOnlyIfNothingAlreadyPresented(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if self.viewController?.presentedViewController == nil {
            self.present(viewControllerToPresent, animated: animated, completion: completion)
        }
    }
    
    /**
     Internal use. Used usually when we dismiss a viewcontroller and it's time to show the next one in line.
     */
    fileprivate func presentNextInQueue() {
        if let nextInLine: QueueItem = self.queueViewControllersPresenting.peek() {
            self.viewController?.present(nextInLine.viewControllerToPresent, animated: nextInLine.animated, completion: nextInLine.completion)
        }
    }
    
    /**
     Take the currently shown UIViewController, dismiss it, and force show this new one immediately after.
     */
    public func replace(with viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if viewController.hashValue == self.viewController?.hashValue {
            fatalError("You cannot replace with yourself. You must give a new UIViewController to replace.")
        }
        syncQueueWithPresentingViewController()
        if isViewControllerAlreadyPresented(viewController) {
            return // We are already presenting that UIViewController. Do not attempt to present it again.
        }
        
        if let currentlyShownViewController = self.queueViewControllersPresenting.peek() {
            try! self.dismissWithoutPresentingNextInQueue(currentlyShownViewController.viewControllerToPresent, animated: animated, dismissCompletion: {
                self.present(viewController, animated: animated, completion: completion, force: true)
            })
        } else {
            self.present(viewController, animated: animated, completion: completion, force: true)
        }
    }
    
    fileprivate func dismissWithoutPresentingNextInQueue(_ viewController: UIViewController, animated: Bool, dismissCompletion: (() -> Void)? = nil) throws {
        guard let queueItem = self.queueViewControllersPresenting.peek(for: viewController) else {
            throw VCBossError.dismissViewControllerNeverPresented
        }
        if self.queueViewControllersPresenting.isFirst(queueItem.viewControllerToPresent) {
            queueItem.viewControllerToPresent.dismiss(animated: animated) {
                self.queueViewControllersPresenting.remove(queueItem.viewControllerToPresent)
                dismissCompletion?()
                queueItem.completion?()
            }
        } else {
            // Do not actually dimiss the ViewController if it's not being shown. Just remove from stack.
            self.queueViewControllersPresenting.remove(queueItem.viewControllerToPresent)
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
        if viewController.hashValue == self.viewController?.hashValue {
            fatalError("You cannot dismiss yourself using VCBoss. You need to dismiss a UIViewController that your parent UIViewController presented.")
        }
        syncQueueWithPresentingViewController()
        
        try self.dismissWithoutPresentingNextInQueue(viewController, animated: animated, dismissCompletion: {
            self.presentNextInQueue()
            completion?()
        })
    }
    
    /**
     To stay as backwards compatible as possible with existing UIKIt code, I need to try my best to keep the queue of UIViewControllers as best I can in sync with the presenting UIViewController and what it has already `self.present()`ed and `presentedViewController.disiss()`ed without using VCBoss.
     
     What would happen if there is a code base that forgets to use VCBoss in 1+ places? The queue will become very out of sync. So, I do my best to catch up VCBoss for them before performing another task.
     
     With this sync task, I am able to do a pretty decent job at catching up except in the case of calling `presentedViewController.dismiss()` in that VCBoss is not able to display the next UIViewController anymore.
     
     Bummer. Let's hope people use SwiftLint.
     */
    fileprivate func syncQueueWithPresentingViewController() {
        /**
         To stay as backwards compatible as possible with existing UIKIt code, I check the UIViewController's UIViewController currently being presented (if ther is one) and add it to the VCQueue if it is not already.
         */
        func addPresentedViewControllerToVCBossIfNotAlready() {
            if let presentedViewController = self.viewController?.presentedViewController {
                if !self.queueViewControllersPresenting.isFirst(presentedViewController) {
                    self.queueViewControllersPresenting.put(QueueItem(viewControllerToPresent: presentedViewController, animated: false, completion: nil), forceInsertFirst: true)
                }
            }
        }
        /**
         To stay as backwards compatible as possible with existing UIKIt code, I will check to see what the currently presented UIViewController is and compare that with the queue of UIViewControllers to assert that the UIViewController shown at the first position is the one being currently presented.
         */
        func removeAlreadyDismissedViewControllersFromQueue() {
            if let presentedViewController = self.viewController?.presentedViewController {
                self.queueViewControllersPresenting.removeAllBefore(viewController: presentedViewController)
            }
        }
        
        addPresentedViewControllerToVCBossIfNotAlready()
        removeAlreadyDismissedViewControllersFromQueue()
    }
    
    /**
     Dismiss the currently presented UIViewController and do not present anymore. Clear the stack to start over again.
    */
    public func dismissAll(animated: Bool, completion: (() -> Void)?) throws {
        syncQueueWithPresentingViewController()
        
        if let currentlyShownViewController = self.queueViewControllersPresenting.peek() {
            try self.dismissWithoutPresentingNextInQueue(currentlyShownViewController.viewControllerToPresent, animated: animated, dismissCompletion: {
                self.queueViewControllersPresenting.clear()
                completion?()
            })
        }
    }
    
    /**
     Dismiss this UIViewController that was presented modally. This method internally calls `.dismiss()` on the presentingViewController's VCBoss instance.
     
     This method exists to be backwards compatible with UIKit.
     */
    public func dismiss(animated: Bool, completion: (() -> Void)?) throws {
        guard let parentViewController = self.viewController, let presentingViewController = self.viewController?.presentingViewController else {
            throw VCBossError.dismissViewControllerNotPresentedModally
        }
        
        let presentingViewControllerVCBoss = VCBossInstanceManager.shared.getBoss(presentingViewController)
        try presentingViewControllerVCBoss.dismiss(parentViewController, animated: animated, completion: completion)
    }
    
}

