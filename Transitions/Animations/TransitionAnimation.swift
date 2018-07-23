//
//  TransitionAnimation.swift
//  Transitions
//
//  Created by Nikolay Sereda on 23.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class TransitionAnimation: UIPercentDrivenInteractiveTransition {
    
    //MARK: Properties
    var isPresenting = false
    var sourceController: UIViewController! {
        didSet {
            let enterPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(enterPanHandle(pan:)))
            enterPanGesture.edges = .right
            sourceController.view.addGestureRecognizer(enterPanGesture)
        }
    }
    var destinationController: UIViewController! {
        didSet {
            let exitPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(exitPanHandle(pan:)))
            exitPanGesture.edges = .left
            destinationController.view.addGestureRecognizer(exitPanGesture)
        }
    }
    
    //MARK: Private Methods
    @objc private func enterPanHandle(pan: UIScreenEdgePanGestureRecognizer) {
        
        let translation = pan.translation(in: pan.view)
        let distance = translation.x / (pan.view?.bounds.width)! * -1
        
        switch pan.state {
        case .began:
            sourceController.performSegue(withIdentifier: "interactive", sender: self)
        case .changed:
            update(distance)
        default:
            if distance < 0.2 {
                cancel()
            } else {
                finish()
            }
        }
    }
    
    @objc private func exitPanHandle(pan: UIScreenEdgePanGestureRecognizer) {
        
        let translation = pan.translation(in: pan.view)
        let distance = translation.x / (pan.view?.bounds.width)!
        
        switch pan.state {
        case .began:
            destinationController.dismiss(animated: true, completion: nil)
        case .changed:
            update(distance)
        default:
            if distance < 0.2 {
                cancel()
            } else {
                finish()
            }
        }
    }
}


extension TransitionAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let sourceView = transitionContext.view(forKey: .from)!
        let destinationView = transitionContext.view(forKey: .to)!
        
        if isPresenting {
            destinationView.transform = CGAffineTransform(translationX: container.frame.width, y: 0)
            container.addSubview(destinationView)
            
            UIView.animate(withDuration: 0.5, animations: {
                destinationView.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            destinationView.transform = CGAffineTransform(translationX: -container.frame.width, y: 0)
            container.addSubview(destinationView)
            
            UIView.animate(withDuration: 0.5, animations: {
                destinationView.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (success) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if !transitionContext.transitionWasCancelled {
                    sourceView.removeFromSuperview()
                }
            }
        }
        
    }
  
}

extension TransitionAnimation: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
}
