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
    var isPlaying = false
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    static let shared = MusicPlayerService()
    
    @objc func playerDidFinishPlaying() {
        MusicPlayerService.shared.pauseMusic()
        MusicPlayerService.shared.seekMusic(to: .zero)
        MusicPlayerService.shared.isPlaying = false
    }
    
    func loadTrack(track: Track) {
        isPlaying = false
        self.track = track
        guard let url = URL.init(string: track.previewUrl) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
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
