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
    
    // Outlets
    @IBOutlet weak var trackAuthorLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forewardButton: UIButton!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var track: Track?
    var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Track labels
        trackNameLabel.text = track?.trackName
        trackAuthorLabel.text = track?.artistName
        
        
        // Sliders
        trackSlider.thumbImage(for: .normal)
        
        loadAlbumImage(from: track?.artworkUrl100)
    }
    
    // Transfer to Model class
    func loadAlbumImage(from url: String?) {
        guard let urlString = url,
            let url = URL(string: urlString) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }

 
    @IBAction func addToFavoriteButton(_ sender: UIButton) {
        var buttonImage: UIImage
        if !isFavorite {
            isFavorite = !isFavorite
            guard let image = UIImage(systemName: "suit.heart.fill") else { return }
            buttonImage = image
        } else {
            isFavorite = !isFavorite
            guard let image = UIImage(systemName: "suit.heart")  else { return }
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
    
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {

    }

}
