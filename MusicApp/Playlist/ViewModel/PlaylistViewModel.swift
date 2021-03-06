//
//  PlaylistViewModel.swift
//  MusicApp
//
//  Created by Рыжков Артем on 26.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RxSwift

class PlaylistViewModel {
    
    let trackList = BehaviorSubject<[Track]>(value: [])
    let isAnimating = BehaviorSubject<Bool>(value: false)
    
    let dbService: DBService = RealmDBService.shared
    
    func fetchTracks() {
        isAnimating.onNext(true)
        dbService.fetchTracks { [weak self] (tracks) in
            guard let fetchedTracks = tracks else { return }
            self?.isAnimating.onNext(false)
            self?.trackList.onNext(fetchedTracks)
        }
    }
    
}
