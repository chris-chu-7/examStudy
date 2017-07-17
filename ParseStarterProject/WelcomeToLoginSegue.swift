//
//  WelcomeToLoginSegue.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class WelcomeToLoginSegue: UIStoryboardSegue {
    override func perform() {
        scale() //perform the expanding transformation from the first viewcontroller to the second
    }
    
    func scale() {
        let toViewController = self.destination //the view controller to perform the transformation to
        let fromViewController = self.source //the view controller performing the transformation
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center //the center of the original viewcontroller
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0, y: 0.5) //set up a transform vector
        containerView?.addSubview(toViewController.view) //add the subview of the second view controller
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: { //animate the transformation with curve ease in out, transformation is expanding
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { (success) in
            fromViewController.present(toViewController, animated: false, completion: nil)
            })
    }
}
