//
//  ParentEditContainerTabbar.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 10/04/24.
//

import SwiftUI

struct ParentEditContainerTabbar: View {
    @State private var isVisible = false
    @Binding var didLayersTabClicked : Bool
    @Binding var didStickerTabClicked : Bool
    @Binding var didTextTabClicked : Bool
    @Binding var didDoneTabClicked: Bool
    @Binding var didImageTabClicked: Bool
    
    @State var heightConform : Bool = false
    
    /* Delegate for managing the height of the panel */
    weak var delegate : ContainerHeightProtocol?
    
    func heightConfirm()-> Bool{
        if !didLayersTabClicked && !didStickerTabClicked && !didTextTabClicked && didDoneTabClicked && !didImageTabClicked
        {
            return false
        }
        else{
            return true
        }
    }
    
    /* Function for managing the state. */
    func updateState(state : Bool){
        
        if state != didLayersTabClicked && didLayersTabClicked{
            didLayersTabClicked = false
        }

        if state != didStickerTabClicked && didStickerTabClicked{
            didStickerTabClicked = false
        }
        if state != didTextTabClicked && didTextTabClicked{
            didTextTabClicked = false
        }
        
        if state == didDoneTabClicked && !didDoneTabClicked{
            didDoneTabClicked = false
        }
        
        if state != didImageTabClicked && didImageTabClicked{
            didImageTabClicked = false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false){
                if isVisible{
                    HStack(spacing: 0){
                        
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
                                    .foregroundColor(didLayersTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.accentColor)
                                Text("Layers_").font(.caption2
                                ).foregroundColor(didLayersTabClicked ? AppStyle.accentColor_SwiftUI : Color("PanelIcon", bundle: .main))
                            }.animation(.easeInOut, value: didLayersTabClicked)
                        }
                        .frame(width: 60)
                        //                    .padding()
                        
                        Button{
                            //                    updateState(state: didDoneTabClicked)
                            didDoneTabClicked = false
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        }label: {
                            VStack{
                                SwiftUI.Image("Done")
                                    .resizable()
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.accentColor)
                                    .aspectRatio(contentMode: .fit)
                                Text("Done_").font(.caption2
                                ).foregroundColor(Color("PanelIcon", bundle: .main))
                            }.animation(.easeInOut, value: didDoneTabClicked)
                        }
                        .frame(width: 60)
                        //                    .padding()
                        
                        
                        Button{
                            //                    updateState(state: didStickerTabClicked)
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
                        .frame(width: 60)
                        //                    .padding()
                        
                        Button{
                            //                    updateState(state: didTextTabClicked)
                            didTextTabClicked.toggle()
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        }label: {
                            VStack{
                                SwiftUI.Image(systemName: "textformat")
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
                        .frame(width: 60)
                        //                    .padding()
                        
                        Button{
                            //                    updateState(state: didImageTabClicked)
                            didImageTabClicked.toggle()
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                        }label: {
                            VStack{
                                SwiftUI.Image(systemName: "photo")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(didImageTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.accentColor)
                                Text("Image_").font(.caption2
                                ).foregroundColor(didImageTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                            }.animation(.easeInOut, value: didImageTabClicked)
                        }
                        .frame(width: 60)
                        //                    .padding()
                    }
                    .frame(width: geometry.size.width, alignment: .center)
                }
            }
            //        .frame(height: tabbarHeight).background(Color.systemBackground).cornerRadius(15.0).shadow(color: Color.label.opacity(0.3), radius: 5, x: 0, y: 2)
            //        .frame(maxWidth: tabbarWidth)
            //        .padding(.leading, 10)
            //        .padding(.trailing, 10)
            .onAppear(){
                withAnimation(.easeInOut(duration: 0.0)) {
                    isVisible = true
                }
                heightConform = heightConfirm()
                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
            }
        }
    }
}


