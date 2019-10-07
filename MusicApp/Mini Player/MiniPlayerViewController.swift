//
//  MiniPlayerViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 07.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import SDWebImage

class MiniPlayerViewController: UIViewController {

    @IBOutlet weak var albumImageView: RoundedImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let track = MusicPlayerService.shared.track else { return }
        
        loadAlbumImage(from: track.artworkUrl100)
        trackNameLabel.text = track.trackName
    }
    
    func loadAlbumImage(from url: String?) {
        guard let string = url,
            let url = URL(string: string) else { return }
        albumImageView.sd_setImage(with: url, completed: nil)
    }
    
    
    
    
    
}
