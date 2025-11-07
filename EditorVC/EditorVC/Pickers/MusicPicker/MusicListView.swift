//
//  MusicListView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import SwiftUI
import AVFoundation
import IOS_CommonEditor

//struct MusicListView: View {
//    @StateObject private var audioPlayer = AudioPlayer.shared
//    @State private var selectedSong: MusicModel?
//    @Binding var musicList: [MusicModel]
//    
//    var body: some View {
//        List(musicList, id: \.musicID) { music in
//            MusicCellView(music: music, isPlaying: self.isPlaying(music: music), isSelected: self.isSelected(music: music), selectedMusic: self.$selectedSong)
//                .onTapGesture {
//                    if let selectedSong = self.selectedSong, selectedSong.musicID == music.musicID {
//                        if audioPlayer.audioPlayer?.isPlaying == true {
//                            audioPlayer.pauseAudio()
//                            self.selectedSong = nil
//                        } else {
////                            audioPlayer.playAudio(url: music.audioURL)
//                            audioPlayer.playAudio(with: music)
//                        }
//                    }else {
////                        audioPlayer.playAudio(url: music.audioURL)
//                        audioPlayer.playAudio(with: music)
//                        self.selectedSong = music
//                    }
//                }
//        }
//        .listStyle(.plain)
//        .listRowSeparator(.hidden)
//        .onDisappear(){
//            audioPlayer.audioPlayer?.stop()
//        }
//        
//    }
//    
//    private func isPlaying(music: MusicModel) -> Bool {
//        return selectedSong?.musicID == music.musicID && audioPlayer.audioPlayer?.isPlaying == true
//    }
//    
//    private func isSelected(music: MusicModel) -> Bool {
//        return selectedSong?.musicID == music.musicID
//    }
//}

struct MusicListView: View {
    @StateObject private var audioPlayer = AudioPlayer.shared
    @State private var selectedSong: MusicModel?
    @Binding var musicList: [MusicModel]
    @Binding var newMusicAdded: MusicModel
    @Binding var isMusicPickerPresented: Bool
    
    var body: some View {
        List(musicList, id: \.musicID) { music in
            MusicCellView(music: music, isPlaying: self.isPlaying(music: music), isSelected: self.isSelected(music: music), selectedMusic: self.$selectedSong, audioPlayer: audioPlayer, newMusicAdded: $newMusicAdded, isMusicPickerPresented: $isMusicPickerPresented)
//                .onTapGesture {
//                    if let selectedSong = self.selectedSong, selectedSong.musicID == music.musicID {
//                        if audioPlayer.audioPlayer?.isPlaying == true {
//                            audioPlayer.pauseAudio()
//                            self.selectedSong = nil
//                        } else {
////                            audioPlayer.playAudio(url: music.audioURL)
//                            audioPlayer.playAudio(with: music)
//                        }
//                    }else {
////                        audioPlayer.playAudio(url: music.audioURL)
//                        audioPlayer.playAudio(with: music)
//                        self.selectedSong = music
//                    }
//                }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .onDisappear(){
            audioPlayer.audioPlayer?.stop()
        }
        
    }
    
    private func isPlaying(music: MusicModel) -> Bool {
        return selectedSong?.musicID == music.musicID && audioPlayer.audioPlayer?.isPlaying == true
    }
    
    private func isSelected(music: MusicModel) -> Bool {
        return selectedSong?.musicID == music.musicID
    }
}


