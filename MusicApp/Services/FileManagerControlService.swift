//
//  FileManagerDownloadService.swift
//  MusicApp
//
//  Created by Рыжков Артем on 03.03.2020.
//  Copyright © 2020 Рыжков Артем. All rights reserved.
//

import Foundation

//class FileManagerControlService {
//
//
//    func removeFromFileManager(previewUrl: String) {
//        if let audioUrl = URL(string: previewUrl) {
//            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//
//            do {
//                try FileManager.default.removeItem(atPath: destinationUrl.path)
//                removeTrackLocalUrl(previewUrl: previewUrl)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//}
