//
//  MusicModel.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import Foundation
import MediaPlayer

struct MusicModel {
    var musicID: Int = 0
    var musicName: String = ""
    var localPath: String = ""
    var displayName: String = ""
    var fileExtension: String = ""
    var serverPath: String = ""
    var thumbImageServerPath: String = ""
    var thumbImageLocalPath: String = ""
    var isFav: Bool = false  
    var duration: Float = 0
    var musicType: String = ""
}

extension MusicModel{
    func getAVAsset()->AVURLAsset?{
        let path = Bundle.main.path(forResource: "\(localPath)", ofType:"mp3")
        let soundAsset = AVURLAsset(url: URL.init(fileURLWithPath: path ?? ""))
        return soundAsset
    }
}
