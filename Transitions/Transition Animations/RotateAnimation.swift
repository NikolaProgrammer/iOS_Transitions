//
//  RotateAnimation.swift
//  Transitions
//
//  Created by Nikolay Sereda on 23.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class RotateAnimation: NSObject {
    
    //MARK: Properties
    var duration = 1.0
    var style: PresentationStyle?
}

extension RotateAnimation: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        if style == .present {
            if let presentedView = transitionContext.view(forKey: .to) {
                
                presentedView.layer.anchorPoint = CGPoint.zero
                presentedView.frame.origin = CGPoint.zero
                presentedView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                container.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    presentedView.transform = CGAffineTransform.identity
                }) { (success) in
                    transitionContext.completeTransition(success)
                }
            }
        } else {
            if let dismissedView = transitionContext.view(forKey: .from) {
                dismissedView.layer.anchorPoint = CGPoint.zero
                
                UIView.animate(withDuration: duration, animations: {
                    dismissedView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                }) { (success) in
                    dismissedView.removeFromSuperview()
                    transitionContext.completeTransition(success)
                }
            }
        }
    }
}

extension RotateAnimation: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        style = .dismiss
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        style = .present
        return self
    }
}
