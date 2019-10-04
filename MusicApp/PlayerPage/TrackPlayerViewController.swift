//
//  TrackPlayerViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 05.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import AVKit

class TrackPlayerViewController: UIViewController {
    
    @IBOutlet weak var trackAuthorLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forewardButton: UIButton!
    
    var track: Track?

    override func viewDidLoad() {
        super.viewDidLoad()

        trackNameLabel.text = track?.trackName
        trackAuthorLabel.text = track?.artistName
        loadAlbumImage(from: track!.artworkUrl100)
    }
    
    func loadAlbumImage(from url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.albumImageView.image = image
                    }
                }
            }
        }
        
        
    }

    
    @IBAction func playButtonTapped(_ sender: Any) {
        playSound()
    }
    
    func playSound() {
        
    }
    

}
