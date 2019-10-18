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
    @IBOutlet weak var forewardButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Binding UI to ViewModel
        playerViewModel.artistName.bind(to: trackArtistLabel.rx.text).disposed(by: disposeBag)
        playerViewModel.trackName.bind(to: trackNameLabel.rx.text).disposed(by: disposeBag)
        playerViewModel.volume.bind(to: volumeSlider.rx.value).disposed(by: disposeBag)
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
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
        playerViewModel.seekMusic(to: sender.value)
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        playerViewModel.changeVolume(to: sender.value)
    }

}
