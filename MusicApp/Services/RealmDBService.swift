//
//  RealmDBService.swift
//  MusicApp
//
//  Created by Рыжков Артем on 08.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDBService: DBService {
    private let backgroundThread = DispatchQueue(label: "backgroundRealm", qos: .background)
    
    private var realm: Realm
    static let shared = RealmDBService()
    private init() {
        realm = try! Realm()
    }
    
    // MARK: Save track to Database
    func saveTrack(track: Track) {
        if !isObjectExistsAndDownloaded(previewUrl: track.previewUrl).isExists {
            try? realm.safeWrite {
                let trackObject = TrackConverter.convertToObject(track: track)
                realm.add(trackObject)
            }
        }
    }
    
    // MARK: Remove track from Database
    func removeTrack(previewUrl: String) {
        try? realm.safeWrite {
            FileManagerControlService.removeFromFileManager(previewUrl: previewUrl)
            try? realm.delete(Realm().objects(TrackObject.self).filter("previewUrl=%@", previewUrl))
        }
    }
    
    // MARK: Fetch track list from Database
    func fetchTracks(completion: @escaping ([Track]?) -> Void) {
        backgroundThread.async {
            let realm = try! Realm()
            var trackList: [Track]? = []
            let results: Results<TrackObject> = realm.objects(TrackObject.self)
            for result in results {
                let track = TrackConverter.convertToTrack(trackObject: result)
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
    
    // MARK: Save Local track url
   func saveTrackLocalUrl(track: Track) {
          let tracks = realm.objects(TrackObject.self).filter("previewUrl = %@", track.previewUrl)
          
          if let track = tracks.first {
              try! realm.safeWrite {
                  track.isDownloaded = true
              }
          }
      }
    
    func removeTrackLocalUrl(previewUrl: String) {
        let tracks = realm.objects(TrackObject.self).filter("previewUrl = %@", previewUrl)
        
        if let track = tracks.first {
            try! realm.safeWrite {
                track.isDownloaded = false
            }
        }
    }
}

extension Realm {
    // Safe writing to avoid realm write exception 
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
