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
    
    let musicPlayer: MusicPlayer = MusicPlayerService.shared
    let tracks = BehaviorRelay<[Track]>(value: [])
    
    init(with tracks: [Track]) {
        self.tracks.accept(tracks)
    }
    
    private func loadTracks(currentIndex: Int, isShuffled: Bool) {
        let trackList = isShuffled ? tracks.value.shuffled() : tracks.value
        musicPlayer.loadTracks(tracks: trackList, currentIndex: currentIndex)
        musicPlayer.initializePlayer()
        musicPlayer.toggleMusic()
    }
    
    func changeTracks(to tracks: [Track]) {
        self.tracks.accept(tracks)
    }
    
    func playTrack(currentIndex: Int) {
        loadTracks(currentIndex: currentIndex, isShuffled: false)
    }
    
    func startPlaying() {
        loadTracks(currentIndex: 0, isShuffled: false)
    }
    
    func shufflePlaylist() {
        loadTracks(currentIndex: 0, isShuffled: true)
    }
}
