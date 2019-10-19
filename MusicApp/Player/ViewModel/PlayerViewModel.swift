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
    
    var timer = Timer()
    var sliderTapTimer: Timer? = nil
    let disposeBag = DisposeBag()
    
    init() {
        
        // Updating system volume
        let vol = AVAudioSession.sharedInstance().outputVolume
        volume.onNext(vol)
        
        // Update slider and labels
        updateSlider()
        
        // Set timer for current time
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(volumeDidChange(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        MusicPlayerService.shared.currentTrack.subscribe(onNext: { [weak self] (track) in
            self?.updateTrackInformation(currentTrack: track)
        }).disposed(by: disposeBag)
    }
    
    private func updateTrackInformation(currentTrack: Track?) {
        guard let track = currentTrack?.trackName,
            let artist = currentTrack?.artistName,
            let artworkUrl100 = currentTrack?.artworkUrl100
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
        ImageLoader.getImageData(from: artworkUrl100) { [weak self] (imageData) in
            self?.albumImage.onNext(imageData)
        }
    }

    func playMusic() {
        // Settings
        MusicPlayerService.shared.toggleMusic()
        // Update UI
        let isPlaying = MusicPlayerService.shared.isPlaying
        self.isPlaying.onNext(isPlaying)
    }
    
    func playBackward() {
        MusicPlayerService.shared.setPrevious()
    }
    
    func playForward() {
        MusicPlayerService.shared.setNext()
    }
    
    func changeVolume(to value: Float) {
        MusicPlayerService.shared.changeVolume(to: value)
    }
    
    func seekMusic(to value: Float) {
        updateTimeLabels(time: value)
        debounce(seconds: 0.3) { [unowned self] in
            let time = value.convertToCMTime()
            MusicPlayerService.shared.seekMusic(to: time, completion: {
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                self.updateSlider()
            })
        }
    }
    
    @objc private func updateSlider() {
        let time = MusicPlayerService.shared.currentTime
        currentTime.onNext(time)
        updateTimeLabels(time: time)
    }
    
    private func updateTimeLabels(time: Float) {
        var duration = MusicPlayerService.shared.trackDuration
        if duration.isNaN {
            duration = 30.0
        }
        let remainingTime = duration - time
        
        currentTimeString.onNext(time.convertToTimeString())
        remainingTimeString.onNext("-\(remainingTime.convertToTimeString())")
    }
    
    func timeSliderBeginEditing() {
        timer.invalidate()
    }
    
    private func debounce(seconds: TimeInterval, function: @escaping () -> Void ) {
        sliderTapTimer?.invalidate()
        sliderTapTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            function()
        })
    }
    
    // MARK: Observing system volume changing
    @objc func volumeDidChange(notification: NSNotification) {
        let value = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        volume.onNext(value)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
