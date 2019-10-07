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
    
    var track: Track?
    private var player : AVPlayer?
    var isPlayed = false
    
    private init() {}
    
    static let shared = MusicPlayerService()
    
    func loadTrack(track: Track) {
        isPlayed = false
        self.track = track
        guard let url = URL.init(string: track.previewUrl) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
    }
    
    func toggleMusic() {
        isPlayed.toggle()
        if isPlayed {
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
    }
    
    func pauseMusic() {
        player?.pause()
    }
    
    func seekMusic(to time: CMTime) {
        player?.seek(to: time)
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
