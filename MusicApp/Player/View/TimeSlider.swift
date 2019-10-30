//
//  TimeSlider.swift
//  MusicApp
//
//  Created by Рыжков Артем on 19.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

@IBDesignable
class TimeSlider: UISlider {
    
    @IBInspectable var height: CGFloat = 10
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        let size = CGSize(width: bounds.width, height: height)
        return CGRect(origin: point, size: size)
    }
    
    

}
