//
//  BGContainerTabbar.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 14/03/24.
//

import SwiftUI

struct BGContainerTabbar: View {
    /* State for managing Tab Bar */
    @Binding var didColorTabClicked : Bool
    @Binding var didGradientTabClicked : Bool
    @Binding var didBackgroundTabClicked : Bool
    @Binding var didTextureTabClicked : Bool
    @Binding var didGalleryTabClicked : Bool
    @Binding var didBlurTabClicked : Bool
    @Binding var didOverlayTabClicked : Bool
    @Binding var didFilterAdjustmentClicked : Bool
    @Binding var didColorAdjustmentClicked : Bool
    @Binding var didFilterShapesClicked : Bool

    @Binding var lastSelectedTab: String
    @Binding var didCloseButtonTapped: Bool
    
    /* State for managing Panel */
    @State var showPanel : Bool = false
    @State var heightConform : Bool = false
    
    /* Delegate for Managing Height */
   weak var delegate : ContainerHeightProtocol?
    
    //Height Confirm Function.
    func heightConfirm()-> Bool{
        if !didColorTabClicked && !didGradientTabClicked && !didBackgroundTabClicked &&
            !didTextureTabClicked && !didGalleryTabClicked && !didBlurTabClicked &&
            !didOverlayTabClicked && didCloseButtonTapped && !didFilterAdjustmentClicked && !didColorAdjustmentClicked
            && !didFilterShapesClicked
        {
            return false
        }
        else{
            return true
        }
    }
    
    
    
    // Function for updating the state.
    func updateState(state : Bool){
        if state != didColorTabClicked && didColorTabClicked{
            didColorTabClicked = false
        }
        if state != didGradientTabClicked && didGradientTabClicked{
            didGradientTabClicked = false
        }
        if state != didBackgroundTabClicked && didBackgroundTabClicked{
            didBackgroundTabClicked = false
        }
        if state != didTextureTabClicked && didTextureTabClicked{
            didTextureTabClicked = false
        }
        if state != didGalleryTabClicked && didGalleryTabClicked{
            didGalleryTabClicked = false
        }
        if state != didBlurTabClicked && didBlurTabClicked{
            didBlurTabClicked = false
        }
        if state != didOverlayTabClicked && didOverlayTabClicked{
            didOverlayTabClicked = false
        }
        if state == didCloseButtonTapped && !didCloseButtonTapped{
            didCloseButtonTapped = false
        }
        if state != didFilterAdjustmentClicked && didFilterAdjustmentClicked{
            didFilterAdjustmentClicked = false
        }
        if state != didColorAdjustmentClicked && didColorAdjustmentClicked{
            didColorAdjustmentClicked = false
        }
        if state != didFilterShapesClicked && didFilterShapesClicked{
            didFilterShapesClicked = false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                ScrollViewReader{proxy in
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            
                            Button{
                                updateState(state: didFilterShapesClicked)
                                didFilterShapesClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "Shapes"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                //                    delegate?.didContainerHeightChanged(height: 75)
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "camera.filters").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didFilterAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.accentColor)
                                    Text("Shapes_").font(.caption2
                                    ).foregroundColor(didFilterAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("Shapes")
                            .frame(width: 60)
                            
                            
                            
                            Button{
                                updateState(state: didColorTabClicked)
                                didColorTabClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "Color"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                //                    delegate?.didContainerHeightChanged(height: 75)
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "paintpalette").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didColorTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.accentColor)
                                    Text("Color_").font(.caption2
                                    ).foregroundColor(didColorTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("Color")
                            .frame(width: 60)
                            //                        .padding()
                            
                            Button{
                                updateState(state: didGradientTabClicked)
                                didGradientTabClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "Gradient"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "circle.filled.pattern.diagonalline.rectangle").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didGradientTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.accentColor)
                                    Text("Gradient_").font(.caption2
                                    ).foregroundColor(didGradientTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("Gradient")
                            .frame(width: 60)
                            //                        .padding()
                            
                            Button{
                                updateState(state: didGalleryTabClicked)
                                didGalleryTabClicked.toggle()
                                heightConform = heightConfirm()
                                delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "photo").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(/*didGalleryTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.gray)
                                    Text("Image_").font(.caption2
                                    ).foregroundColor(/*didGalleryTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                }
                            }
                            .frame(width: 60)
                            //                        .padding()
                            
                            Button{
                                updateState(state: didBackgroundTabClicked)
                                didBackgroundTabClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "Wallpaper"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "photo.artframe").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didBackgroundTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.gray)
                                    Text("Wallpaper_").font(.caption2
                                    ).foregroundColor(didBackgroundTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("Wallpaper")
                            .frame(width: 60)
                            //                        .padding()
                            
                            
                            Button{
                                updateState(state: didTextureTabClicked)
                                didTextureTabClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "Texture"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName:
                                                    "circle.lefthalf.filled.righthalf.striped.horizontal.inverse").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didTextureTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.gray)
                                    Text("Texture_").font(.caption2).foregroundColor(didTextureTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("Texture")
                            .frame(width: 60)
                            //                        .padding()
                            
                            Button{
                                updateState(state: didOverlayTabClicked)
                                didOverlayTabClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "Overlay"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "circle.dotted.and.circle").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didOverlayTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.gray)
                                    Text("Overlay_").font(.caption2
                                    ).foregroundColor(didOverlayTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("Overlay")
                            .frame(width: 60)
                            //                        .padding()
                            
                            Button{
                                updateState(state: didBlurTabClicked)
                                didBlurTabClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "Blur"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal.inverse").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didBlurTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.gray)
                                    Text("Opacity_").font(.caption2
                                    ).foregroundColor(didBlurTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("Opacity")
                            .frame(width: 60)
                            //                        .padding()
                            
                            
                            Button{
                                updateState(state: didFilterAdjustmentClicked)
                                didFilterAdjustmentClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "Filter"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                //                    delegate?.didContainerHeightChanged(height: 75)
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "camera.filters").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didFilterAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.accentColor)
                                    Text("Filters_").font(.caption2
                                    ).foregroundColor(didFilterAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("Filter")
                            .frame(width: 60)
                            //                        .padding()
                            
                            Button{
                                updateState(state: didColorAdjustmentClicked)
                                didColorAdjustmentClicked.toggle()
                                heightConform = heightConfirm()
                                lastSelectedTab = "ColorAdjustMent"
                                delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                //                    delegate?.didContainerHeightChanged(height: 75)
                            }label: {
                                VStack{
                                    SwiftUI.Image(systemName: "wand.and.sparkles").renderingMode(.template).resizable().aspectRatio(contentMode: .fit).foregroundColor(didColorAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.accentColor)
                                    Text("Enhance_").font(.caption2
                                    ).foregroundColor(didColorAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                }
                            }
                            .id("ColorAdjustMent")
                            .frame(width: 60)
                            //                        .padding()
                        }
                        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? geometry.size.width : .infinity, alignment: .center)
                    }
                    .onAppear(){
                        scrollToSelectedButton(scrollViewProxy: proxy, scrollToTab: lastSelectedTab)
                        
                        if lastSelectedTab == "Color"{
                            didColorTabClicked.toggle()
                        }else if lastSelectedTab == "Gradient"{
                            didGradientTabClicked.toggle()
                        }else if lastSelectedTab == "Wallpaper"{
                            didBackgroundTabClicked.toggle()
                        }else if lastSelectedTab == "Texture"{
                            didTextureTabClicked.toggle()
                        }else if lastSelectedTab == "Blur"{
                            didBlurTabClicked.toggle()
                        }else if lastSelectedTab == "Overlay"{
                            didOverlayTabClicked.toggle()
                        }else if lastSelectedTab == "Filter"{
                            didFilterAdjustmentClicked.toggle()
                        }
                        else if lastSelectedTab == "ColorAdjustMent"{
                            didColorAdjustmentClicked.toggle()
                        }
                        
                        heightConform = heightConfirm()
                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                    }
                }
                
                
                VStack {
                    Button(action: {
                        // Action for close button
                        didCloseButtonTapped = false
                        updateState(state: didCloseButtonTapped)
                        
                        
                    }) {
                        SwiftUI.Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(AppStyle.accentColor_SwiftUI)
                            .background(Circle().fill(Color.systemBackground))
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .padding()
                }
                .frame(width: 50, height: tabbarHeight)
            }
            
        }
//
        
//        .ignoresSafeArea()
//        .background(Color.white)
//        .frame(maxWidth: tabbarWidth)
//        .frame(height: tabbarHeight).background(Color.systemBackground).cornerRadius(15.0).shadow(color: Color.label.opacity(0.3), radius: 5, x: 0, y: 2)
//        .padding(.leading, 10)
//        .padding(.trailing, 10)
        
    }
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToTab: String) {
        // Find the ID of the last selected button and scroll to it
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToTab, anchor: .center)
        }
    }
}

//#Preview {
//    BGContainerTabbar()
//}
