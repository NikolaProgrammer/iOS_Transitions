//
//  ScaleAnimation.swift
//  Transitions
//
//  Created by Nikolay Sereda on 23.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class ScaleAnimation: NSObject {
    
    //MARK: Properties
    var duration = 1.0
    var startPoint = CGPoint.zero
    var style: PresentationStyle?
    
}

extension ScaleAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        if style == .present {
            if let presentedView = transitionContext.view(forKey: .to) {
                let viewCenter = presentedView.center

                presentedView.center = startPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                container.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    
                    presentedView.center = viewCenter
                }) { (success) in
                    transitionContext.completeTransition(success)
                }
            }
        } else {
            if let dismissedView = transitionContext.view(forKey: .from) {

                UIView.animate(withDuration: duration, animations: {
                    dismissedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    dismissedView.alpha = 0
                    
                    dismissedView.center = self.startPoint
                    
                }) { (success) in
                    dismissedView.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                }
            }
        }
    }
    
}

extension ScaleAnimation: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        style = .present
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        style = .dismiss
        return self
    }
}



















