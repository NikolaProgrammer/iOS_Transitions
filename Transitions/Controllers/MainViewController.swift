//
//  ViewController.swift
//  Transitions
//
//  Created by Nikolay Sereda on 19.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var scaleButton: UIButton!
    let scaleTransition = ScaleAnimation()
    let rotateTransition = RotateAnimation()
    let transitionAnimation = TransitionAnimation()
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitionAnimation.sourceController = self
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "scale":
            let destination = segue.destination as! ScaleViewController
            
            scaleTransition.startPoint = scaleButton.center
            destination.transitioningDelegate = scaleTransition
            destination.modalPresentationStyle = .custom
        case "rotate":
            let destination = segue.destination as! RotateViewController

            destination.transitioningDelegate = rotateTransition
            destination.modalPresentationStyle = .custom
        case "interactive":
            let destination = segue.destination as! TransitionViewController
            transitionAnimation.destinationController = destination
            destination.transitioningDelegate = transitionAnimation
        default:
            fatalError("Unknown segue: \(String(describing: segue.identifier))")
        }
        
    }
    
}
