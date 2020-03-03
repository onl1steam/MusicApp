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
    
    let track: Track
    let trackName = BehaviorSubject<String>(value: "")
    let trackArtist = BehaviorSubject<String>(value: "")
    let albumImage = BehaviorSubject<Data>(value: Data())
    let addButtonImage = BehaviorSubject<Data>(value: Data())
    
    let imageLoader: ImageLoader = ImageLoadService()
    let dbService: DBService = RealmDBService.shared
    
    init(track: Track) {
        self.track = track
        trackName.onNext(track.trackName)
        trackArtist.onNext(track.artistName)
        imageLoader.getImageData(from: track.artworkUrl60) { [weak self] (data) in
            self?.albumImage.onNext(data)
        }
        let localInfo = dbService.isObjectExistsAndDownloaded(previewUrl: track.previewUrl)
        changeCellButtonImage(localInfo: localInfo)
    }
    
    private func changeCellButtonImage(localInfo: (isExists: Bool, isDownloaded: Bool)) {
        var data: Data?
        if localInfo.isExists {
            if localInfo.isDownloaded {
            } else {
                let image = UIImage(systemName: "icloud.and.arrow.down")!
                data = image.withTintColor(.systemPink).pngData()
            }
        } else {
            let image = UIImage(systemName: "plus")!
            data = image.withTintColor(.systemPink).pngData()
        }
        guard let imageData = data else {
            addButtonImage.onNext(Data())
            return
        }
        addButtonImage.onNext(imageData)
    }
    
    func addTrackToDB() {
        let localInfo = dbService.isObjectExistsAndDownloaded(
        previewUrl: track.previewUrl)
        
        if localInfo.isExists {
            if !localInfo.isDownloaded {
                FileManagerControlService.downloadTrackToMemomy(track: track)
                changeCellButtonImage(localInfo: (true, true))
            }
        } else {
            dbService.saveTrack(track: track)
            changeCellButtonImage(localInfo: (true, false))
        }
    }
    
    
}

