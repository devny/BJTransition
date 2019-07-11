//
//  DownGestureTransition.swift
//  BJTransition
//
//  Created by 유병재 on 2019/07/11.
//

import UIKit

class DownGestureTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.white
        if let tabBarController = toViewController.tabBarController {
            containerView.insertSubview(tabBarController.tabBar, belowSubview: fromViewController.view)
        }
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        let dimView = UIView(frame: CGRect(x: 0,y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height))
        dimView.backgroundColor = UIColor.black
        dimView.alpha = 0.5
        
        toViewController.view.addSubview(dimView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dimView.alpha = 0
            fromViewController.view.frame = finalFrame
        }) { (_) in
            dimView.removeFromSuperview()
            if let tabBarController = toViewController.tabBarController {
                tabBarController.view.addSubview(tabBarController.tabBar)
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class DownTransitionInteractor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
