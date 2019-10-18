//
//  PlayerViewModel.swift
//  MusicApp
//
//  Created by Рыжков Артем on 18.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RxSwift

// TODO: Update album image

class PlayerViewModel {
    
    var trackName = BehaviorSubject<String>(value: "Не исполняется")
    var artistName = BehaviorSubject<String>(value: "String")
    var isPlaying = BehaviorSubject<Bool>(value: false)
    var artworkUrl100 = PublishSubject<String>()
    var volume = BehaviorSubject<Float>(value: 0)
    
    init() {
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(volumeDidChange(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func updateTrackInformation() {
        guard let track = MusicPlayerService.shared.currentTrack?.trackName,
            let artist = MusicPlayerService.shared.currentTrack?.artistName,
            let artworkUrl = MusicPlayerService.shared.currentTrack?.artworkUrl100
            else { return }
        
        trackName.onNext(track)
        artistName.onNext(artist)
        artworkUrl100.onNext(artworkUrl)
    }

    func playMusic() {
        if MusicPlayerService.shared.tracks != nil {
            // Settings
            MusicPlayerService.shared.toggleMusic()
            // Update UI
            let isPlaying = MusicPlayerService.shared.isPlaying
            self.isPlaying.onNext(isPlaying)
        }
    }
    
    func playBackward() {
        if MusicPlayerService.shared.tracks != nil {
            MusicPlayerService.shared.setPrevious()
            // Update UI
            updateTrackInformation()
        }
    }
    
    func playForward() {
        if MusicPlayerService.shared.tracks != nil {
            MusicPlayerService.shared.setNext()
            // Update UI
            updateTrackInformation()
        }
    }
    
    func changeVolume(to value: Float) {
        MusicPlayerService.shared.changeVolume(to: value)
    }
    
    func seekMusic(to value: Float) {
        let time = value.convertToCMTime()
        MusicPlayerService.shared.seekMusic(to: time)
    }
    
    // MARK: Observing system volume changing
    @objc func volumeDidChange(notification: NSNotification) {
        let value = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        volume.onNext(value)
    }
    
    // MARK: Observing ending of track
    @objc func playerDidFinishPlaying() {
        isPlaying.onNext(false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
