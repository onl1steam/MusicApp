//
//  TrackService.swift
//  MusicApp
//
//  Created by Рыжков Артем on 04.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation

class TrackService {
    
    static let shared = TrackService()
    private init() { }
    typealias QueryResult = ([Track]?) -> Void

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    // MARK: Load track list from url
    func fetchTracks(searchTerm: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
        urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                  self?.dataTask = nil
                }
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    // Parse Track List
                    do {
                        let queryResult = try JSONDecoder().decode(TrackQuery.self, from: data)
                        let tracks = queryResult.results
                        DispatchQueue.main.async {
                             completion(tracks)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    // MARK: Download track to memory
    func downloadTrackToMemomy(track: Track) {
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
                            RealmDBService.shared.saveTrackLocalUrl(track: track)
                        }
                    } catch {
                        print(error)
                    }
                }.resume()
            }
        }
    }

}
