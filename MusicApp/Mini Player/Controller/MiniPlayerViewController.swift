//
//  MiniPlayerViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 07.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import SDWebImage

class MiniPlayerViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var albumImageView: RoundedImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestureRecognizer()
        updateInformation()
    }
    
    // MARK: Adding gesture recognizer
    func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    // MARK: Handle tap gesture on mini player
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let trackPlayerViewController: TrackPlayerViewController = TrackPlayerViewController()
        trackPlayerViewController.delegate = self
        self.present(trackPlayerViewController, animated: true, completion: nil)
    }
    
    // MARK: Load album image from url
    func loadAlbumImage(from url: String?) {
        guard let string = url,
            let url = URL(string: string) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: IBActions
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if MusicPlayerService.shared.tracks != nil {
            // Settings
            MusicPlayerService.shared.toggleMusic()
            let isPlaying = MusicPlayerService.shared.isPlaying
            // Animations
            sender.changeSystemButton(firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlaying)
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        if MusicPlayerService.shared.tracks != nil {
            MusicPlayerService.shared.setNext()
            updateInformation()
        }
    }
    
}

// MARK: Delegate extension
extension MiniPlayerViewController: MiniPlayerDelegate {
    
    func updateUI() {
        let isPlaying = MusicPlayerService.shared.isPlaying
        
        if isPlaying {
            guard let image = UIImage(systemName: "pause.fill") else { return }
            playButton.setBackgroundImage(image, for: .normal)
        } else {
            guard let image = UIImage(systemName: "play.fill") else { return }
            playButton.setBackgroundImage(image, for: .normal)
        }
    }
    
    func updateInformation() {
        guard let track = MusicPlayerService.shared.currentTrack else { return }
        trackNameLabel.text = track.trackName
        loadAlbumImage(from: track.artworkUrl60)
    }
    
}
