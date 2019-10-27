//
//  FindTrackViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 04.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class TrackSearchViewController: UIViewController {
    
    // MARK: IBOutlets, properties
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tracksTableView: UIView!
    let searchController = UISearchController(searchResultsController: nil)
    var tracksTableViewController: TracksTableViewController?
    
    let viewModel = TrackSearchViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        let controller = TracksTableViewController()
        tracksTableViewController = controller
        setupBindings()
        self.add(asChildViewController: controller, to: tracksTableView)
        
        // Activity Indicator settings
        tableViewActivityIndicator.color = .systemRed
    }
    
    private func setupBindings() {
        tracksTableViewController?.configuteTable(with: [])
        
        viewModel.trackList.subscribe(onNext: { [weak self] (tracks) in
            self?.tracksTableViewController?.changeTracks(to: tracks)
        }).disposed(by: disposeBag)
        
        searchController.searchBar
            .rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                if query == "" {
                    self?.viewModel.clearScreen()
                } else {
                    self?.viewModel.requestForTracks(with: query)
                }
        }).disposed(by: disposeBag)
        
        viewModel.isAnimating.subscribe(onNext: { [weak self] (state) in
            self?.tableViewActivityIndicator.isHidden = !state
            if state {
                self?.tableViewActivityIndicator.startAnimating()
            } else {
                self?.tableViewActivityIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
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

}
