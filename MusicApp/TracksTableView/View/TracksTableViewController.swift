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
    
    // Header section outlets
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .systemPink
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(playButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    let shuffleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "shuffle"), for: .normal)
        button.tintColor = .systemPink
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(shuffleButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        setupProtocols()
        setupBindings()
        setUpGestures()
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
            self?.viewModel.playTrack(currentIndex: indexPath.row)
        }).disposed(by: disposeBag)
    }

    func configuteTable(with tracks: [Track]) {
        viewModel = TracksTableViewModel(with: tracks)
    }
    
    func changeTracks(to tracks: [Track]) {
        viewModel.changeTracks(to: tracks)
    }
    
    @objc func playButtonTapped(sender: UIButton) {
        viewModel.startPlaying()
    }
    
    @objc func shuffleButtonTapped(sender: UIButton) {
        viewModel.shufflePlaylist()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func setupHeader() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 30

        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(shuffleButton)
        
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(stackView)
        
        
        // Set constraints
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.tableView.tableHeaderView = view
    }
    
    
}
