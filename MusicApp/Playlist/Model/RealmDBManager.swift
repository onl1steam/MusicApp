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
    
    // MARK: Save track to Database
    func saveTrackToDB(track: Track) {
        if !isObjectExistsAndDownloaded(previewUrl: track.previewUrl).isExists {
            try? realm.write {
                let trackObject = convertToObject(track: track)
                realm.add(trackObject)
            }
        }
    }
    
    // MARK: Remove track from Database
    func removeFromDB(previewUrl: String) {
        try? realm.write {
            removeFromFileManager(previewUrl: previewUrl)
            try? realm.delete(Realm().objects(TrackObject.self).filter("previewUrl=%@", previewUrl))
        }
    }
    
    // MARK: Remove track from local File Manager
    func removeFromFileManager(previewUrl: String) {
        if let audioUrl = URL(string: previewUrl) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)

            do {
                try FileManager.default.removeItem(atPath: destinationUrl.path)
                removeTrackLocalUrl(previewUrl: previewUrl)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Fetch track list from Database
    func fetchTracks(completion: @escaping ([Track]?) -> Void) {
        backgroundThread.async {
            let realm = try! Realm()
            var trackList: [Track]? = []
            let results: Results<TrackObject> = realm.objects(TrackObject.self)
            for result in results {
                let track = self.convertToTrack(trackObject: result)
                trackList?.insert(track, at: 0)
            }
            DispatchQueue.main.async {
                completion(trackList)
            }
        }
     }
    
    // MARK: Get track local/web url from Database
    func getTrackUrl(previewUrl: String) -> URL? {
        let localInfo = isObjectExistsAndDownloaded(previewUrl: previewUrl)
        if localInfo.isDownloaded {
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            guard let urlFM = URL(string: previewUrl) else { return nil }
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(urlFM.lastPathComponent)
            
            return destinationUrl
        } else {
            guard let url = URL(string: previewUrl) else { return nil }
            return url
        }
    }
    
    // MARK: Check if the object with previewUrl exists
    func isObjectExistsAndDownloaded (previewUrl: String) -> (isExists: Bool, isDownloaded: Bool) {
        guard let track = realm.object(ofType: TrackObject.self, forPrimaryKey: previewUrl)
            else { return (false, false) }
        let isExists = true
        let isDownloaded = (track.isDownloaded)
        return (isExists, isDownloaded)
    }
    
    // MARK: Convertion from Track to TrackObject
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
    
    // MARK: Save Local track url
    func saveTrackLocalUrl(track: Track) {
        let tracks = realm.objects(TrackObject.self).filter("previewUrl = %@", track.previewUrl)
        
        let realm = try! Realm()
        if let track = tracks.first {
            try! realm.write {
                track.isDownloaded = true
            }
        }
    }
    
    func removeTrackLocalUrl(previewUrl: String) {
        let tracks = realm.objects(TrackObject.self).filter("previewUrl = %@", previewUrl)
        
        let realm = try! Realm()
        if let track = tracks.first {
            try! realm.write {
                track.isDownloaded = false
            }
        }
    }

}
