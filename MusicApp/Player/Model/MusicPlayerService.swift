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
    
    var tracks: [Track]?
    private var player : AVPlayer?
    var isPlaying = false
    var currentIndex = 0
    var currentTrack: Track? {
        return tracks?[currentIndex]
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    static let shared = MusicPlayerService()
    
    @objc func playerDidFinishPlaying() {
        MusicPlayerService.shared.pauseMusic()
        MusicPlayerService.shared.seekMusic(to: .zero)
        MusicPlayerService.shared.isPlaying = false
    }
    
    func loadTracks(tracks: [Track], currentIndex: Int) {
        isPlaying = false
        self.currentIndex = currentIndex
        self.tracks = tracks
        guard let url = URL.init(string: tracks[currentIndex].previewUrl) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
    }
    
    private func skipTrack() {
        guard let trackUrl = tracks?[currentIndex].previewUrl,
            let url = URL.init(string: trackUrl) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        if isPlaying {
            player?.play()
        }
    }
    
    func setNext() {
        if let count = tracks?.count,
            currentIndex < count - 1 {
            currentIndex += 1
            skipTrack()
        }
    }
    
    func setPrevious() {
        if let time = player?.currentTime().seconds,
            time > 5 {
            seekMusic(to: .zero)
            return
        }
        
        if let count = tracks?.count,
            count > 0,
            currentIndex > 0 {
            currentIndex -= 1
            skipTrack()
        }
    }
    
    func toggleMusic() {
        isPlaying.toggle()
        if isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func changeVolume(to value: Float) {
        MPVolumeView.setVolume(value)
    }
    
    func playMusic() {
        player?.play()
        isPlaying = true
    }
    
    func pauseMusic() {
        player?.pause()
        isPlaying = false
    }
    
    func seekMusic(to time: CMTime) {
        player?.seek(to: time)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
