//
//  UIViewControllerExtension.swift
//  MusicApp
//
//  Created by Рыжков Артем on 26.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

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
}
