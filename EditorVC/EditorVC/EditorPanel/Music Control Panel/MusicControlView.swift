//
//  MusicControlView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 15/04/24.
//

import SwiftUI
import AVFoundation
import IOS_CommonEditor
//import SwiftUIIntrospect

struct MusicControlView: View {
    
    @ObservedObject var templateHandler : TemplateHandler
    
   @ObservedObject var playerVm : TimeLoopHnadler
    //pass Music info
//    @State var player: AVAudioPlayer?
//    @State var currentTime: Int = 0
//    @State private var isPlaying = true
    
    @StateObject var actionStates: ActionStates
//    var currentMusic: MusicInfo?
    
    @State var sliderVlaue : Float = 1.0
    var duration : TimeInterval {
        return playerVm.timeLengthDuration
    }

    var isDIsable : Bool {
        return !(playerVm.renderState == .Playing || playerVm.renderState == .Paused)
    }
    
    var currentTimeBinding: Binding<Float> {
           Binding(
               get: { self.playerVm.currentTime },
               set: { newValue in
                   self.playerVm.setCurrentTime(newValue)
               }
           )
       }
    
    
    var body: some View {
        HStack(spacing: 0) {
          
//            Spacer(minLength: 2)
           
           // if playerVm.renderState == .Playing || playerVm.renderState == .Paused {
          //  StopButton(playState: $playerVm.renderState).disabled(isDIsable)
           // }
            
            if actionStates.showPlayPauseButton {
                PlayPauseButton(playState: $playerVm.renderState)
            }
            
            if actionStates.ShowMusicSlider {
                Slider(value: currentTimeBinding, in: 0...Float(duration),onEditingChanged: { isSeeking in
                    if isSeeking {
                        playerVm.renderState = .Paused
                    }
                    playerVm.isManualScrolling = !isSeeking
                    templateHandler.renderingState  = isSeeking ? .Animating : .Edit
                    
                    if !isSeeking {
                        templateHandler.currentActionState.currentThumbTime = Float(playerVm.currentTime)
                        if playerVm.currentTime <= Float(playerVm.timeLengthDuration){
                            templateHandler.currentActionState.updatePageAndParentThumb = true
                        }
                    }
                    
                    
                })
//                .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                    slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                }
                .tint(AppStyle.accentColor_SwiftUI)
                .padding(.leading)
//                .tint(AppStyle.accentColor_SwiftUI)
                
                Text("\(String(format: "%.1f", playerVm.currentTime))/\(String(format: "%.1f", playerVm.timeLengthDuration))").font(.footnote)
                    .padding()//.frame(width: 150)
            }
            
            if actionStates.showMusicPickerRoundButton {
                MusicView(playState: $playerVm.renderState, actionStates: actionStates/*, currentMusic: currentMusic*/)//.padding()
            }
            
        }.frame(height: 50).background(Color.clear)//.shadow(radius: 10)   // .frame(maxWidth: .infinity, maxHeight: 44)
            .padding(.horizontal, 5)
            .environment(\.sizeCategory, .medium)
           
            
//        .overlay(
//            ZStack {
//                if isPlaying {
//                    SwiftUI.Image(systemName: "music")
//                        .resizable()
//                        .renderingMode(.template)
//                        .tint(AppStyle.accentColor_SwiftUI)
//                        .frame(width: 20, height: 20)
//                        .opacity(showMusicNotes ? 1.0 : 0.0)
//                        .offset(y: showMusicNotes ? -100 : 0)
//                        .animation(.easeInOut(duration: 1.0), value: showMusicNotes)
//                        .onAppear {
//                            // Show music notes and animate when isPlaying becomes true
//                            showMusicNotes = true
//                        }
//                }
//            }.frame(width: 20, height: 200)
//        )
    }
}

//#Preview {
//    MusicControlView(playerVm: .init(timeLengthDuration: 10, drawCallManager: nil))
//}


struct MusicView: View {
    // Player intialize
    // Music Model
    @Binding  var playState : SceneRenderingState
    @State var isMusicPickerPresented: Bool = false
    @State var musicInfo: [MusicModel] = []
    @ObservedObject var actionStates: ActionStates
//    var currentMusic: MusicInfo?
//    @StateObject private var audioPlayer = AudioPlayerForMusicView()

    var body: some View {
        
        
        
        // VStack{
        ZStack {
            if actionStates.currentMusic != nil{
                
                Menu {
                    Button(action: {
                        print("Replace action tapped")
                        isMusicPickerPresented = true
//                        actionStates.currentMusic = nil
                        playState = .Paused
                        
                    }) {
                        Label("Replace_", systemImage: "arrow.triangle.2.circlepath")
                    }
                    
                    
                    Button(action: {
                        print("Delete action tapped")
                        playState = .Paused
                        actionStates.deleteMusic = actionStates.currentMusic!
                    }) {
                        Label("Delete_", systemImage: "trash")
                    }
                    Text(actionStates.currentMusic!.name)
                } label: {
                    //if playState == .Playing {
                    if actionStates.didMusicPlayOnEditor{
                        PlayingStateView(isAnimation: .constant(playState == .Playing ? true : false)).tint(.black)
                    }
                    
//                    if audioPlayer.audioPlayer?.isPlaying == true {
//                        audioPlayer.pauseAudio()
//                    } else {
//                        //                            audioPlayer.playAudio(url: music.audioURL)
//                        audioPlayer.playAudio(with: actionStates.currentMusic!)
//                    }
                    //                    }else{
                    //                        PlayingStateView(isAnimation: .constant(false)).tint(.black)
                    //
                    //                    }
                }
                
                
            }else{
                
                Button {
                    playState = .Paused
                    isMusicPickerPresented = true
                } label: {
                    ZStack{
                        Circle().fill(Color(hex: "F2F2F7"))
                            .frame(width: 30, height: 30)
                        
                        HStack(alignment: .center, spacing: 8) {
                            SwiftUI.Image(systemName: "music.note")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.black) // Set image color
                        }
                        .frame(height: 30, alignment: .center)
                    }
                }
            }
        }
        .sheet(isPresented: $isMusicPickerPresented){
            MusicPicker(MusicInfo: $musicInfo, newMusicAdded: $actionStates.addNewMusicModel, isMusicPickerPresented: $isMusicPickerPresented)
                .environment(\.sizeCategory, .medium)
                .onAppear(){
                    musicInfo = DBManager.shared.fetchAllMusicModel()
                }
        }
        .environment(\.sizeCategory, .medium)
//        .halfSheet(showSheet: $isMusicPickerPresented) {
//            MusicPicker(MusicInfo: $musicInfo, newMusicAdded: $actionStates.addNewMusicModel, isMusicPickerPresented: $isMusicPickerPresented)
//                .onAppear(){
//                    musicInfo = DBManager.shared.fetchAllMusicModel()
//                }
//        } onEnd: {
//            print("Dismis")
//            isMusicPickerPresented.toggle()
//        }
    }
}


struct PlayPauseButton: View {
    
    @Binding  var playState : SceneRenderingState
    func toggle() {
        playState = playState == .Playing ? .Paused : .Playing
    }
    
    var body: some View {
        Button {
            toggle()
        } label: {
            SwiftUI.Image(systemName: playState != .Playing ? "play.square.fill" : "pause.rectangle.fill")
                .resizable()
                .accentColor(AppStyle.accentColor_SwiftUI)
                .frame(width: 30, height: 30)
        }
    }
}

struct StopButton: View {
    @Binding  var playState : SceneRenderingState

    var body: some View {
        Button {
            playState = .Stopped
        } label: {
            SwiftUI.Image(systemName: "stop.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
}
//#Preview {
//    MusicControlView(playerVm: TimeLoopHnadler(timeLengthDuration: 5.0, drawCallManager: nil),  actionStates: ActionStates(), sliderVlaue: 1.0, duration: 5.0)
//}
