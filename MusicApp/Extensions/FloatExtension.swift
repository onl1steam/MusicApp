//
//  FloatExtension.swift
//  MusicApp
//
//  Created by Рыжков Артем on 18.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import CoreMedia

extension Float {
    
    func convertToCMTime() -> CMTime {
        let seconds = Double(self)
        let time = CMTime(seconds: seconds, preferredTimescale: 1)
        return time
    }
    
}
