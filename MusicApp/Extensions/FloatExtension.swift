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
    
    func convertToTimeString() -> String {
        let minutes = (self / 60).rounded()
        let seconds = (self - minutes * 60).rounded()
        
        let minutesInt = Int(minutes)
        let secondsInt = Int(seconds)
        
        var secondsString = "\(secondsInt)"
        if seconds < 10 {
            secondsString = "0\(secondsInt)"
        }
        return "\(minutesInt):\(secondsString)"
    }
    
}
