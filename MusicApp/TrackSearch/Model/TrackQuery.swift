//
//  TrackQuery.swift
//  MusicApp
//
//  Created by Рыжков Артем on 04.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

struct TrackQuery: Codable {
    var resultCount: Int
    var results: [Track]
}
