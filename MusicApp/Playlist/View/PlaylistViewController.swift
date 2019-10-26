//
//  PlaylistViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 08.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlaylistViewController: UIViewController {

    // MARK: Outlets, variables
    @IBOutlet weak var tracksTableView: UIView!
    
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateTracks), for: UIControl.Event.valueChanged)
        refresh.tintColor = .systemPink
        return refresh
    }()
    var tracksTableViewController: TracksTableViewController?
    let viewModel = PlaylistViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = TracksTableViewController()
        tracksTableViewController = controller
        setupBindings()
        self.add(asChildViewController: controller, to: tracksTableView)
        
        // Fetch Tracks from DB
        viewModel.fetchTracks()
        tracksTableViewController?.tableView.refreshControl = refreshControl
    }
    
    private func setupBindings() {
        tracksTableViewController?.configuteTable(with: [])
        
        viewModel.trackList.subscribe(onNext: { [weak self] (tracks) in
            self?.tracksTableViewController?.changeTracks(to: tracks)
        }).disposed(by: disposeBag)
        
        viewModel.isAnimating.subscribe(onNext: { [weak self] (state) in
            self?.refreshControl.isHidden = !state
            if state {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func updateTracks() {
        viewModel.fetchTracks() 
    }
}
