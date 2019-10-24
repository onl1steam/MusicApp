//
//  TracksTableCellViewModel.swift
//  MusicApp
//
//  Created by Рыжков Артем on 24.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RxSwift

class TracksTableCellViewModel {
    
    var track: Track
    var trackName = PublishSubject<String>()
    var trackArtist = PublishSubject<String>()
    var trackAlbum = PublishSubject<Data>()
//    var addButton = PublishSubject<Data>()
    
    init(track: Track) {
        self.track = track
        trackName.onNext(track.trackName)
        trackArtist.onNext(track.artistName)
        ImageLoader.getImageData(from: track.artworkUrl60) { [weak self] (data) in
            self?.trackAlbum.onNext(data)
        }
    }
    
    
}

