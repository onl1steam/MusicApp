//
//  DataBase.swift
//  MusicApp
//
//  Created by Рыжков Артем on 03.03.2020.
//  Copyright © 2020 Рыжков Артем. All rights reserved.
//

import Foundation

protocol DBService {
    func saveTrack(track: Track)
    func removeTrack(previewUrl: String)
    func fetchTracks(completion: @escaping ([Track]?) -> Void )
    func getTrackUrl(previewUrl: String) -> URL?
    func isObjectExistsAndDownloaded(previewUrl: String) -> (isExists: Bool, isDownloaded: Bool)
    func saveTrackLocalUrl(track: Track)
    func removeTrackLocalUrl(previewUrl: String)
}
