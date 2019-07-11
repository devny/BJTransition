//
//  BJTransitionController.swift
//  BJTransition
//
//  Created by 유병재 on 2019/07/11.
//

import UIKit

enum PopDirection {
    case down
    case stop
    case right
}

class BJTransitionController: UINavigationController, UINavigationControllerDelegate {
    
    private lazy var popTransition = PopGestureTransition()
    private lazy var downTransiton = DownGestureTransition()
    private var popTransitionInteractor: UIPercentDrivenInteractiveTransition?
    private var downTransitionInteractor: DownTransitionInteractor?
    private var popRecognizer: UIPanGestureRecognizer!
    private var isEnabled = true
    private var popDirection: PopDirection = .stop
    
    var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        addPanGesture()
    }
    
    func setPopGestureEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    internal func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated {
            isAnimating = true
        }
    }
    
    internal func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isAnimating = false
        popRecognizer.isEnabled = viewControllers.count > 1
    }
    
    internal func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            switch popDirection {
            case .down:
                return downTransiton
            case .right:
                return popTransition
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    internal func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        switch animationController {
        case is PopGestureTransition:
            return popTransitionInteractor
        case is DownGestureTransition:
            return downTransitionInteractor
        default:
            return nil
        }
    }
    
    private func addPanGesture() {
        popRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(recognizer:)))
        popRecognizer.delegate = self
        
        if let isContain = view.gestureRecognizers?.contains(popRecognizer), isContain {
            view.removeGestureRecognizer(popRecognizer)
        }
        view.addGestureRecognizer(popRecognizer)
    }
    
    private func popGesture(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            if viewControllers.count > 1 && !isAnimating {
                popTransitionInteractor = UIPercentDrivenInteractiveTransition()
                popTransitionInteractor?.completionCurve = .easeOut
                popViewController(animated: true)
            }
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)
            let distance = translation.x > 0 ? translation.x / view.bounds.width : 0
            popTransitionInteractor?.update(distance)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            if recognizer.velocity(in: view).x > 0 {
                popTransitionInteractor?.finish()
            } else {
                popTransitionInteractor?.cancel()
                isAnimating = false
            }
            popTransitionInteractor = nil
        }
    }
    
    private func downGesture(recognizer: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        
        let translation = recognizer.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch recognizer.state {
        case .began:
            if viewControllers.count > 1 && !isAnimating {
                downTransitionInteractor = DownTransitionInteractor()
                downTransitionInteractor?.hasStarted = true
                popViewController(animated: true)
            }
        case .changed:
            downTransitionInteractor?.shouldFinish = progress > percentThreshold
            downTransitionInteractor?.update(progress)
        case .cancelled:
            downTransitionInteractor?.hasStarted = false
            downTransitionInteractor?.cancel()
            isAnimating = false
            downTransitionInteractor = nil
        case .ended:
            downTransitionInteractor?.hasStarted = false
            if let isShouldFinish = downTransitionInteractor?.shouldFinish {
                if isShouldFinish {
                    downTransitionInteractor?.finish()
                } else {
                    downTransitionInteractor?.cancel()
                    isAnimating = false
                }
            }
            downTransitionInteractor = nil
        default:
            break
        }
    }
    
    @objc private func handlePanRecognizer(recognizer: UIPanGestureRecognizer) {
        switch popDirection {
        case .down:
            downGesture(recognizer: recognizer)
        case .right:
            popGesture(recognizer: recognizer)
        default:
            return
        }
    }
}

extension BJTransitionController: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard viewControllers.count > 1, self.isEnabled else { return false }
        
        if popRecognizer == gestureRecognizer, let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: view)
            if velocity.y > abs(velocity.x) {
                popDirection = .down
                return true
            } else if velocity.x > abs(velocity.y) {
                popDirection = .right
                return true
            } else {
                popDirection = .stop
                return false
            }
        }
        return true
    }
}
