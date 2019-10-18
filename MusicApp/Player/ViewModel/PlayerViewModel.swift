//
//  PlayerViewModel.swift
//  MusicApp
//
//  Created by Рыжков Артем on 18.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RxSwift
import SDWebImage
import AVFoundation

// TODO: Update album image

class PlayerViewModel {
    
    var trackName = BehaviorSubject<String>(value: "Не исполняется")
    var artistName = BehaviorSubject<String>(value: "")
    var isPlaying = BehaviorSubject<Bool>(value: false)
    var albumImage = BehaviorSubject<Data>(value: Data())
    var volume = BehaviorSubject<Float>(value: 0)
    var currentTime = BehaviorSubject<Float>(value: 0)
    var duration = BehaviorSubject<Float>(value: 0)
    var currentTimeString = BehaviorSubject<String>(value: "--:--")
    var remainingTimeString = BehaviorSubject<String>(value: "--:--")
    
    init() {
        // Trying to load information from player
        updateTrackInformation()
        
        // Updating system volume
        let vol = AVAudioSession.sharedInstance().outputVolume
        volume.onNext(vol)
        
        // Update slider and labels
        updateSlider()
        
        // Set timer for current time
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(volumeDidChange(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func updateTrackInformation() {
        guard let track = MusicPlayerService.shared.currentTrack?.trackName,
            let artist = MusicPlayerService.shared.currentTrack?.artistName,
            let artworkUrl100 = MusicPlayerService.shared.currentTrack?.artworkUrl100
            else { return }
        
        let playing = MusicPlayerService.shared.isPlaying
        let trackDuration = MusicPlayerService.shared.trackDuration
        
        isPlaying.onNext(playing)
        trackName.onNext(track)
        artistName.onNext(artist)
        if !trackDuration.isNaN {
            duration.onNext(trackDuration)
        }
        
        // Sending Data in model
        SDWebImageManager.shared.loadImage(with: URL(string: artworkUrl100)!,
                                           options: .continueInBackground,
                                           context: nil, progress: nil) { [weak self]
            (image, data, error, cacheType, bool, url) in
            guard let imageData = image?.sd_imageData() else { return }
            self?.albumImage.onNext(imageData)
        }
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
        updateSlider()
    }
    
    @objc private func updateSlider() {
        let time = MusicPlayerService.shared.currentTime
        let duration = MusicPlayerService.shared.trackDuration
        let remainingTime = duration - time
        
        currentTimeString.onNext(time.convertToTimeString())
        remainingTimeString.onNext("-\(remainingTime.convertToTimeString())")
        currentTime.onNext(time)
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
