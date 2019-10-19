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

class MusicPlayerService {
    
    // MARK: Properties
    static let shared = MusicPlayerService()
    
    var tracks: [Track]?
    private var player : AVPlayer?
    
    var isPlaying = false
    var currentIndex = 0
    var currentTrack: Track? {
        return tracks?[currentIndex]
    }
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
            MusicPlayerService.shared.isPlaying = false
            initializePlayer()
        } else {
            setNext()
        }
    }
    
    // MARK: Loading tracks from controller
    func loadTracks(tracks: [Track], currentIndex: Int) {
        isPlaying = true
        self.currentIndex = currentIndex
        self.tracks = tracks
    }
    
    // MARK: Loading player with current track
    func initializePlayer() {
        guard let previewUrl = tracks?[currentIndex].previewUrl else { return }
        // Fetching track url from local/web
        guard let trackUrl = RealmDBManager.shared.getTrackUrl(previewUrl: previewUrl) else { return }
        // guard let trackUrl = URL(string: previewUrl) else { return }
        let playerItem = AVPlayerItem(url: trackUrl)
        player = AVPlayer(playerItem: playerItem)
        if isPlaying {
            player?.play()
        }
    }
    
    // MARK: Get track duration
    func getTrackDuration() -> Float {
        guard let duration = player?.currentItem?.asset.duration.seconds else { return 0 }
        return Float(duration)
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
        isPlaying.toggle()
        if isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    // MARK: Change volume
    func changeVolume(to value: Float) {
        MPVolumeView.setVolume(value)
    }
    
    // MARK: Play/pause
    func playMusic() {
        player?.play()
        isPlaying = true
    }
    
    func pauseMusic() {
        player?.pause()
        isPlaying = false
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
