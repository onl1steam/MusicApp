//
//  FileManagerDownloadService.swift
//  MusicApp
//
//  Created by Рыжков Артем on 03.03.2020.
//  Copyright © 2020 Рыжков Артем. All rights reserved.
//

import Foundation

class FileManagerControlService {
    
    static func removeFromFileManager(previewUrl: String) {
        let dbService: DBService = RealmDBService.shared
        
        if let audioUrl = URL(string: previewUrl) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            do {
                try FileManager.default.removeItem(atPath: destinationUrl.path)
                dbService.removeTrackLocalUrl(previewUrl: previewUrl)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func downloadTrackToMemomy(track: Track) {
        let dbService: DBService = RealmDBService.shared
        
        if let audioUrl = URL(string: track.previewUrl) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
            } else {
                
                URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                    guard let location = location, error == nil else { return }
                    do {
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        DispatchQueue.main.async {
                            dbService.saveTrackLocalUrl(track: track)
                        }
                    } catch {
                        print(error)
                    }
                }.resume()
            }
        }
    }
}
