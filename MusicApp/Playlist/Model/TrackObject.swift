//
//  TrackObject.swift
//  MusicApp
//
//  Created by Рыжков Артем on 07.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RealmSwift

class TrackObject: Object {
    
    // Networking information
    @objc dynamic var trackName = ""
    @objc dynamic var artistName = ""
    @objc dynamic var collectionName = ""
    @objc dynamic var previewUrl = ""
    @objc dynamic var artworkUrl60 = ""
    @objc dynamic var artworkUrl100 = ""
    
    // Local storage
    @objc dynamic var previewLocalUrl = ""
    @objc dynamic var artworkLocalUrl60 = ""
    @objc dynamic var artworkLocalUrl100 = ""
    
    override static func primaryKey() -> String? {
        return "previewUrl"
    }
    
    
}

