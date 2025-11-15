//
//  StcikerContainreTabBar.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 12/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct StcikerContainreTabBar: View {
    @Binding var templateType : OutputType

    
    //State Define for showing the panel at one time.
    @State private var isVisible = false
    /* Panel State */
    @Binding var didReplaceTabClicked : Bool
    @Binding var didColorTabClicked : Bool
    @Binding var didHueTabClicked : Bool
    @Binding var didNudgeTabClicked : Bool
    @Binding var didCropTabClicked : Bool
    @Binding var didTransformTabClicked : Bool
    @Binding var didOpacityTabClicked : Bool
    @Binding var didPositionTabClicked : Bool
    @Binding var didAnimationTabClicked : Bool
    @State var heightConform : Bool = false
    
    /* Action State */
    @Binding var didDeleteTabClicked : Bool
    @Binding var didCopyTabClicked : Bool
    @Binding var didDuplicateTabClicked : Bool
    @Binding var didPasteTabClicked : Bool
    @Binding var didLockUnclockTabClicked : Bool
    @Binding var didGroupTabClicked : Bool 
    @Binding var didUngroupTabClicked : Bool
    @Binding var didShowDurationButtonCliked : Bool
    
    @Binding var lastSelectedTab: String
    @Binding var didCloseButtonTapped: Bool
    @Binding var showPanel: Bool
    @Binding var isCurrentModelDeleted: Bool
    @Binding var shouldRefreshOnAddComponent: Bool
    weak var delegate : ContainerHeightProtocol?
    
    @Binding var didFilterAdjustmentClicked : Bool
    @Binding var didColorAdjustmentClicked : Bool
    
    func heightConfirm()-> Bool{
        if !didReplaceTabClicked && !didColorTabClicked && !didNudgeTabClicked &&
            !didCropTabClicked && !didTransformTabClicked && !didOpacityTabClicked &&
            !didPositionTabClicked && !didAnimationTabClicked && !didHueTabClicked && !didFilterAdjustmentClicked && !didColorAdjustmentClicked{
            return false
        }
        else{
            return true
        }
    }
    
    func updateState(state : Bool){

        if state != didColorTabClicked && didColorTabClicked{
            didColorTabClicked = false
        }
        if state != didHueTabClicked && didHueTabClicked{
            didHueTabClicked = false
        }
        if state != didCropTabClicked && didCropTabClicked{
            didCropTabClicked = false
        }
        if state != didNudgeTabClicked && didNudgeTabClicked{
            didNudgeTabClicked = false
        }
        if state != didTransformTabClicked && didTransformTabClicked{
            didTransformTabClicked = false
        }
        if state != didOpacityTabClicked && didOpacityTabClicked{
            didOpacityTabClicked = false
        }
        if state != didPositionTabClicked && didPositionTabClicked{
            didPositionTabClicked = false
        }
        if state != didAnimationTabClicked && didAnimationTabClicked{
            didAnimationTabClicked = false
        }
        if state != didDeleteTabClicked && didDeleteTabClicked{
            didDeleteTabClicked = false
        }
        if state != didCopyTabClicked && didCopyTabClicked{
            didCopyTabClicked = false
        }
        if state != didDuplicateTabClicked && didDuplicateTabClicked{
            didDuplicateTabClicked = false
        }
        if state != didPasteTabClicked && didPasteTabClicked{
            didPasteTabClicked = false
        }
        if state != didLockUnclockTabClicked && didLockUnclockTabClicked{
//            didLockUnclockTabClicked = false
        }
        if state != didGroupTabClicked && didGroupTabClicked{
            didGroupTabClicked = false
        }
        if state != didUngroupTabClicked && didUngroupTabClicked{
            didUngroupTabClicked = false
        }
        if state != didShowDurationButtonCliked && didShowDurationButtonCliked{
            didShowDurationButtonCliked = false
        }
        
        if state != didFilterAdjustmentClicked && didFilterAdjustmentClicked{
            didFilterAdjustmentClicked = false
        }
        if state != didColorAdjustmentClicked && didColorAdjustmentClicked{
            didColorAdjustmentClicked = false
        }
    }
    
    
    var body: some View {
        VStack{
            GeometryReader { geometry in
                HStack{
                    ScrollViewReader{proxy in
                        ScrollView(.horizontal, showsIndicators: false){
                            if isVisible{
                                HStack(spacing: 0){
                                    //
                                    if templateType != .Image {
                                    Button{
                                        updateState(state: didAnimationTabClicked)
                                        didAnimationTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Animation"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image("animation")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didAnimationTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Animation_").font(.caption2
                                            ).foregroundColor(didAnimationTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didAnimationTabClicked)
                                    }
                                    .id("Animation")
                                    .frame(width: 60)
                                }
                                    //                                    .padding()
                                    
                                    Button{
                                        updateState(state: didColorTabClicked)
                                        didColorTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Color"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "paintpalette")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didColorTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Color_").font(.caption2
                                            ).foregroundColor(didColorTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didColorTabClicked)
                                    }
                                    .id("Color")
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    Button{
                                        updateState(state: didOpacityTabClicked)
                                        didOpacityTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Opacity"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                        
                                        
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal.inverse")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didOpacityTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.accentColor)
                                            Text("Opacity_").font(.caption2).foregroundColor(didOpacityTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didOpacityTabClicked)
                                    }
                                    .id("Opacity")
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    Button{
                                        updateState(state: didHueTabClicked)
                                        didHueTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Hue"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "sleep.circle")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didHueTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Hue_").font(.caption2
                                            ).foregroundColor(didHueTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didHueTabClicked)
                                    }
                                    .id("Hue")
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    
                                    Button{
                                        updateState(state: didNudgeTabClicked)
                                        didNudgeTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Nudge"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                        
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didNudgeTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Nudge_").font(.caption2).foregroundColor(didNudgeTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didNudgeTabClicked)
                                    }
                                    .id("Nudge")
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    
                                    Button{
                                        updateState(state: didCropTabClicked)
                                        didCropTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Crop"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "crop")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didCropTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Crop_").font(.caption2
                                            ).foregroundColor(didCropTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didCropTabClicked)
                                    }
                                    .id("Crop")
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    Button{
                                        updateState(state: didTransformTabClicked)
                                        didTransformTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Flip"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "arrow.trianglehead.left.and.right.righttriangle.left.righttriangle.right")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didTransformTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Flip_").font(.caption2
                                            ).foregroundColor(didTransformTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didTransformTabClicked)
                                    }
                                    .id("Flip")
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    Button{
                                        updateState(state: didFilterAdjustmentClicked)
                                        didFilterAdjustmentClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Filter"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                        //                    delegate?.didContainerHeightChanged(height: 75)
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "camera.filters")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didFilterAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.accentColor)
                                            Text("Filters_").font(.caption2
                                            ).foregroundColor(didFilterAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didFilterAdjustmentClicked)
                                    }
                                    .id("Filter")
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    Button{
                                        updateState(state: didColorAdjustmentClicked)
                                        didColorAdjustmentClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "ColorAdjustMent"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                        //                    delegate?.didContainerHeightChanged(height: 75)
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "wand.and.sparkles")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didColorAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.accentColor)
                                            Text("Enhance_").font(.caption2
                                            ).foregroundColor(didColorAdjustmentClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didColorAdjustmentClicked)
                                    }
                                    .id("ColorAdjustMent")
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    
                                    Button{
                                        updateState(state: didReplaceTabClicked)
                                        didReplaceTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "arrow.2.squarepath")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didReplaceTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.accentColor)
                                            Text("Replace_")
                                                .font(.caption2).foregroundColor(didReplaceTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didReplaceTabClicked)
                                    }
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    
                                    //                    Button{
                                    //                        updateState(state: didDeleteTabClicked)
                                    //                        didDeleteTabClicked.toggle()
                                    //                        heightConform = heightConfirm()
                                    //                        delegate.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    //                    }label: {
                                    //                        VStack{
                                    //                            SwiftUI.Image("delete").renderingMode(.template).resizable().foregroundColor(didDeleteTabClicked ?AppStyle.accentColor_SwiftUI:.gray).frame(width: 25,height: 25).foregroundColor(.gray)
                                    //                            Text("Delete").font(.caption
                                    //                            ).foregroundColor(didDeleteTabClicked ?AppStyle.accentColor_SwiftUI:.gray)
                                    //                        }
                                    //                    }.padding()
                                    
                                    Button{
                                        updateState(state: didDuplicateTabClicked)
                                        didDuplicateTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                        
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "plus.rectangle.on.rectangle")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(/*didDuplicateTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Duplicate_").font(.caption2
                                            ).foregroundColor(/*didDuplicateTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didDuplicateTabClicked)
                                    }
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    
                                    Button{
                                        updateState(state: didCopyTabClicked)
                                        didCopyTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "rectangle.portrait.on.rectangle.portrait")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(/*didCopyTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Copy_").font(.caption2
                                            ).foregroundColor(/*didCopyTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didCopyTabClicked)
                                    }
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    //                        Button{
                                    //                            updateState(state: didPasteTabClicked)
                                    //                            didPasteTabClicked.toggle()
                                    //                            heightConform = heightConfirm()
                                    //                            delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    //                        }label: {
                                    //                            VStack{
                                    //                                SwiftUI.Image("paste").renderingMode(.template).resizable().foregroundColor(didPasteTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.gray)
                                    //                                Text("Paste_").font(.caption2
                                    //                                ).foregroundColor(didPasteTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    //                            }
                                    //                        }.padding()
                                    
                                    Button{
                                        updateState(state: didGroupTabClicked)
                                        didGroupTabClicked.toggle()
                                        delegate?.didContainerHeightChanged(height: containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "square.on.square.squareshape.controlhandles")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didGroupTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Group_").font(.caption2
                                            ).foregroundColor(didGroupTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didGroupTabClicked)
                                    }
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    
                                    Button{
                                        updateState(state: didLockUnclockTabClicked)
                                        didLockUnclockTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName:didLockUnclockTabClicked ? "lock" : "lock.open")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didLockUnclockTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text(didLockUnclockTabClicked ? "Lock_" : "unlock_").font(.caption2
                                            ).foregroundColor(didLockUnclockTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didLockUnclockTabClicked)
                                    }
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    
                                    Menu {
                                        Button(action: {
                                            updateState(state: didDeleteTabClicked)
                                            didDeleteTabClicked = true
                                            
                                            shouldRefreshOnAddComponent = true
                                            isCurrentModelDeleted = true
                                            
                                            heightConform = heightConfirm()
                                            delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                            
                                        }) {
                                            Text("Yes_")
                                        }
                                        
                                        
                                        Button(action: {
                                            
                                            
                                        }) {
                                            Text("No_")
                                        }
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: AppIcons.delete)
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(.red/*didDeleteTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)*/)
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.gray)
                                            Text("Delete_").font(.caption2
                                            ).foregroundColor(.red/*didDeleteTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)*/)
                                        }.animation(.easeInOut, value: didDeleteTabClicked)
                                    }
                                    .frame(width: 60)
                                    //                                    .padding()
                                    
                                    //                        Button{
                                    //                            updateState(state: didShowDurationButtonCliked)
                                    //                            didShowDurationButtonCliked.toggle()
                                    //                            heightConform = heightConfirm()
                                    //                            delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                    //                        }label: {
                                    //                            VStack{
                                    //                                SwiftUI.Image("show duration").renderingMode(.template).resizable().foregroundColor(/*didShowDurationButtonCliked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(.gray)
                                    //                                Text("Show_Duration").font(.caption
                                    //                                ).foregroundColor(/*didShowDurationButtonCliked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                    //                            }
                                    //                        }.padding()
                                    
                                }
//                                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? geometry.size.width : .infinity, alignment: .center)
                            }
                            
                        }
                        .onAppear(){
                            scrollToSelectedButton(scrollViewProxy: proxy, scrollToTab: lastSelectedTab)
                            
                            if lastSelectedTab == "Opacity"{
                                didOpacityTabClicked.toggle()
                            }else if lastSelectedTab == "Flip"{
                                didTransformTabClicked.toggle()
                            }else if lastSelectedTab == "Nudge"{
                                didNudgeTabClicked.toggle()
                            }else if lastSelectedTab == "Animation"{
                                didAnimationTabClicked.toggle()
                            }else if lastSelectedTab == "Color"{
                                didColorTabClicked.toggle()
                            }else if lastSelectedTab == "Hue"{
                                didHueTabClicked.toggle()
                            }else if lastSelectedTab == "Crop"{
                                didCropTabClicked.toggle()
                            }
                            heightConform = heightConfirm()
                            delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                        }
                        
                    }
                    VStack {
                        Button(action: {
                            // Action for close button
                            didCloseButtonTapped = true
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
                    .background(.clear)
                    
                }
                //            .background(.clear)
                //            .frame(height: tabbarHeight).background(Color.systemBackground).cornerRadius(15.0).shadow(color: Color.label.opacity(0.3), radius: 5, x: 0, y: 2)
                //            .frame(maxWidth: tabbarWidth)
                //            .padding(.leading, 10)
                //            .padding(.trailing, 10)
                .onChange(of: didShowDurationButtonCliked ){ value in
                    didShowDurationButtonCliked.toggle()
                    updateState(state: value)
                    heightConform = heightConfirm()
                    delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                }
            }
        }.onAppear{
            withAnimation(.easeInOut(duration: 0.3)) {
                isVisible = true
            }
        }
        
    }
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToTab: String) {
        // Find the ID of the last selected button and scroll to it
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToTab, anchor: .center)
        }
    }
    
    
}
//
//#Preview {
//    StcikerContainreTabBar()
//}
