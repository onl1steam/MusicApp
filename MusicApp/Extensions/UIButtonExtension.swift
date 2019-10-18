//
//  UIButtonExtension.swift
//  MusicApp
//
//  Created by Рыжков Артем on 18.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

extension UIButton {
    
    func changeSystemButton(firstImageName: String, secondImageName: String, with flag: Bool) {
        if flag {
            guard let image = UIImage(systemName: firstImageName) else { return }
            self.setBackgroundImage(image, for: .normal)
        } else {
            guard let image = UIImage(systemName: secondImageName)  else { return }
            self.setBackgroundImage(image, for: .normal)
        }
    }
    
}
