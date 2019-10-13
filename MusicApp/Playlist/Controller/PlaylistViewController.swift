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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MusicPlayerService.shared.loadTracks(tracks: trackList, currentIndex: indexPath.row)
        self.childViewController?.updateInformation()
        self.childViewController?.updateUI()
        MusicPlayerService.shared.initializePlayer()
        MusicPlayerService.shared.playMusic()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
