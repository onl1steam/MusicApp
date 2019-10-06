//
//  Track.swift
//  MusicApp
//
//  Created by Рыжков Артем on 04.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

struct Track: Codable {
    var artistName: String
    var collectionName: String
    var trackName: String
    var previewUrl: String
    var artworkUrl60: String
    var artworkUrl100: String
}
