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
    @IBOutlet weak var tracksTableView: UITableView!
    let trackCellReuseIdentifier: String = "trackCell"
    var childViewController: MiniPlayerViewController?
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(fetchTracks), for: UIControl.Event.valueChanged)
        refresh.tintColor = .systemPink
        return refresh
    }()
        
    var trackList: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView settings
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        tracksTableView.tableFooterView = UIView()
        
        // Register tableview cell
        tracksTableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: "trackCell")

        // Adding refresh control
        tracksTableView.refreshControl = refreshControl
        
        // Fetch Tracks from DB
        fetchTracks()
    }
    
    
    // MARK: Fetch tracks from Database
    @objc func fetchTracks() {
        refreshControl.beginRefreshing()
        RealmDBManager.shared.fetchTracksFromDB { [weak self] (tracks) in
            guard let fetchedTracks = tracks else { return }
            self?.trackList = fetchedTracks
            if let isRefreshing = self?.refreshControl.isRefreshing,
                isRefreshing {
                self?.refreshControl.endRefreshing()
            }
            self?.tracksTableView.reloadData()
        }
    }
    
    // MARK: Give information in segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == PlaylistControllerTransitions.toMiniPlayer) {
            let childViewController = segue.destination as! MiniPlayerViewController
            self.childViewController = childViewController
        }
    }


}
