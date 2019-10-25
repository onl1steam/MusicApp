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
    
    // MARK: IBOutlets, properties
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tracksTableView: UIView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var tracksTableViewController: TracksTableViewController?
    
    var tracks: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = TracksTableViewController()
        tracksTableViewController = controller
        controller.configuteTable(with: tracks)
        self.add(asChildViewController: controller, to: tracksTableView)
        
        setupSearchBar()
        
        // Activity Indicator settings
        self.tableViewActivityIndicator.isHidden = true
        tableViewActivityIndicator.color = .systemRed

    }
    
    // MARK: Setting up search bar
    func setupSearchBar() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.textColor = .label
        
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.systemPink]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
    }
    
    // MARK: Requesting for tracks
    func requestForTracks(with searchTerm: String) {
        // Updating views
        self.tableViewActivityIndicator.isHidden = false
        self.tableViewActivityIndicator.startAnimating()
        
        TrackService.shared.fetchTracks(searchTerm: searchTerm) { [weak self] (tracks) in
            guard let tracks = tracks else { return }
            // Updating track list
            self?.tracksTableViewController?.changeTracks(to: tracks)
            // Activity Indicator state change
            self?.tableViewActivityIndicator.stopAnimating()
            self?.tableViewActivityIndicator.isHidden = true
        }
    }

}
