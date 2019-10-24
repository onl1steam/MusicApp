//
//  TracksTableCell.swift
//  MusicApp
//
//  Created by Рыжков Артем on 24.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import RxCocoa

class TracksTableCell: UITableViewCell {

    var viewModel: TracksTableCellViewModel!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackAlbumImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        
    }

}
