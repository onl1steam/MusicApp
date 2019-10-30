//
//  MiniViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 19.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class MiniPlayerViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var albumImageView: RoundedImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    let viewModel = MiniPlayerViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        addGestureRecognizer()
        bindUI()
    }
    
    private func bindUI() {
        viewModel.trackName.bind(to: trackName.rx.text).disposed(by: disposeBag)
        
        viewModel.albumImage.subscribe(onNext: { [weak self] (imageData) in
            guard let image = UIImage(data: imageData) else { return }
            self?.albumImageView.image = image
        }).disposed(by: disposeBag)
        
        viewModel.isPlaying.subscribe(onNext: { [weak self] (isPlaying) in
            // Change play button image
            self?.playButton.changeSystemButton(firstImageName: "pause.fill",
                                                secondImageName: "play.fill",
                                                with: isPlaying)
        }).disposed(by: disposeBag)
    }
    
    // MARK: Adding gesture recognizer
    func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    // MARK: Handle tap gesture on mini player
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let playerMainViewController = PlayerMainViewController()
        self.present(playerMainViewController, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    @IBAction func playButtonTapped(_ sender: UIButton) {
        viewModel.playMusic()
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        viewModel.playForward()
    }
    
}

extension MiniPlayerViewController {
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
//      viewControllerToPresent.modalPresentationStyle = .fullScreen
      super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

