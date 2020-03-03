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
    
    let musicPlayer: MusicPlayer = MusicPlayerService.shared
    let imageLoader: ImageLoader = ImageLoadService()
    
    let trackName = BehaviorSubject<String>(value: "Не исполняется")
    let artistName = BehaviorSubject<String>(value: "")
    let isPlaying = BehaviorSubject<Bool>(value: false)
    let albumImage = BehaviorSubject<Data>(value: Data())
    let volume = BehaviorSubject<Float>(value: 0)
    let currentTime = BehaviorSubject<Float>(value: 0)
    let duration = BehaviorSubject<Float>(value: 0)
    let currentTimeString = BehaviorSubject<String>(value: "--:--")
    let remainingTimeString = BehaviorSubject<String>(value: "--:--")
    
    var timer = Timer()
    var sliderTapTimer: Timer? = nil
    let disposeBag = DisposeBag()
    
    init() {
        // Updating system volume
        let vol = AVAudioSession.sharedInstance().outputVolume
        volume.onNext(vol)
        
        updateSlider()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(volumeDidChange(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        
        musicPlayer.currentTrack.subscribe(onNext: { [weak self] (track) in
            self?.updateTrackInformation(currentTrack: track)
        }).disposed(by: disposeBag)
        
        musicPlayer.isPlaying.subscribe(onNext: { [weak self] (playing) in
            self?.isPlaying.onNext(playing)
        }).disposed(by: disposeBag)
    }
    
    private func updateTrackInformation(currentTrack: Track?) {
        guard let track = currentTrack?.trackName,
            let artist = currentTrack?.artistName,
            let artworkUrl100 = currentTrack?.artworkUrl100
            else { return }
        
        let trackDuration = musicPlayer.trackDuration
        
        trackName.onNext(track)
        artistName.onNext(artist)
        if !trackDuration.isNaN {
            duration.onNext(trackDuration)
        }
        
        // Sending Data in model
        imageLoader.getImageData(from: artworkUrl100) { [weak self] (imageData) in
            self?.albumImage.onNext(imageData)
        }
    }

    func playMusic() {
        musicPlayer.toggleMusic()
    }
    
    func playBackward() {
        musicPlayer.setPrevious()
    }
    
    func playForward() {
        musicPlayer.setNext()
    }
    
    func changeVolume(to value: Float) {
        musicPlayer.changeVolume(to: value)
    }
    
    func seekMusic(to value: Float) {
        updateTimeLabels(time: value)
        debounce(seconds: 0.3) { [unowned self] in
            let time = value.convertToCMTime()
            
            self.musicPlayer.seekMusic(to: time, completion: {
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                self.updateSlider()
            })
            
        }
    }
    
    @objc private func updateSlider() {
        let time = musicPlayer.currentTime
        currentTime.onNext(time)
        updateTimeLabels(time: time)
    }
    
    private func updateTimeLabels(time: Float) {
        var duration = musicPlayer.trackDuration
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
