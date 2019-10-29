//
//  TracksTableCell.swift
//  MusicApp
//
//  Created by Рыжков Артем on 24.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TracksTableCell: UITableViewCell {

    var viewModel: TracksTableCellViewModel?
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackAlbumImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
    }
    
    private func bindUI() {
        viewModel?.trackName.bind(to: trackNameLabel.rx.text).disposed(by: disposeBag)
        viewModel?.trackArtist.bind(to: trackArtistLabel.rx.text).disposed(by: disposeBag)
        
        viewModel?.albumImage.subscribe(onNext: { [weak self] (imageData) in
            guard let image = UIImage(data: imageData) else { return }
            self?.trackAlbumImage.image = image
        }).disposed(by: disposeBag)
        
        viewModel?.addButtonImage.subscribe(onNext: { [weak self] (imageData) in
            guard let image = UIImage(data: imageData) else {
                self?.addButton.setBackgroundImage(UIImage(), for: .normal)
                return
            }
            self?.addButton.setBackgroundImage(image, for: .normal)
        }).disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 
    }
    
    
    @objc func addButtonTapped(sender: UIButton) {
        viewModel?.addTrackToDB()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configureCell(with track: Track) {
        viewModel = TracksTableCellViewModel(track: track)
        bindUI()
    }

}
