//
//  RealmDBService.swift
//  MusicApp
//
//  Created by Рыжков Артем on 08.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDBManager {
    
    private var realm: Realm
    private let backgroundThread = DispatchQueue(label: "backgroundRealm", qos: .background)
    
    static let shared = RealmDBManager()
    private init() {
       realm = try! Realm()
    }
    
    func saveTrackToBD(track: Track) {
        if !isObjectExist(previewUrl: track.previewUrl) {
            try? realm.write {
                let trackObject = convertToObject(track: track)
                realm.add(trackObject)
            }
        }
    }
    
    func removeFromDB(track: Track) {
        try? realm.write {
            try? realm.delete(Realm().objects(TrackObject.self).filter("previewUrl=%@", track.previewUrl))
        }
    }
    
    func getTracksFromDB(completion: @escaping ([Track]?) -> Void) {
        backgroundThread.async { [weak self] in
            let realm = try! Realm()
            var trackList: [Track]? = []
            let results: Results<TrackObject> = realm.objects(TrackObject.self)
            for result in results {
                guard let track = self?.convertToTrack(trackObject: result) else { continue }
                trackList?.insert(track, at: 0)
            }
            DispatchQueue.main.async {
                completion(trackList)
            }
        }
     }
    
    func isObjectExist (previewUrl: String) -> Bool {
            return realm.object(ofType: TrackObject.self, forPrimaryKey: previewUrl) != nil
    }
    
    // Convertion of Track model to BD model
    private func convertToTrack(trackObject: TrackObject) -> Track {
        
        let track = Track( artistName: trackObject.artistName,
                           collectionName: trackObject.collectionName,
                           trackName: trackObject.trackName,
                           previewUrl: trackObject.previewUrl,
                           artworkUrl60: trackObject.artworkUrl60,
                           artworkUrl100: trackObject.artworkUrl100)
        
        return track
    }
    
    private func convertToObject(track: Track) -> TrackObject {
        let trackObject = TrackObject()
        // Convertion to DB model
        trackObject.trackName = track.trackName
        trackObject.artistName = track.artistName
        trackObject.collectionName = track.collectionName
        trackObject.previewUrl = track.previewUrl
        trackObject.artworkUrl60 = track.artworkUrl60
        trackObject.artworkUrl100 = track.artworkUrl100
        return trackObject
    }

}
