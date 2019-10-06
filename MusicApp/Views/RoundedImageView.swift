//
//  RoundedImageView.swift
//  MusicApp
//
//  Created by Рыжков Артем on 06.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

enum RoundedImageViewConstants {
    static let imageCornerRadius: CGFloat = 10.0
}

@IBDesignable
class RoundedImageView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Implementing corner radius
        super.layoutSubviews()
        self.layer.cornerRadius = RoundedImageViewConstants.imageCornerRadius
        self.clipsToBounds = true
        
        // Implementing shadows
    }
}
