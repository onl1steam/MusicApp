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
    @IBOutlet weak var trackAuthorLabel: UILabel!
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
        trackNameLabel.text = MusicPlayerService.shared.track?.trackName
        trackAuthorLabel.text = MusicPlayerService.shared.track?.artistName
        
        // Loading album image
        loadAlbumImage(from: MusicPlayerService.shared.track?.artworkUrl100)
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.volumeDidChange(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func setUpButtonsUI() {
        let isPlayed = MusicPlayerService.shared.isPlayed
        
        if isPlayed {
            guard let image = UIImage(systemName: "pause.fill") else { return }
            playButton.setBackgroundImage(image, for: .normal)
            imageSizeAnimation()
        }
    }
    
    @objc func volumeDidChange(notification: NSNotification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        volumeSlider.value = volume
    }
    
    @objc func playerDidFinishPlaying() {
        MusicPlayerService.shared.pauseMusic()
        MusicPlayerService.shared.seekMusic(to: .zero)
        MusicPlayerService.shared.isPlayed = false
        let isPlayed = false
        fadeAnimationButtonChange(playButton, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlayed)
    }
    
    // Transfer to Model class
    func loadAlbumImage(from url: String?) {
        guard let urlString = url,
            let url = URL(string: urlString) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }
    
    // Animate System Buttons Change
    func fadeAnimationButtonChange(_ sender: UIButton, firstImageName: String, secondImageName: String, with flag: Bool) {
        
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
            }, completion:nil)
        })
    }
    
    // Animate ImageView size increase/decrease
    func imageSizeAnimation() {
        let isPlayed = MusicPlayerService.shared.isPlayed
        
        if isPlayed {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.albumImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.albumImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }

    // IBActions
    @IBAction func addToFavoriteButton(_ sender: UIButton) {
        // Settings
        isFavorite.toggle()
        // Animations
        fadeAnimationButtonChange(sender, firstImageName: "suit.heart.fill", secondImageName: "suit.heart", with: isFavorite)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        // Settings
        MusicPlayerService.shared.toggleMusic()
        let isPlayed = MusicPlayerService.shared.isPlayed
        // Animations
        imageSizeAnimation()
        fadeAnimationButtonChange(sender, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlayed)
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
