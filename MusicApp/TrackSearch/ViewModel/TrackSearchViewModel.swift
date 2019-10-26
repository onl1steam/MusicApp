//
//  TrackSearchViewModel.swift
//  MusicApp
//
//  Created by Рыжков Артем on 26.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RxSwift

class TrackSearchViewModel {
    
    let trackList = BehaviorSubject<[Track]>(value: [])
    let isAnimating = BehaviorSubject<Bool>(value: false)
    
    
    // MARK: Requesting for tracks
    func requestForTracks(with searchTerm: String) {
        // Updating views
        isAnimating.onNext(true)
        trackList.onNext([])
        
        TrackService.shared.fetchTracks(searchTerm: searchTerm) { [weak self] (tracks) in
            guard let tracks = tracks else {
                self?.isAnimating.onNext(false)
                return
            }
            // Updating track list
            self?.trackList.onNext(tracks)
            // Activity Indicator state change
            self?.isAnimating.onNext(false)
        }
    }
    
}
