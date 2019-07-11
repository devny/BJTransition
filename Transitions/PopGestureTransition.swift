//
//  PopGestureTransition.swift
//  BJTransition
//
//  Created by 유병재 on 2019/07/11.
//

import UIKit

class PopGestureTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var toViewController: UIViewController?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { return 0.3 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        toViewController.view.frame = CGRect(x: -100, y: toViewController.view.frame.origin.y, width: fromViewController.view.frame.size.width, height: fromViewController.view.frame.size.height)
        
        let dimmingView = UIView(frame: CGRect(x: 0,y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height))
        dimmingView.backgroundColor = UIColor.black
        dimmingView.alpha = 0.5
        
        toViewController.view.addSubview(dimmingView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            dimmingView.alpha = 0
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            fromViewController.view.frame = CGRect(x: toViewController.view.frame.size.width, y: fromViewController.view.frame.origin.y, width: fromViewController.view.frame.size.width, height: fromViewController.view.frame.size.height)
        }, completion: { _ in
            dimmingView.removeFromSuperview()
            if let tabBarController = toViewController.tabBarController {
                tabBarController.view.addSubview(tabBarController.tabBar)
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
