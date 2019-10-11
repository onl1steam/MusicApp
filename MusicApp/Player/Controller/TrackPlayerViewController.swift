//
//  TrackPlayerViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 05.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import CoreMedia

class TrackPlayerViewController: UIViewController {

    var isFavorite = false
    var delegate: MiniPlayerDelegate?
    
    // Outlets
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forewardButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var favoriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonsUI()
        
        // Track labels
        trackNameLabel.text = MusicPlayerService.shared.track?.trackName ?? "Не исполняется"
        trackArtistLabel.text = MusicPlayerService.shared.track?.artistName ?? ""
        
        // Loading album image
        loadAlbumImage(from: MusicPlayerService.shared.track?.artworkUrl100)
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.volumeDidChange(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func setUpButtonsUI() {
        let isPlaying = MusicPlayerService.shared.isPlaying
        
        if isPlaying {
            guard let image = UIImage(systemName: "pause.fill") else { return }
            playButton.setBackgroundImage(image, for: .normal)
            imageSizeAnimation()
        }
        
        guard let track = MusicPlayerService.shared.track else { return }
        isFavorite = RealmDBManager.shared.isObjectExist(previewUrl: track.previewUrl)
        buttonChange(favoriteButton, firstImageName: "suit.heart.fill", secondImageName: "suit.heart", with: isFavorite)
    }
    
    @objc func volumeDidChange(notification: NSNotification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        volumeSlider.value = volume
    }
    
    @objc func playerDidFinishPlaying() {
        let isPlaying = false
        buttonChange(playButton, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlaying)
    }
    
    // Transfer to Model class
    func loadAlbumImage(from url: String?) {
        guard let urlString = url,
            let url = URL(string: urlString) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }
    
    // Animate System Buttons Change
    func buttonChange(_ sender: UIButton, firstImageName: String, secondImageName: String, with flag: Bool) {
        
        if flag {
            guard let image = UIImage(systemName: firstImageName) else { return }
            sender.setBackgroundImage(image, for: .normal)
        } else {
            guard let image = UIImage(systemName: secondImageName)  else { return }
            sender.setBackgroundImage(image, for: .normal)
        }
    }
    
    // Animate ImageView size increase/decrease
    func imageSizeAnimation() {
        let isPlaying = MusicPlayerService.shared.isPlaying
        
        if isPlaying {
            UIView.animate(withDuration: 0.4, delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 10,
                           options: [.curveEaseOut], animations: {
                            self.albumImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 10,
                           options: [.curveEaseOut], animations: {
                            self.albumImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }

    // IBActions
    @IBAction func addToFavoriteButton(_ sender: UIButton) {
        // Settings
        isFavorite.toggle()
        // Animations
        buttonChange(sender, firstImageName: "suit.heart.fill", secondImageName: "suit.heart", with: isFavorite)
        
        if isFavorite {
            guard let track = MusicPlayerService.shared.track else { return }
            RealmDBManager.shared.saveTrackToBD(track: track)
        } else {
            guard let track = MusicPlayerService.shared.track else { return }
            RealmDBManager.shared.removeFromDB(track: track)
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        // Settings
        MusicPlayerService.shared.toggleMusic()
        let isPlaying = MusicPlayerService.shared.isPlaying
        // Animations
        imageSizeAnimation()
        buttonChange(sender, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlaying)
        delegate?.updateUI()
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timeSliderChanged(_ sender: UISlider) {
        let seconds = Double(sender.value)
        let time = CMTime(seconds: seconds, preferredTimescale: 1)
        MusicPlayerService.shared.seekMusic(to: time)
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        MusicPlayerService.shared.changeVolume(to: sender.value)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
