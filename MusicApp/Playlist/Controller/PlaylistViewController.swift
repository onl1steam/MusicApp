//
//  PlaylistViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 08.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {

    // MARK: Outlets, variables
    @IBOutlet weak var tracksTableView: UIView!
    let trackCellReuseIdentifier: String = "trackCell"
    
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchTracks), for: UIControl.Event.valueChanged)
        refresh.tintColor = .systemPink
        return refresh
    }()
    var tracksTableViewController: TracksTableViewController?
    var tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = TracksTableViewController()
        tracksTableViewController = controller
        controller.configuteTable(with: tracks)
        self.add(asChildViewController: controller, to: tracksTableView)

        // Adding refresh control
        tracksTableViewController?.tableView.refreshControl = refreshControl
        
        // Fetch Tracks from DB
        fetchTracks()
    }
    
    
    // MARK: Fetch tracks from Database
    @objc func fetchTracks() {
        refreshControl.beginRefreshing()
        RealmDBManager.shared.fetchTracks { [weak self] (tracks) in
            guard let fetchedTracks = tracks else { return }
            if let isRefreshing = self?.refreshControl.isRefreshing,
                isRefreshing {
                self?.refreshControl.endRefreshing()
            }
            self?.tracksTableViewController?.changeTracks(to: fetchedTracks)
        }
    }
}
