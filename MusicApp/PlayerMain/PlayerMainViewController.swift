//
//  PlayerMainViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 30.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class PlayerMainViewController: UIViewController {
    
    let musicPlayer: MusicPlayer = MusicPlayerService.shared
    
    // Controllers
    var tracksTableVC: TracksTableViewController {
        get {
            let controller = TracksTableViewController()
            let tracks = musicPlayer.tracks ?? []
            controller.configuteTable(with: tracks)
            controller.view.backgroundColor = .clear
            return controller
        }
    }
    
    var playerVC: PlayerViewController {
        get {
            let controller = PlayerViewController()
            return controller
        }
    }
    
    // Outlets
    
    let dismissButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 25))
        button.setBackgroundImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray5
        button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    let pageControl: UISegmentedControl = {
        let pageControl = UISegmentedControl(items: ["Плеер", "Список"])
        pageControl.selectedSegmentIndex = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(segmentIndexChanged(_:)), for: .valueChanged)
        return pageControl
    }()
    
    var childView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.addChild(tracksTableVC)
        self.addChild(playerVC)

        view.addSubview(dismissButton)
        view.addSubview(pageControl)
        view.addSubview(childView)
        setupConstraints()
        
        self.animationForLoad(parentView: childView, fromVC: tracksTableVC, toVC: playerVC, with: .LeftToRight)
    }
    
    @objc func segmentIndexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            self.animationForLoad(parentView: childView, fromVC: tracksTableVC, toVC: playerVC, with: .LeftToRight)
        case 1:
            let tracks = musicPlayer.tracks ?? []
            tracksTableVC.configuteTable(with: tracks)
            self.animationForLoad(parentView: childView, fromVC: playerVC, toVC: tracksTableVC, with: .RightToLeft)
        default:
            break
        }
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        // Constraint dismiss button
        dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        // Constraint segmented control
        pageControl.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 10)
            .isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Constraint child view
        childView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 40)
            .isActive = true
        childView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
