//
//  MiniPlayerViewModel.swift
//  MusicApp
//
//  Created by Рыжков Артем on 19.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RxSwift

class MiniPlayerViewModel {
    
    var trackName = BehaviorSubject<String>(value: "Не исполняется")
    var isPlaying = BehaviorSubject<Bool>(value: false)
    var albumImage = BehaviorSubject<Data>(value: Data())
    
    let disposeBag = DisposeBag()
    
    init() {
        addObservers()
    }
    
    private func addObservers() {
        MusicPlayerService.shared.currentTrack.subscribe(onNext: { [weak self] (track) in
            self?.updateTrackInformation(currentTrack: track)
        }).disposed(by: disposeBag)
        MusicPlayerService.shared.isPlaying.subscribe(onNext: { [weak self] (playing) in
            self?.isPlaying.onNext(playing)
        }).disposed(by: disposeBag)
    }
    
    private func updateTrackInformation(currentTrack: Track?) {
        guard let track = currentTrack?.trackName,
            let artworkUrl60 = currentTrack?.artworkUrl60
            else { return }
        
        trackName.onNext(track)
        
        // Sending Data in model
        ImageLoader.getImageData(from: artworkUrl60) { [weak self] (imageData) in
            self?.albumImage.onNext(imageData)
        }
    }
    
    func playMusic() {
        // Settings
        MusicPlayerService.shared.toggleMusic()
    }
    
    func playForward() {
        MusicPlayerService.shared.setNext()
    }
    
}
