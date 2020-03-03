//
//  MusicPlayer.swift
//  MusicApp
//
//  Created by Рыжков Артем on 03.03.2020.
//  Copyright © 2020 Рыжков Артем. All rights reserved.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

protocol TracksConfigurable {
    var tracks: [Track]? { get }
    var isPlaying: BehaviorRelay<Bool> { get }
    var currentTrack: BehaviorSubject<Track?> { get }
    
    var trackDuration: Float { get }
    var currentTime: Float { get }
}

protocol TrackVariable {
    func setNext()
    func setPrevious()
    func toggleMusic()
    func seekMusic(to time: CMTime, completion: (()->Void)? )
}

protocol VolumeVariable {
    func changeVolume(to value: Float)
}

protocol MusicPlayer: TracksConfigurable, TrackVariable, VolumeVariable {
    func loadTracks(tracks: [Track], currentIndex: Int)
    func initializePlayer()
}
