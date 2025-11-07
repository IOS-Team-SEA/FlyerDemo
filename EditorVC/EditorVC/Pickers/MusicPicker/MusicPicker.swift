//
//  MusicPicker.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import SwiftUI
import IOS_CommonEditor

enum MusicTab {
    case music
    case add
}

struct MusicPicker: View {
    @State private var selection: MusicTab = .music
    @Binding var MusicInfo: [MusicModel]
    @Binding var newMusicAdded: MusicModel
    @Binding var isMusicPickerPresented: Bool
    
//    var tabs = ["Music", "Add"]
//    var imageName = ["music.note", "plus.circle.fill"]
//    @State var selectedTab = "Music"
//    var edges = UIApplication.shared.windows.first?.safeAreaInsets
//    @Namespace var animation
    
    var body: some View {
        TabView(selection: $selection){
            NavigationView{
                MusicListView(musicList: $MusicInfo, newMusicAdded: $newMusicAdded, isMusicPickerPresented: $isMusicPickerPresented)
                    .navigationBarTitle("Music_")
                    .navigationBarItems(trailing: Button(action: {
                        // Action for done button
                        doneButtonTapped()
                    }) {
                        VStack{
                            Image("ic_Close")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.primary)
                                .frame(width: 20, height: 20)
                                
                        }
                        .frame(width: 30, height: 30)
                        .background(Color.secondarySystemBackground)
                        .clipShape(Circle())
//                        Text("Done_")
//                            .foregroundColor(AppStyle.accentColor_SwiftUI)
                    })
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Music_", systemImage: "music.note")
            }
            .tag(MusicTab.music)
            
            NavigationView{
                MusicLibraryView(newMusicAdded: $newMusicAdded)
                    .navigationBarItems(trailing: Button(action: {
                        // Action for done button
                        isMusicPickerPresented = false
                    }) {
                        VStack{
                            SwiftUI.Image("ic_Close")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.label)
                                .frame(width: 20, height: 20)
                        }
                        .frame(width: 30, height: 30)
                        .background(Color.secondarySystemBackground)
                        .cornerRadius(15)
                    })
                
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Import_", systemImage: "square.and.arrow.down")
            }
            .tag(MusicTab.add)
        }
        .accentColor(AppStyle.accentColor_SwiftUI)
        
        
    }
    
    private func doneButtonTapped() {
        // Action for done button
        isMusicPickerPresented = false
        print("Done button tapped")
        // Add your action here
    }
    

}

//#Preview {
//    MusicPicker()
//}
