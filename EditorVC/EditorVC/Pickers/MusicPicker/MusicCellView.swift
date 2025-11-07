//
//  MusicCellView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import SwiftUI
import AVFAudio
import IOS_CommonEditor

struct MusicCellView: View {
    var music: MusicModel
    let isPlaying: Bool
    let isSelected: Bool
    @Binding var selectedMusic: MusicModel?
    @ObservedObject var audioPlayer: AudioPlayer
    @Binding var newMusicAdded: MusicModel
    @Binding var isMusicPickerPresented: Bool
    
    var body: some View {
        HStack {
            HStack{
                ZStack{
                    SwiftUI.Image("StaticAudio")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(5.0)
                    SwiftUI.Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                
                //            SwiftUI.Image("StaticAudio")
                //                .resizable()
                //                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading){
                    Text(music.displayName)
                    Text(formatDuration(music.duration))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .onAppear(){
                           
                        }
                }
            }.onTapGesture {
                if let selectedSong = self.selectedMusic, selectedSong.musicID == music.musicID {
                    if audioPlayer.audioPlayer?.isPlaying == true {
                        audioPlayer.pauseAudio()
                        self.selectedMusic = nil
                    } else {
                        //                            audioPlayer.playAudio(url: music.audioURL)
                        audioPlayer.playAudio(with: music)
                    }
                }else {
                    //                        audioPlayer.playAudio(url: music.audioURL)
                    audioPlayer.playAudio(with: music)
                    self.selectedMusic = music
                }
            }
            
            Spacer()
            
            if isSelected {
                
                Spacer()
                Button(action: {
                    selectedMusic = music
                    selectedMusic?.duration = Float(audioPlayer.audioPlayer!.duration)
                    selectedMusic?.musicType = "APP"
                    newMusicAdded = selectedMusic!
                    
                    isMusicPickerPresented = false
//                    print("selected Music \(selectedMusic)")
                }, label: {
                    Text("Add_")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 70, height: 30)
                        .background(AppStyle.accentColor_SwiftUI)
                        .cornerRadius(5.0)
                })
            }
        }
        .padding()
    }
    
    func formatDuration(_ duration: Float) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
}


