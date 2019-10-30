//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 18.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MediaPlayer

// TODO: Bind timeSlider, playButton image, albumImageView to ViewModel

class PlayerViewController: UIViewController {
    
    let playerViewModel = PlayerViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: Outlets
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumImageView: RoundedImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide MPVolumeView HUD
        hideVolumeHUD()

        // Binding UI to ViewModel
        bindUI()
    }
    
    private func hideVolumeHUD() {
        let volumeView = MPVolumeView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        volumeView.isHidden = false
        volumeView.alpha = 0.01
        view.addSubview(volumeView)
    }
    
    private func bindUI() {
        playerViewModel.artistName.bind(to: trackArtistLabel.rx.text).disposed(by: disposeBag)
        playerViewModel.trackName.bind(to: trackNameLabel.rx.text).disposed(by: disposeBag)
        playerViewModel.volume.bind(to: volumeSlider.rx.value).disposed(by: disposeBag)
        playerViewModel.currentTime.bind(to: timeSlider.rx.value).disposed(by: disposeBag)
        playerViewModel.currentTimeString.bind(to: currentTimeLabel.rx.text).disposed(by: disposeBag)
        playerViewModel.remainingTimeString.bind(to: remainingTimeLabel.rx.text).disposed(by: disposeBag)
        
        playerViewModel.isPlaying.subscribe(onNext: { [weak self] (isPlaying) in
            // Change play button image
            self?.playButton.changeSystemButton(firstImageName: "pause.fill",
                                                secondImageName: "play.fill",
                                                with: isPlaying)
            // Image size animation when playing
            self?.albumImageView.imageSizeAnimation(flag: isPlaying)
        }).disposed(by: disposeBag)
        
        // Converting Data to UIImage
        playerViewModel.albumImage.subscribe(onNext: { [weak self] (imageData) in
            guard let image = UIImage(data: imageData) else { return }
            self?.albumImageView.image = image
        }).disposed(by: disposeBag)
        
        playerViewModel.duration.subscribe(onNext: { [weak self] (duration) in
            self?.timeSlider.maximumValue = duration
        }).disposed(by: disposeBag)
    }
    
    // MARK: IBActions
    @IBAction func playButtonTapped(_ sender: UIButton) {
        playerViewModel.playMusic()
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        playerViewModel.playBackward()
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        playerViewModel.playForward()
    }
    
    @IBAction func timeSliderBeginEdititng(_ sender: UISlider) {
        playerViewModel.timeSliderBeginEditing()
    }

    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
        playerViewModel.seekMusic(to: sender.value)
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        playerViewModel.changeVolume(to: sender.value)
    }
}
