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
    let cellNibName: String = "TracksTableCell"
    var viewModel: TracksTableViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
        setUpGestures()
        setupProtocols()
        setupBindings()
    }
    
    private func setupProtocols() {
        self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setUpGestures() {
        let tapGesture = UILongPressGestureRecognizer()
        tapGesture.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { recognizer in
            if recognizer.state == .began {
                let touchPoint = recognizer.location(in: self.tableView)
                if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                    let trackAlert = TrackAlertController(with: self.viewModel.tracks.value[indexPath.row])
                    self.present(trackAlert.alertContoller, animated: true, completion: nil)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        viewModel.tracks.bind(to: self.tableView.rx.items(cellIdentifier: cellIdentifier, cellType: TracksTableCell.self)) {  (row,track,cell) in
            cell.configureCell(with: track)
            }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
        .subscribe(onNext: { [weak self] indexPath in
            self?.viewModel.loadTracks(currentIndex: indexPath.row)
        }).disposed(by: disposeBag)
    }

    func configuteTable(with tracks: [Track]) {
        viewModel = TracksTableViewModel(with: tracks)
    }
    
    func changeTracks(to tracks: [Track]) {
        viewModel.changeTracks(to: tracks)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
