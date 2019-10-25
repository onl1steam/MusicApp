//
//  TracksTableViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 20.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.


import UIKit
import RxCocoa
import RxSwift

class TracksTableViewController: UITableViewController {
    
    let cellIdentifier: String = "tracksTableCell"
    var tracks: [Track] = []
    var viewModel: TracksTableViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TracksTableCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    
    func configuteTable(with tracks: [Track]) {
        viewModel = TracksTableViewModel(with: tracks)
        self.tracks = tracks
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TracksTableCell
        cell.configureCell(with: tracks[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
