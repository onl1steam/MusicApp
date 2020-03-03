//
//  ImageLoader.swift
//  MusicApp
//
//  Created by Рыжков Артем on 03.03.2020.
//  Copyright © 2020 Рыжков Артем. All rights reserved.
//

import Foundation

protocol ImageLoader {
    func getImageData(from url: String, completion: @escaping (Data) -> Void )
}
