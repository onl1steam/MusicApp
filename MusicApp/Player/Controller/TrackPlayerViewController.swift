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

    weak var delegate: MiniPlayerDelegate?
    
    // MARK: Outlets
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumImageView: RoundedImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forewardButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonsUI()
        
        // Loading Track information
        loadTrackInformation()
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.volumeDidChange(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK: Setting buttons appearance
    func setUpButtonsUI() {
        let isPlaying = MusicPlayerService.shared.isPlaying
        
        if isPlaying {
            guard let image = UIImage(systemName: "pause.fill") else { return }
            playButton.setBackgroundImage(image, for: .normal)
            albumImageView.imageSizeAnimation(flag: isPlaying)
        }
    }
    
    // MARK: Observing system volume changing
    @objc func volumeDidChange(notification: NSNotification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        volumeSlider.value = volume
    }
    
    // MARK: Observing ending of track
    @objc func playerDidFinishPlaying() {
        let isPlaying = false
        buttonChange(playButton, firstImageName: "pause.fill", secondImageName: "play.fill", with: isPlaying)
    }
    
    // MARK: Loading track information
    func loadTrackInformation() {
        trackNameLabel.text = MusicPlayerService.shared.currentTrack?.trackName ?? "Не исполняется"
        trackArtistLabel.text = MusicPlayerService.shared.currentTrack?.artistName ?? ""
        
        guard let urlString = MusicPlayerService.shared.currentTrack?.artworkUrl100,
            let url = URL(string: urlString) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }
    
    // MARK: System Buttons Change
    func buttonChange(_ sender: UIButton, firstImageName: String, secondImageName: String, with flag: Bool) {
        
        if flag {
            guard let image = UIImage(systemName: firstImageName) else { return }
            sender.setBackgroundImage(image, for: .normal)
        } else {
            guard let image = UIImage(systemName: secondImageName)  else { return }
            sender.setBackgroundImage(image, for: .normal)
        }
    }

    // MARK: IBActions
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if MusicPlayerService.shared.tracks != nil {
            // Settings
            MusicPlayerService.shared.toggleMusic()
            let isPlaying = MusicPlayerService.shared.isPlaying
            // Animations
            albumImageView.imageSizeAnimation(flag: isPlaying)
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
    
    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
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
