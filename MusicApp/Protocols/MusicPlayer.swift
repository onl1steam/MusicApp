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

protocol MusicPlayer {
    
    var tracks: [Track]? { get }
    var isPlaying: BehaviorRelay<Bool> { get }
    var currentTrack: BehaviorSubject<Track?> { get }
    
    var trackDuration: Float { get }
    var currentTime: Float { get }
    
    func loadTracks(tracks: [Track], currentIndex: Int)
    func initializePlayer()
    
    func setNext()
    func setPrevious()
    func toggleMusic()
    func changeVolume(to value: Float)
    func seekMusic(to time: CMTime, completion: (()->Void)? ) 
}
