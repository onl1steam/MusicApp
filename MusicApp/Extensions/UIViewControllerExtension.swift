//
//  UIViewControllerExtension.swift
//  MusicApp
//
//  Created by Рыжков Артем on 26.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

enum Animation {
    case LeftToRight
    case RightToLeft
}

extension UIViewController {
    
    public func add(asChildViewController viewController: UIViewController, to parentView: UIView) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        parentView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = parentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    func animationForLoad(parentView: UIView, fromVC: UIViewController, toVC: UIViewController, with animation: Animation) {

        addChild(toVC)

        var endOriginx: CGFloat = 0

        if animation == Animation.LeftToRight {
            toVC.view.frame.origin.x = -parentView.bounds.width
            endOriginx += fromVC.view.frame.width
        } else {
            toVC.view.frame.origin.x = parentView.bounds.width
            endOriginx -= fromVC.view.frame.width
        }

        self.transition(from: fromVC, to: toVC, duration: 0.3, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
            toVC.view.frame = fromVC.view.frame
            fromVC.view.frame.origin.x = endOriginx
            }, completion: { (finish) in
                toVC.didMove(toParent: self)
                fromVC.view.removeFromSuperview()
                fromVC.removeFromParent()
        })
        
        self.add(asChildViewController: toVC, to: parentView)
    }
}
