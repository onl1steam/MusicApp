//
//  TrackSearchTableViewExtension.swift
//  MusicApp
//
//  Created by Рыжков Артем on 13.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

extension TrackSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        configureCellButtonImage(for: cell.addButton, index: indexPath.row)
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func configureCellButtonImage(for button: UIButton, index: Int) {
        
        let localInfo = RealmDBManager.shared.isObjectExistsAndDownloaded(
            previewUrl: trackList[index].previewUrl)
        
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
    
    @objc func addButtonTapped(sender: UIButton) {
        let index = sender.tag
        let localInfo = RealmDBManager.shared.isObjectExistsAndDownloaded(
        previewUrl: trackList[index].previewUrl)
        
        if localInfo.isExists {
            if !localInfo.isDownloaded {
                // TODO: download track and image to File System
            }
        } else {
            RealmDBManager.shared.saveTrackToBD(track: trackList[index])
            configureCellButtonImage(for: sender, index: index)
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicPlayerService.shared.loadTracks(tracks: trackList, currentIndex: indexPath.row)
        MusicPlayerService.shared.playMusic()
        self.childViewController?.updateInformation()
        self.childViewController?.updateUI()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
