//
//  MusicPlayer.swift
//  MusicApp
//
//  Created by Рыжков Артем on 07.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import AVKit
import MediaPlayer
import RxSwift
import RxCocoa

class MusicPlayerService: MusicPlayer {
    
    // MARK: Properties
    static let shared = MusicPlayerService()
    
    private(set) var tracks: [Track]?
    private var player : AVPlayer?
    
    let isPlaying = BehaviorRelay<Bool>(value: false)
    let currentTrack = BehaviorSubject<Track?>(value: nil)
    
    var currentIndex = 0
    var currentTime: Float {
        guard let time = player?.currentTime().seconds else { return 0 }
        return Float(time)
    }
    var trackDuration: Float {
        guard let time = player?.currentItem?.duration.seconds else { return 0 }
        return Float(time)
    }
    
    // MARK: Adding observer to ending of track
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK: Observing for ending of track
    @objc func playerDidFinishPlaying() {
        if let count = tracks?.count,
            currentIndex == count - 1 {
            
            currentIndex = 0
            MusicPlayerService.shared.pauseMusic()
            MusicPlayerService.shared.seekMusic(to: .zero, completion: nil)
            MusicPlayerService.shared.isPlaying.accept(false)
            initializePlayer()
        } else {
            setNext()
        }
    }
    
    // MARK: Loading tracks from controller
    func loadTracks(tracks: [Track], currentIndex: Int) {
        isPlaying.accept(true)
        self.currentIndex = currentIndex
        self.tracks = tracks
    }
    
    // MARK: Loading player with current track
    func initializePlayer() {
        currentTrack.onNext(tracks?[currentIndex])
        guard let previewUrl = tracks?[currentIndex].previewUrl else { return }
        // Fetching track url from local/web
        guard let trackUrl = RealmDBService.shared.getTrackUrl(previewUrl: previewUrl) else { return }
        let playerItem = AVPlayerItem(url: trackUrl)
        player = AVPlayer(playerItem: playerItem)
        if isPlaying.value {
            player?.play()
        }
    }

    
    // MARK: Set next/previous track
    func setNext() {
        if let count = tracks?.count,
            currentIndex < count - 1 {
            currentIndex += 1
            initializePlayer()
        }
    }
    
    func setPrevious() {
        if let time = player?.currentTime().seconds,
            time > 5 {
            seekMusic(to: .zero, completion: nil)
            return
        }
        if let count = tracks?.count,
            count > 0,
            currentIndex > 0 {
            currentIndex -= 1
            initializePlayer()
        }
    }
    
    // MARK: Change music playing status
    func toggleMusic() {
        var playing = isPlaying.value
        if tracks != nil {
            playing.toggle()
            if playing {
                playMusic()
            } else {
                pauseMusic()
            }
        }
    }
    
    // MARK: Change volume
    func changeVolume(to value: Float) {
        MPVolumeView.setVolume(value)
    }
    
    // MARK: Play/pause
    private func playMusic() {
        player?.play()
        isPlaying.accept(true)
    }
    
    private func pauseMusic() {
        player?.pause()
        isPlaying.accept(false)
    }
    
    // MARK: Seek music to some time
    func seekMusic(to time: CMTime, completion: (() -> Void)? ) {
        player?.seek(to: time, completionHandler: { (_) in
            completion?()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
