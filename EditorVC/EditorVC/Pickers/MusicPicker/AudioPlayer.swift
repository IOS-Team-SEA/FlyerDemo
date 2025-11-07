//
//  AudioPlayer.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 20/03/24.
//

import Foundation
import AVFoundation
import Combine
import IOS_CommonEditor

class AudioPlayer: ObservableObject{
    static let shared = AudioPlayer()
    
    var audioPlayer: AVAudioPlayer?
    
    func playAudio(with music: MusicModel) {
        guard let url = Bundle.main.url(forResource: music.localPath, withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
}

