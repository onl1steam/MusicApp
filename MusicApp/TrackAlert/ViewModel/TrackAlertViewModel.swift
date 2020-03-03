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
    
    let dbService: DBService = RealmDBService.shared
    
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
        dbService.saveTrack(track: track)
    }
    
    func saveTrackToFileManager() {
        FileManagerControlService.downloadTrackToMemomy(track: track)
    }
    
    func deleteTrackFromPlaylist() {
        dbService.removeTrack(previewUrl: track.previewUrl)
    }
    
    func deleteTrackFromFileManager() {
        FileManagerControlService.removeFromFileManager(previewUrl: track.previewUrl)
    }
    
    
}
