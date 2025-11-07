//
//  PageContainerTabbar.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 05/04/24.
//

import SwiftUI

struct PageContainerTabbar: View {
    
    /* Parent State for Managing Tabbar */
    @Binding var didLayersTabClicked : Bool
    @Binding var didBGTabClicked : Bool
    @Binding var didStickerTabClicked : Bool
    @Binding var didTextTabClicked : Bool
    @Binding var didMusicTabClicked: Bool
    @Binding var didImageTabClicked: Bool
    @Binding var didGifTabClicked: Bool
    @State private var isVisible = false
    
//    @Binding var didDoneTabClicked: Bool
    
//    @Binding var isEditedClicked: Bool
    
    @State var heightConform : Bool = false
    
    weak var delegate : ContainerHeightProtocol?
    
    func heightConfirm()-> Bool{
        if !didLayersTabClicked && !didBGTabClicked && !didStickerTabClicked &&
            !didTextTabClicked && !didMusicTabClicked && !didImageTabClicked && !didGifTabClicked
        {
            return false
        }
        else{
            return true
        }
    }
    
    func updateState(state : Bool){
        
        if state != didLayersTabClicked && didLayersTabClicked{
            didLayersTabClicked = false
        }
        
        if state != didBGTabClicked && didBGTabClicked{
            didBGTabClicked = false
        }
        if state != didStickerTabClicked && didStickerTabClicked{
            didStickerTabClicked = false
        }
        if state != didTextTabClicked && didTextTabClicked{
            didTextTabClicked = false
        }
        
        if state != didMusicTabClicked && didMusicTabClicked{
            didMusicTabClicked = false
        }
        
        if state != didImageTabClicked && didImageTabClicked{
            didImageTabClicked = false
        }
        
        if state != didGifTabClicked && didGifTabClicked{
            didGifTabClicked = false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false){
                if isVisible{
                    HStack(spacing: 5){
                        
                        Button{
                            updateState(state: didLayersTabClicked)
                            didLayersTabClicked.toggle()
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        }label: {
                            VStack{
                                SwiftUI.Image(systemName: "square.3.layers.3d")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(didLayersTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25)
                                    .foregroundColor(.accentColor)
                                Text("Layers_").font(.caption2
                                ).foregroundColor(didLayersTabClicked ? AppStyle.accentColor_SwiftUI : Color("PanelIcon", bundle: .main))
                            }.animation(.easeInOut, value: didLayersTabClicked)
                        }
                        .frame(width: 70)
                        //                    .padding()
                        
                        
                        Button{
                            updateState(state: didBGTabClicked)
                            didBGTabClicked.toggle()
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        }label: {
                            VStack{
                                SwiftUI.Image(systemName: "circle.rectangle.filled.pattern.diagonalline")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(didBGTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.accentColor)
                                Text("Background_").font(.caption2
                                ).foregroundColor(didBGTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                            }.animation(.easeInOut, value: didBGTabClicked)
                        }
                        .frame(width: 70)
                        //                    .padding()
                        
                        
                        Button{
                            updateState(state: didStickerTabClicked)
                            didStickerTabClicked.toggle()
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        }label: {
                            VStack{
                                SwiftUI.Image(systemName: "face.dashed")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(didStickerTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.accentColor)
                                Text("Sticker_").font(.caption2
                                ).foregroundColor(didStickerTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                            }.animation(.easeInOut, value: didStickerTabClicked)
                        }
                        .frame(width: 70)
                        //                    .padding()
                        
                        Button{
                            updateState(state: didTextTabClicked)
                            didTextTabClicked.toggle()
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        }label: {
                            VStack{
                                SwiftUI.Image(systemName:"t.square")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(didTextTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.accentColor)
                                Text("Text_").font(.caption2
                                ).foregroundColor(didTextTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                            }.animation(.easeInOut, value: didTextTabClicked)
                        }
                        .frame(width: 70)
                        //                    .padding()
                        
                        Button{
                            updateState(state: didImageTabClicked)
                            didImageTabClicked.toggle()
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        }label: {
                            VStack{
                                SwiftUI.Image(systemName: "photo.on.rectangle")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(/*didImageTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.accentColor)
                                Text("Image_").font(.caption2
                                ).foregroundColor(/*didImageTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                            }.animation(.easeInOut, value: didImageTabClicked)
                        }
                        .frame(width: 70)
                        //                    .padding()
                        
                        
//                        Button{
//                            updateState(state: didMusicTabClicked)
//                            didMusicTabClicked.toggle()
//                            heightConform = heightConfirm()
//                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
//                        }label: {
//                            VStack{
//                                SwiftUI.Image(systemName: "music.note")
//                                    .renderingMode(.template)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .foregroundColor(didMusicTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
//                                    .frame(width: 25,height: 25)
//                                    .foregroundColor(.accentColor)
//                                Text("Music_").font(.caption2
//                                ).foregroundColor(didMusicTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
//                            }.animation(.easeInOut, value: didMusicTabClicked)
//                        }
//                        .frame(width: 70)
                        
                        //                    .padding()
                        
                        //                    Button{
                        //                        updateState(state: didGifTabClicked)
                        //                        didGifTabClicked.toggle()
                        //                        heightConform = heightConfirm()
                        //                        delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        //                    }label: {
                        //                        VStack{
                        //                            SwiftUI.Image("gif")
                        //                                .renderingMode(.template)
                        //                                .resizable()
                        //                                .aspectRatio(contentMode: .fit)
                        //                                .foregroundColor(/*didImageTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                        //                                .frame(width: 25,height: 25)
                        //                                .foregroundColor(.accentColor)
                        //                            Text("Gif").font(.caption2
                        //                            ).foregroundColor(/*didImageTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                        //                        }.animation(.easeInOut, value: didGifTabClicked)
                        //                    }.padding()
                    }
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? geometry.size.width : .infinity, alignment: .center)
                    .background(.clear)
                    
                    //            }
                }
            }
            
            
            
            //        .background(.clear)
            //        .frame(height: tabbarHeight).background(Color.systemBackground).cornerRadius(15.0).shadow(color: Color.label.opacity(0.3), radius: 5, x: 0, y: 2)
            //        .frame(maxWidth: tabbarWidth)
            //        .padding(.leading, 10)
            //        .padding(.trailing, 10)
            .onAppear(){
                heightConform = heightConfirm()
                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                withAnimation(.easeInOut(duration: 0.3)) {
                    isVisible = true
                    
                }
            }
        }
    }
}

