//
//  SearchBarExtension.swift
//  MusicApp
//
//  Created by Рыжков Артем on 13.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

extension TrackSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        guard let searchTerm = searchBar.text else { return }
        requestForTracks(with: searchTerm)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        // 
    }
}
