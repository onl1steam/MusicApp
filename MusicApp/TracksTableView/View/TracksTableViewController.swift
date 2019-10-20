//
//  TracksTableViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 20.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TracksTableViewController: UITableViewController {
    
    let cellIdentifier: String = "trackCell"
    var viewModel: TracksTableViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.tracks.bind(to: self.tableView.rx.items(cellIdentifier: cellIdentifier,
                                                           cellType: TrackCell.self)) {
            row, model, cell in
            // Configuring Cells
            cell.trackNameLabel.text = model.trackName
            cell.trackArtistLabel.text = model.artistName
            // Loading Album image with SDWebImage
            if let url = URL(string: model.artworkUrl60) {
                cell.trackAlbumImage.sd_setImage(with: url, completed: nil)
            }
           // Configuring cell button
//            let localInfo = RealmDBManager.shared.isObjectExistsAndDownloaded(previewUrl: model.previewUrl)
//            configureCellButtonImage(for: cell.addButton, index: row, localInfo: localInfo)
//            cell.addButton.tag = row
//            cell.addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        }.disposed(by: disposeBag)
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
