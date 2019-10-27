//
//  TrackActionSheet.swift
//  MusicApp
//
//  Created by Рыжков Артем on 27.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TrackAlertController {
    
    var viewModel: TrackAlertViewModel!
    
    let alertContoller = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)

    init(with track: Track) {
        viewModel = TrackAlertViewModel(with: track)
        
        if viewModel.deleteFromFileManager {
            alertContoller.addAction(UIAlertAction(title: "Удалить из памяти", style: .destructive,
            handler: { action in
            self.viewModel.deleteTrackFromFileManager() }))
        }
        if viewModel.deleteFromDB {
            alertContoller.addAction(UIAlertAction(title: "Удалить из плейлиста", style: .destructive,
            handler: { action in
            self.viewModel.deleteTrackFromPlaylist() }))
        }
        if viewModel.saveToFileManager {
            alertContoller.addAction(UIAlertAction(title: "Сохранить в память", style: .default, handler: { action in
                self.viewModel.saveTrackToFileManager() }))
        }
        if viewModel.saveToPlaylist {
            alertContoller.addAction(UIAlertAction(title: "Сохранить в плейлист", style: .default,
            handler: { action in
                self.viewModel.saveTrackToPlaylist() }))
        }
        alertContoller.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
    }
    
}
