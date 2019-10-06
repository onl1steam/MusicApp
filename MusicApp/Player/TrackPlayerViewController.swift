//
//  TrackPlayerViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 05.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class TrackPlayerViewController: UIViewController {
    
    var player : AVPlayer?
    
    // Outlets
    @IBOutlet weak var trackAuthorLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forewardButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var track: Track?
    var isFavorite = false
    var isPlayed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadRadio(radioURL: (track?.previewUrl)!)

        // Track labels
        trackNameLabel.text = track?.trackName
        trackAuthorLabel.text = track?.artistName
        
        // Loading album image
        loadAlbumImage(from: track?.artworkUrl100)
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.volumeDidChange(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func volumeDidChange(notification: NSNotification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        volumeSlider.value = volume
    }
    
    @objc func playerDidFinishPlaying() {
        player?.pause()
        player?.seek(to: .zero)
        isPlayed = false
        animateButtonChange(playButton, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlayed)
    }
    
    func loadRadio(radioURL: String) {
        guard let url = URL.init(string: radioURL) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)    }
    
    // Transfer to Model class
    func loadAlbumImage(from url: String?) {
        guard let urlString = url,
            let url = URL(string: urlString) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }
    
    // Animate System Buttons Change
    func animateButtonChange(_ sender: UIButton, firstImageName: String, secondImageName: String, with flag: Bool) {
        
        var buttonImage: UIImage
        if flag {
            guard let image = UIImage(systemName: firstImageName) else { return }
            buttonImage = image
        } else {
            guard let image = UIImage(systemName: secondImageName)  else { return }
            buttonImage = image
        }
        
        UIView.animate(withDuration: 0.15, animations: {
            sender.alpha = 0.0
        }, completion:{(finished) in
            sender.setBackgroundImage(buttonImage, for: .normal)
            UIView.animate(withDuration: 0.15, animations:{
            sender.alpha = 1.0
            },completion:nil)
        })
    }

    // IBActions:
    @IBAction func addToFavoriteButton(_ sender: UIButton) {
        isFavorite = !isFavorite
        animateButtonChange(sender, firstImageName: "suit.heart.fill", secondImageName: "suit.heart", with: isFavorite)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        isPlayed = !isPlayed
        if isPlayed {
            player?.play()
        } else {
            player?.pause()
        }
        print(isPlayed)
        animateButtonChange(sender, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlayed)
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timeSliderChanged(_ sender: UISlider) {
        let seconds = Double(sender.value)
        let time = CMTime(seconds: seconds, preferredTimescale: 1)
        player?.seek(to: time)
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        MPVolumeView.setVolume(sender.value)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
