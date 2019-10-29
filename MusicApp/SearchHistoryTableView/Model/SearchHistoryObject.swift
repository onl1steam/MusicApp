//
//  SearchHistory.swift
//  MusicApp
//
//  Created by Рыжков Артем on 29.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RealmSwift

class SearchHistoryObject: Object {
    
    @objc dynamic var trackName: String = "" 
    
    override static func primaryKey() -> String? {
        return "trackName"
    }
    
}


