//
//  TrackService.swift
//  MusicApp
//
//  Created by Рыжков Артем on 04.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class TrackService {
    
    static let shared = TrackService()
    private init() { }
    typealias QueryResult = ([Track]?) -> Void
    
    var trackList: [Track]?
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func findTracksRequest(searchTerm: String, comletion: @escaping QueryResult) {
        
        trackList = []
        
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
                        self?.updateTrackList(with: tracks)
                        
                        DispatchQueue.main.async {
                             comletion(self?.trackList)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func updateTrackList(with tracks: [Track]) {
        trackList = tracks
    }
}
