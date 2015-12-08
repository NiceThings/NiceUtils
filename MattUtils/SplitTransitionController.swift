//
//  SplitTransitionController.swift
//  MattUtils
//
//  Created by Matthew Buckley on 12/7/15.
//  Copyright © 2015 Matt Buckley. All rights reserved.
//

import Foundation
import UIKit

enum TransitionType {
    case Push
    case Pop
}

class SplitTransitionController: NSObject {
    /**
     * The duration (in seconds) of the transition.
     */
    var transitionDuration: NSTimeInterval = 1.0

    /**
     * The delay before/afte the transition (in seconds).
     */
    var transitionDelay: NSTimeInterval = 0.0

    /**
     * Stores animation type (e.g. push/pop). Defaults to "push".
     */
    var transitionType: TransitionType = .Push

    var splitLocation: CGPoint = CGPointZero
    
    /** 
     * Screen capture extending from split location
     * to top of screen
     */
    lazy var topSplitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.screenCapture
        imageView.contentMode = .Top
        imageView.clipsToBounds = true
        return imageView
    }()

    /**
     * Screen capture extending from split location
     * to bottom of screen
     */
    lazy var bottomSplitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.screenCapture
        imageView.contentMode = .Bottom
        imageView.clipsToBounds = true
        return imageView
    }()

    var screenCapture: UIImage?

    convenience init(transitionDuration: NSTimeInterval, transitionType: TransitionType) {
        self.init()
        self.transitionDuration = transitionDuration
        self.transitionType = transitionType
    }

}

extension SplitTransitionController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        // Take screenshot and store resulting UIImage
        screenCapture = UIWindow.screenShot()

        // ???
        let container = containerView(transitionContext) ?? UIView()

        // Set bounds for top and bottom screen captures
        let width = container.frame.size.width ?? 0.0
        let height = container.frame.size.height ?? 0.0

        topSplitImageView.frame = CGRectMake(0.0, 0.0, width, height - splitLocation.y)
        bottomSplitImageView.frame = CGRectMake(0.0, splitLocation.y, width, height - splitLocation.y)

        // Set source and destination view controllers
        let fromVC = fromViewController(transitionContext) ?? UIViewController()
        let toVC = toViewController(transitionContext) ?? UIViewController()

        // Set completion handler for transition
        let completion = {transitionContext.completeTransition(!transitionContext.transitionWasCancelled())}
        
        switch(transitionType) {
            case .Push:
                push(toVC, fromViewController: fromVC, containerView: container, completion: completion)
                break
            case .Pop:
                pop(toVC, fromViewController: fromVC, containerView: container, completion: completion)
                break
        }
    }

}

private extension SplitTransitionController {

    // MARK: private interface

    // Returns the view controller being navigated away from
    func fromViewController(transitionContext: UIViewControllerContextTransitioning?) -> UIViewController? {
        return transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
    }

    // Returns the view controller being navigated to
    func toViewController(transitionContext: UIViewControllerContextTransitioning?) -> UIViewController? {
        return transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)
    }

    // Returns the container view for the transition context
    func containerView(transitionContext: UIViewControllerContextTransitioning?) -> UIView? {
        return transitionContext?.containerView()
    }

    // Push Transition
    func push(toViewController: UIViewController,
        fromViewController: UIViewController,
        containerView: UIView,
        completion: (() -> ())?) {
            containerView.addSubview(toViewController.view)
            containerView.addSubview(topSplitImageView)
            containerView.addSubview(bottomSplitImageView)

            // fromVC is initially hidden
            fromViewController.view.alpha = 0.0
            toViewController.view.alpha = 1.0
            toViewController.view.transform = CGAffineTransformMakeTranslation(0.0, topSplitImageView.frame.size.height)

            UIView.animateWithDuration(transitionDuration, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .LayoutSubviews, animations: { [weak self] () -> Void in
                if let controller = self {
                    controller.topSplitImageView.transform = CGAffineTransformMakeTranslation(0.0, -controller.topSplitImageView.bounds.size.height)
                    controller.bottomSplitImageView.transform = CGAffineTransformMakeTranslation(0.0, controller.bottomSplitImageView.bounds.size.height)
                    toViewController.view.transform = CGAffineTransformIdentity
                }
                }) { [weak self] (Bool) -> Void in
                    // When the transition is fished, top and bottom
                    // split views are removed from the view hierarchy
                    if let controller = self {
                        controller.topSplitImageView.removeFromSuperview()
                        controller.bottomSplitImageView.removeFromSuperview()
                    }

                    // If a completion was passed as a parameter,
                    // execute it
                    if let completion = completion {
                        completion()
                    }
            }
    }

    // Pop Transition
    func pop(toViewController: UIViewController,
        fromViewController: UIViewController,
        containerView: UIView,
        completion: (() -> ())?) {
            containerView.addSubview(toViewController.view)
            containerView.addSubview(topSplitImageView)
            containerView.addSubview(bottomSplitImageView)

            // toVC is initially hidden
            toViewController.view.alpha = 0.0
            toViewController.view.transform = CGAffineTransformMakeTranslation(0.0, topSplitImageView.frame.size.height)

            UIView.animateWithDuration(transitionDuration, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .LayoutSubviews, animations: { [weak self] () -> Void in
                if let controller = self {

                    // Restore the top and bottom screen
                    // captures to their original positions
                    controller.topSplitImageView.transform = CGAffineTransformIdentity
                    controller.bottomSplitImageView.transform = CGAffineTransformIdentity

                    // Restore fromVC's view to its original position
                    fromViewController.view.transform = CGAffineTransformMakeTranslation(0.0, controller.topSplitImageView.bounds.size.height)
                }
                }) { [weak self] (Bool) -> Void in
                    // When the transition is fished, top and bottom
                    // split views are removed from the view hierarchy
                    if let controller = self {
                        controller.topSplitImageView.removeFromSuperview()
                        controller.bottomSplitImageView.removeFromSuperview()
                    }

                    // Make toVC's view visible again
                    toViewController.view.alpha = 1.0

                    // If a completion was passed as a parameter,
                    // execute it
                    if let completion = completion {
                        completion()
                    }
            }
    }

}