//
//  TracksTableViewModel.swift
//  MusicApp
//
//  Created by Рыжков Артем on 20.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TracksTableViewModel {
    
    let tracks = BehaviorRelay<[Track]>(value: [])
    
    init(with tracks: [Track]) {
        self.tracks.accept(tracks)
    }
    
    func loadTracks(currentIndex: Int) {
        MusicPlayerService.shared.loadTracks(tracks: tracks.value, currentIndex: currentIndex)
        MusicPlayerService.shared.initializePlayer()
        MusicPlayerService.shared.playMusic()
    }
    
    func changeTracks(to tracks: [Track]) {
        self.tracks.accept(tracks)
    }
}
