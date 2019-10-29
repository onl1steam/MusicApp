//
//  TrackAlertViewModel.swift
//  MusicApp
//
//  Created by Рыжков Артем on 27.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

class TrackAlertViewModel {
    
    var track: Track
    
    var deleteFromDB = false
    var deleteFromFileManager = false
    var saveToPlaylist = false
    var saveToFileManager = false
    
    init(with track: Track) {
        self.track = track
        let localInfo = RealmDBService.shared.isObjectExistsAndDownloaded(previewUrl: track.previewUrl)
        
        if localInfo.isDownloaded {
            deleteFromDB = true
            deleteFromFileManager = true
            saveToPlaylist = false
            saveToFileManager = false
        } else if localInfo.isExists {
            deleteFromDB = true
            deleteFromFileManager = false
            saveToPlaylist = false
            saveToFileManager = true
        } else {
            deleteFromDB = false
            deleteFromFileManager = false
            saveToPlaylist = true
            saveToFileManager = true
        }
    }
    
    func saveTrackToPlaylist() {
        RealmDBService.shared.saveTrackToDB(track: track)
    }
    
    func saveTrackToFileManager() {
        TrackService.shared.downloadTrackToMemomy(track: track)
    }
    
    func deleteTrackFromPlaylist() {
        RealmDBService.shared.removeFromDB(previewUrl: track.previewUrl)
    }
    
    func deleteTrackFromFileManager() {
        RealmDBService.shared.removeFromFileManager(previewUrl: track.previewUrl)
    }
    
    
}
