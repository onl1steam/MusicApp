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
    
    // MARK: Outlets
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumImageView: RoundedImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forewardButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var favoriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonsUI()
        
        // Loading Track information
        loadTrackInformation()
        
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
        
        guard let track = MusicPlayerService.shared.currentTrack else { return }
        isFavorite = RealmDBManager.shared.isObjectExistsAndDownloaded(previewUrl: track.previewUrl).isExists
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
    
    // MARK: Transfer to Model class
    func loadTrackInformation() {
        trackNameLabel.text = MusicPlayerService.shared.currentTrack?.trackName ?? "Не исполняется"
        trackArtistLabel.text = MusicPlayerService.shared.currentTrack?.artistName ?? ""
        
        guard let urlString = MusicPlayerService.shared.currentTrack?.artworkUrl100,
            let url = URL(string: urlString) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: Animate System Buttons Change
    func buttonChange(_ sender: UIButton, firstImageName: String, secondImageName: String, with flag: Bool) {
        
        if flag {
            guard let image = UIImage(systemName: firstImageName) else { return }
            sender.setBackgroundImage(image, for: .normal)
        } else {
            guard let image = UIImage(systemName: secondImageName)  else { return }
            sender.setBackgroundImage(image, for: .normal)
        }
    }
    
    // MARK: Animate ImageView size increase/decrease
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

    // MARK: IBActions
    @IBAction func addToFavoriteButton(_ sender: UIButton) {
        if MusicPlayerService.shared.tracks != nil {
            // Settings
            isFavorite.toggle()
            // Animations
            buttonChange(sender, firstImageName: "suit.heart.fill", secondImageName: "suit.heart", with: isFavorite)
            
            if isFavorite {
                guard let track = MusicPlayerService.shared.currentTrack else { return }
                RealmDBManager.shared.saveTrackToBD(track: track)
            } else {
                guard let track = MusicPlayerService.shared.currentTrack else { return }
                RealmDBManager.shared.removeFromDB(track: track)
            }
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if MusicPlayerService.shared.tracks != nil {
            // Settings
            MusicPlayerService.shared.toggleMusic()
            let isPlaying = MusicPlayerService.shared.isPlaying
            // Animations
            imageSizeAnimation()
            buttonChange(sender, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlaying)
            delegate?.updateUI()
        }
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        if MusicPlayerService.shared.tracks != nil {
            MusicPlayerService.shared.setPrevious()
            loadTrackInformation()
            delegate?.updateInformation()
            setUpButtonsUI()
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        if MusicPlayerService.shared.tracks != nil {
            MusicPlayerService.shared.setNext()
            loadTrackInformation()
            delegate?.updateInformation()
            setUpButtonsUI()
        }
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
