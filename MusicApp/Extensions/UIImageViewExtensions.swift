//
//  UIViewExtensions.swift
//  MusicApp
//
//  Created by Рыжков Артем on 15.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

enum ImageSizeAnimationConstants {
    static var duration: TimeInterval = 0.4
    static var delay: TimeInterval = 0
    static var damping: CGFloat = 0.5
    static var springVelocity: CGFloat = 10
    static var transformScale: CGFloat = 1.2
    static var initialScale: CGFloat = 1
}


extension UIImageView {
    
    func imageSizeAnimation(flag: Bool) {
        if flag {
            UIView.animate(withDuration: ImageSizeAnimationConstants.duration,
                           delay: ImageSizeAnimationConstants.delay,
                           usingSpringWithDamping: ImageSizeAnimationConstants.damping,
                           initialSpringVelocity: ImageSizeAnimationConstants.springVelocity,
                           options: [.curveEaseOut], animations: {
                            self.transform = CGAffineTransform(scaleX: ImageSizeAnimationConstants.transformScale,
                                                               y:ImageSizeAnimationConstants.transformScale)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: ImageSizeAnimationConstants.duration,
                           delay: ImageSizeAnimationConstants.delay,
                           usingSpringWithDamping: ImageSizeAnimationConstants.damping,
                           initialSpringVelocity: ImageSizeAnimationConstants.springVelocity,
                           options: [.curveEaseOut], animations: {
                            self.transform = CGAffineTransform(scaleX: ImageSizeAnimationConstants.initialScale,
                                                               y: ImageSizeAnimationConstants.initialScale)
            }, completion: nil)
        }
    }
}
