//
//  FindTrackViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 04.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import SDWebImage

class TrackSearchViewController: UIViewController {
    
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tracksTableView: UITableView!
    let trackCellReuseIdentifier: String = "trackCell"
    let searchController = UISearchController(searchResultsController: nil)
    var childViewController: MiniPlayerViewController?
    
    var trackList: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tableview cell
        tracksTableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: "trackCell")
        
        setupSearchBar()
        
        // Setting up status bar
        
        // Activity Indicator settings
        self.tableViewActivityIndicator.isHidden = true
        tableViewActivityIndicator.color = .systemRed

        // TableView settings
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        tracksTableView.tableFooterView = UIView()
    }
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.searchTextField.textColor = .label
        
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.systemPink]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
    }
    
    func requestForTracks(with searchTerm: String) {
        // Updating views
        self.trackList = []
        self.tracksTableView.reloadData()
        self.tableViewActivityIndicator.isHidden = false
        self.tableViewActivityIndicator.startAnimating()
        
        TrackService.shared.findTracksRequest(searchTerm: searchTerm) { [weak self] (tracks) in
            guard let tracks = tracks else { return }
            // Updating track list
            self?.trackList = tracks
            // TableView reloading
            self?.tracksTableView.reloadData()
            // Activity Indicator state change
            self?.tableViewActivityIndicator.stopAnimating()
            self?.tableViewActivityIndicator.isHidden = true
        }
    }
    
    // Set up child view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SearchControllerTransitions.toMiniPlayer) {
            let childViewController = segue.destination as! MiniPlayerViewController
            self.childViewController = childViewController
        }
    }

}
