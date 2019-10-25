//
//  TestPageViewController.swift
//  MusicApp
//
//  Created by Рыжков Артем on 25.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import UIKit

class TestPageViewController: UIViewController {

    @IBOutlet weak var testView: UIView!
    var tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = TracksTableViewController()
        controller.configuteTable(with: tracks)
        controller.view.frame = testView.frame
        testView.addSubview(controller.view)
        addChild(controller)
    }

}
