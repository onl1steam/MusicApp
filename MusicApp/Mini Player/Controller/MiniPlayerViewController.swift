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

    @IBOutlet weak var albumImageView: RoundedImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var border = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTopBorder(with: 0.7)
        
        addGestureRecognizer()
        
        updateInformation()
    }
    
    
    func addTopBorder(with borderWidth: CGFloat) {
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: borderWidth)
        self.view.addSubview(border)
    }
    
    func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let trackPlayerViewController: TrackPlayerViewController = TrackPlayerViewController()
        trackPlayerViewController.delegate = self
        self.present(trackPlayerViewController, animated: true, completion: nil)
    }
    
    func loadAlbumImage(from url: String?) {
        guard let string = url,
            let url = URL(string: string) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }
    
    func updateInformation() {
        guard let track = MusicPlayerService.shared.track else { return }
        
        loadAlbumImage(from: track.artworkUrl60)
        trackNameLabel.text = track.trackName
        updateUI()
    }
    
    func buttonChange(_ sender: UIButton, firstImageName: String, secondImageName: String, with flag: Bool) {

        if flag {
            guard let image = UIImage(systemName: firstImageName) else { return }
             sender.setBackgroundImage(image, for: .normal)
        } else {
            guard let image = UIImage(systemName: secondImageName)  else { return }
             sender.setBackgroundImage(image, for: .normal)
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        // Settings
        MusicPlayerService.shared.toggleMusic()
        let isPlaying = MusicPlayerService.shared.isPlaying
        // Animations
        buttonChange(sender, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlaying)
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
    }
    
}

// Delegate extension
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
    
}
