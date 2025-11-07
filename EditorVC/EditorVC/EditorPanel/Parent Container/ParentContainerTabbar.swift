//
//  ParentContainerTabbar.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 14/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct ParentContainerTabbar: View {
    @State var templateType : OutputType = .Image

    /* Parent State for Managing Tabbar */
    @Binding var didLayersTabClicked : Bool
//    @Binding var didStickerTabClicked : Bool
//    @Binding var didTextTabClicked : Bool
//    @Binding var didDoneTabClicked: Bool
    @State private var isVisible = false
    /* Parent states when grouped */
    @Binding var didNudgeTabClicked : Bool
    @Binding var didTransformTabClicked : Bool
    @Binding var didOpacityTabClicked : Bool
    @Binding var didAnimationTabClicked : Bool
    @Binding var didDeleteTabClicked : Bool
    @Binding var didCopyTabClicked : Bool
    @Binding var didDuplicateTabClicked : Bool
    @Binding var didPasteTabClicked : Bool
    @Binding var didLockUnclockTabClicked : Bool
    @Binding var didUngroupTabClicked : Bool
    @Binding var didEditTabClicked : Bool
    @Binding var didGroupTabClicked : Bool
    @Binding var didShowDurationButtonCliked : Bool
    @Binding var lastSelectedTab: String
    @Binding var didCloseButtonTapped: Bool
    /* State for managing the panel */
    @Binding var showPanel : Bool
    @State var heightConform : Bool = false
    @Binding var isCurrentModelDeleted : Bool

    @Binding var shouldRefreshOnAddComponent: Bool
    
    /* Delegate for managing the height of the panel */
    weak var delegate : ContainerHeightProtocol?
    
    
    //Height Confirm Function.
    func heightConfirm()-> Bool{
        if !didLayersTabClicked && !didNudgeTabClicked /*&& !didEditTabClicked*/ && !didNudgeTabClicked && !didTransformTabClicked && !didOpacityTabClicked && !didAnimationTabClicked && !didCopyTabClicked && !didPasteTabClicked && !didDeleteTabClicked && !didDuplicateTabClicked
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
        
        
//        if state != didEditTabClicked && didEditTabClicked{
//            didEditTabClicked = false
//        }
        
        if state != didNudgeTabClicked && didNudgeTabClicked{
            didNudgeTabClicked = false
        }
        if state != didTransformTabClicked && didTransformTabClicked{
            didTransformTabClicked = false
        }
        if state != didOpacityTabClicked && didOpacityTabClicked{
            didOpacityTabClicked = false
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
        
        if state != didUngroupTabClicked && didUngroupTabClicked{
            didUngroupTabClicked = false
        }
        
        if state != didGroupTabClicked && didGroupTabClicked{
            didGroupTabClicked = false
        }
        if state != didShowDurationButtonCliked && didShowDurationButtonCliked{
            didShowDurationButtonCliked = false
        }
        
    }
    
    var body: some View {
        GeometryReader { geometry in
                HStack{
                    ScrollViewReader{proxy in
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
                                            ).foregroundColor(didLayersTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didLayersTabClicked)
                                    }
                                    .frame(width: 60)
                                    //                                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 15))
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
                                    //                                    .padding()
                                    //
                                }
                                    Button{
                                        updateState(state: didOpacityTabClicked)
                                        didOpacityTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        lastSelectedTab = "Opacity"
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                        
                                        
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal.inverse")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didOpacityTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(.accentColor)
                                            Text("Opacity_").font(.caption2
                                            ).foregroundColor(didOpacityTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didOpacityTabClicked)
                                    }
                                    .id("Opacity")
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
                                        updateState(state: didEditTabClicked)
                                        didEditTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                        //                        delegate?.didContainerHeightChanged(height: heightConform ? 200 : 75 )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "square.and.pencil")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                            Text("Edit_").font(.caption2
                                            ).foregroundColor(Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didEditTabClicked)
                                    }
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
                                    
                                  
                                    
                                    //                    Button{
                                    //                        updateState(state: didDeleteTabClicked)
                                    //                        didDeleteTabClicked.toggle()
                                    //                        heightConform = heightConfirm()
                                    //                        delegate?.didContainerHeightChanged(height: containerDefaultHeight )
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
                                        delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                                        
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName:"plus.rectangle.on.rectangle")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(/*didDuplicateTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(Color("PanelIcon", bundle: .main))
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
                                        delegate?.didContainerHeightChanged(height: containerDefaultHeight )
                                        //                        delegate?.didContainerHeightChanged(height: heightConform ? 200 : 75 )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "rectangle.portrait.on.rectangle.portrait")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(/*didCopyTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(Color("PanelIcon", bundle: .main))
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
                                    //                            delegate?.didContainerHeightChanged(height: containerDefaultHeight )
                                    //                            //                        delegate?.didContainerHeightChanged(height: heightConform ? 200 : 75 )
                                    //                        }label: {
                                    //                            VStack{
                                    //                                SwiftUI.Image("paste").renderingMode(.template).resizable().foregroundColor(didPasteTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)).frame(width: 25,height: 25).foregroundColor(Color("PanelIcon", bundle: .main))
                                    //                                Text("Paste_").font(.caption2
                                    //                                ).foregroundColor(didPasteTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    //                            }
                                    //                        }.padding()
                                    
                                    
                                    Button{
                                        updateState(state: didGroupTabClicked)
                                        didGroupTabClicked = true
                                        delegate?.didContainerHeightChanged(height: containerDefaultHeight )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "square.on.square.squareshape.controlhandles")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(/*didGroupTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(Color("PanelIcon", bundle: .main))
                                            Text("Group_").font(.caption2
                                            ).foregroundColor(/*didGroupTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didGroupTabClicked)
                                    }
                                    .frame(width: 60)
//                                    .padding()
                                            
                                    
                                    Button{
                                        updateState(state: didUngroupTabClicked)
                                        didUngroupTabClicked = true
                                        delegate?.didContainerHeightChanged(height: containerDefaultHeight )
                                        //                        delegate?.didContainerHeightChanged(height: heightConform ? 200 : 75 )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: "squareshape.controlhandles.on.squareshape.controlhandles")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(/*didUngroupTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(Color("PanelIcon", bundle: .main))
                                            Text("Ungroup_").font(.caption2
                                            ).foregroundColor(/*didUngroupTabClicked ?AppStyle.accentColor_SwiftUI:*/Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didUngroupTabClicked)
                                    }
                                    .frame(width: 60)
//                                    .padding()
                                    
                                    Button{
                                        updateState(state: didLockUnclockTabClicked)
                                        didLockUnclockTabClicked.toggle()
                                        heightConform = heightConfirm()
                                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight)
                                        //                        delegate?.didContainerHeightChanged(height: heightConform ? 200 : 75 )
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: didLockUnclockTabClicked ? "lock" : "lock.open")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(didLockUnclockTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(Color("PanelIcon", bundle: .main))
                                            Text(didLockUnclockTabClicked ? "Lock_" : "unlock_").font(.caption2
                                            ).foregroundColor(didLockUnclockTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                        }.animation(.easeInOut, value: didLockUnclockTabClicked)
                                    }
                                    .frame(width: 60)
//                                    .padding()
                                    
                                    Menu {
                                        Button(action: {
                                            updateState(state: didDeleteTabClicked)
                                            didDeleteTabClicked.toggle()
                                            
                                            shouldRefreshOnAddComponent = true
                                            isCurrentModelDeleted = true

//                                            isSelectLastModel = true
                                            heightConform = heightConfirm()
                                            delegate?.didContainerHeightChanged(height: containerDefaultHeight )
                                            
                                        }) {
                                            Text("Yes_")
                                        }
                                        
                                        
                                        Button(action: {
                                            
                                            
                                        }) {
                                            Text("No_")
                                        }
                                    }label: {
                                        VStack{
                                            SwiftUI.Image(systemName: AppIcons.delete).renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(.red/*didDeleteTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main)*/)
                                                .frame(width: 25,height: 25)
                                                .foregroundColor(Color("PanelIcon", bundle: .main))
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
                                    //                        Button{
                                    //                            updateState(state: didShowDurationButtonCliked)
                                    //                            didShowDurationButtonCliked.toggle()
                                    //                            delegate?.didContainerHeightChanged(height: containerDefaultHeight)
                                    //                        }label: {
                                    //                            VStack{
                                    //                                SwiftUI.Image("show duration").renderingMode(.template).resizable().foregroundColor(didShowDurationButtonCliked ?AppStyle.accentColor_SwiftUI:.gray).frame(width: 25,height: 25).foregroundColor(.gray)
                                    //                                Text("Show Duration").font(.caption
                                    //                                ).foregroundColor(didShowDurationButtonCliked ?AppStyle.accentColor_SwiftUI:.gray)
                                    //                            }
                                    //                        }.padding()
                                }
                                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? geometry.size.width : .infinity, alignment: .center)
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
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(AppStyle.accentColor_SwiftUI)
                                .background(Circle().fill(Color.systemBackground))
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }.animation(.easeInOut, value: didCloseButtonTapped)
                            .padding()
                    }
                    .frame(width: 50, height: tabbarHeight)
                    .background(.clear)
                }
//                .frame(height: tabbarHeight).background(Color.systemBackground).cornerRadius(15.0).shadow(color: Color.label.opacity(0.3), radius: 5, x: 0, y: 2)
//                .frame(maxWidth: tabbarWidth)
//                .padding(.leading, 10)
//                .padding(.trailing, 10)
                .onChange(of: didShowDurationButtonCliked ){ value in
                    didShowDurationButtonCliked.toggle()
                    updateState(state: value)
                    heightConform = heightConfirm()
                    delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                }
                .onAppear{
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isVisible = true
                    }
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

//#Preview {
//    ParentContainerTabbar()
//}
