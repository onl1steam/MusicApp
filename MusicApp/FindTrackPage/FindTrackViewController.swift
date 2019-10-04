//
//  FindTrackViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 04.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class FindTrackViewController: UIViewController {
    
    @IBOutlet weak var tracksTableView: UITableView!
    let trackCellReuseIdentifier: String = "trackCell"
    var viewModel = FindTrackViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        tracksTableView.tableFooterView = UIView()
    }


}

extension FindTrackViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tracksTableView.dequeueReusableCell(withIdentifier: trackCellReuseIdentifier, for: indexPath) as! TrackCell
        cell.trackNameLabel?.text = "NBA"
        cell.trackAuthorLabel?.text = "RSAC X ELLA"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
