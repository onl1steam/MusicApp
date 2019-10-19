//
//  TableViewExtension.swift
//  MusicApp
//
//  Created by Рыжков Артем on 15.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

// MARK: UITableView extensions
extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tracksTableView.dequeueReusableCell(withIdentifier: trackCellReuseIdentifier, for: indexPath) as! TrackCell
        // Configuring Cells
        cell.trackNameLabel?.text = trackList[indexPath.row].trackName
        cell.trackArtistLabel?.text = trackList[indexPath.row].artistName
        // Loading Album image with SDWebImage
        if let url = URL(string: trackList[indexPath.row].artworkUrl60) {
        cell.trackAlbumImage.sd_setImage(with: url, completed: nil)
        }
        // Configuring cell button
        let localInfo = RealmDBManager.shared.isObjectExistsAndDownloaded(previewUrl: trackList[indexPath.row].previewUrl)
        configureCellButtonImage(for: cell.addButton, index: indexPath.row, localInfo: localInfo)
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: Configuring button image in table view cell
    func configureCellButtonImage(for button: UIButton, index: Int, localInfo: (isExists: Bool, isDownloaded: Bool)) {
        
        if localInfo.isExists {
            if localInfo.isDownloaded {
                button.setBackgroundImage(UIImage(), for: .normal)
            } else {
                let image = UIImage(systemName: "icloud.and.arrow.down")!
                button.setBackgroundImage(image, for: .normal)
            }
        } else {
            let image = UIImage(systemName: "plus")!
            button.setBackgroundImage(image, for: .normal)
        }
    }
    
    // MARK: Gesture recognizer to cell button
    @objc func addButtonTapped(sender: UIButton) {
        let index = sender.tag
        let localInfo = RealmDBManager.shared.isObjectExistsAndDownloaded(
        previewUrl: trackList[index].previewUrl)
        
        if localInfo.isExists {
            if !localInfo.isDownloaded {
                TrackService.shared.downloadTrackToMemomy(track: trackList[index])
                configureCellButtonImage(for: sender, index: index, localInfo: (true, true))
            }
        } else {
            RealmDBManager.shared.saveTrackToBD(track: trackList[index])
            configureCellButtonImage(for: sender, index: index, localInfo: (true, false))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicPlayerService.shared.loadTracks(tracks: trackList, currentIndex: indexPath.row)
        MusicPlayerService.shared.initializePlayer()
        MusicPlayerService.shared.playMusic()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

