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
    let searchController = UISearchController(searchResultsController: nil)
    var childViewController: MiniPlayerViewController?
    var refreshControl = UIRefreshControl()
    
    var trackList: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(fetchTracks), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString()
        refreshControl.tintColor = .systemPink
        tracksTableView.addSubview(refreshControl)
        
        // Register tableview cell
        tracksTableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: "trackCell")
        
        // TableView settings
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        tracksTableView.tableFooterView = UIView()
        
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
