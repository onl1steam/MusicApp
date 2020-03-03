//
//  ImageLoader.swift
//  MusicApp
//
//  Created by Рыжков Артем on 19.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import SDWebImage

class ImageLoadService: ImageLoader {
    
    func getImageData(from url: String, completion: @escaping (Data) -> Void ) {
        let _ = SDWebImageManager.shared.loadImage(with: URL(string: url),
                                           options: .continueInBackground,
                                           context: nil, progress: nil) {
            (image, data, error, cacheType, bool, url) in
            guard let imageData = image?.sd_imageData() else { return }
            completion(imageData)
        }
    }
    
}
