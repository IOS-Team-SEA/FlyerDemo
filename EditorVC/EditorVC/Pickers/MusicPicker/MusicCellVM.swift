//
//  MusicCellVM.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 18/03/24.
//

import SwiftUI
import AVFoundation
import IOS_CommonEditor

class CurrentMusicStates{
    @Published var isPlaying: Bool = false
    @Published var isSelected: Bool = false
}

class MusicCellVM: NSObject, AVAudioPlayerDelegate{
    var player: AVAudioPlayer?
//     var musicArray: [MusicModel] = []
//    @State var listOfStates: [CurrentMusicStates] = []
    @State var currentMusic: MusicModel?
    @State var currentCMS: CurrentMusicStates?
    @State var isAudioLoaded = false
    
//    func fetchListOfMusic(){
//        musicArray = DBManager.shared.fetchAllMusicModel()
//        isAudioLoaded = true 
//                // Assuming musicArray and listOfStates have the same count
//        listOfStates = Array(repeating: CurrentMusicStates(), count: musicArray.count)
//    }
    
    func setCurrentMusic(music: MusicModel, cms: CurrentMusicStates){
        stopMusic()
        currentCMS?.isPlaying = false
        currentCMS?.isSelected = false
        currentMusic = music
        currentCMS = cms
        playMusic(with: music)
        
    }
    
    func playMusic(with music: MusicModel) {
        guard let url = Bundle.main.url(forResource: music.localPath, withExtension: "mp3") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
            currentCMS?.isPlaying = true
            currentCMS?.isSelected = true
//            Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [weak self] _ in
//                guard let player = self?.player else { return }
//                self?.currentTime = player.currentTime
//            }
        } catch {
            print("Error playing music: \(error.localizedDescription)")
        }
    }
    
    
    func stopMusic() {
        player?.stop()
        player = nil
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentCMS?.isPlaying = false
    }
    
    
}
