//
//  TrackConverter.swift
//  MusicApp
//
//  Created by Рыжков Артем on 03.03.2020.
//  Copyright © 2020 Рыжков Артем. All rights reserved.
//

import Foundation

class TrackConverter {
    static func convertToTrack(trackObject: TrackObject) -> Track {
        let track = Track( artistName: trackObject.artistName,
                           collectionName: trackObject.collectionName,
                           trackName: trackObject.trackName,
                           previewUrl: trackObject.previewUrl,
                           artworkUrl60: trackObject.artworkUrl60,
                           artworkUrl100: trackObject.artworkUrl100)
        return track
    }
    
    static func convertToObject(track: Track) -> TrackObject {
        let trackObject = TrackObject()
        trackObject.trackName = track.trackName
        trackObject.artistName = track.artistName
        trackObject.collectionName = track.collectionName
        trackObject.previewUrl = track.previewUrl
        trackObject.artworkUrl60 = track.artworkUrl60
        trackObject.artworkUrl100 = track.artworkUrl100
        return trackObject
    }
}
