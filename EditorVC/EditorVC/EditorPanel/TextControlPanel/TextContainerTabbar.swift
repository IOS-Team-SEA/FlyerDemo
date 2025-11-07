//
//  TextContainerTabbar.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 13/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct TextContainerTabbar: View {
    @State private var isVisible = false
    /* Panel State */
    @Binding var didReplaceTabClicked : Bool
    @Binding var didOpacityTabClicked : Bool
    @Binding var didPositionTabClicked : Bool
//    @Binding var didFlipVerticalTabClicked : Bool
//    @Binding var didFlipHorizontalTabClicked : Bool
    @Binding var didTransformTabClicked: Bool
    @Binding var didNudgeTabClicked : Bool
    @Binding var didAnimationTabClicked : Bool
    @Binding var didTextEditTabClicked : Bool
    @Binding var didFontStyleTabClicked : Bool
    @Binding var didTextSizeTabClicked : Bool
    @Binding var didTextColorTabClicked : Bool
    @Binding var didBackgroubdTabClicked : Bool
    @Binding var didTextFormatTabClicked : Bool
    @Binding var didSpacingTabClicked : Bool
    @Binding var didStrokeTabClicked : Bool
    @Binding var didShadowTabClicked : Bool
    @Binding var didDeleteTabClicked : Bool
    
    /* Action State */
    @Binding var didCopyTabClicked : Bool
    @Binding var didDuplicateTabClicked : Bool
    @Binding var didPasteTabClicked : Bool
    @State var didLockUnclockTabClicked : Bool
    @Binding var didGroupTabClicked : Bool
    @Binding var didUngroupTabClicked : Bool
    @Binding var didShowDurationButtonCliked : Bool
    @Binding var isLocked: Bool
    
    @Binding var lastSelectedTab: String
    @Binding var didCloseButtonTapped: Bool
    
    /* Show Panel State */
    @Binding var showPanel : Bool
    @State var heightConform : Bool = false
    @Binding var  isCurrentModelDeleted : Bool
    @Binding var shouldRefreshOnAddComponent: Bool
    
    /* Delegate for Size Management*/
    weak var delegate : ContainerHeightProtocol?
    
    @Binding var didFilterAdjustmentClicked : Bool
    @Binding var didColorAdjustmentClicked : Bool
    
    
    @State var templateType : OutputType = .Image
    
    //Height Confirm Function.
    func heightConfirm()-> Bool{
        if !didReplaceTabClicked && !didOpacityTabClicked && !didPositionTabClicked &&
            !didTransformTabClicked && !didNudgeTabClicked &&
            !didAnimationTabClicked && !didTextEditTabClicked && !didFontStyleTabClicked &&
            !didTextSizeTabClicked && !didTextColorTabClicked
            && !didBackgroubdTabClicked && !didTextFormatTabClicked && !didTextFormatTabClicked &&
            !didSpacingTabClicked && !didStrokeTabClicked
            && !didShadowTabClicked && !didDeleteTabClicked && !didFilterAdjustmentClicked && !didColorAdjustmentClicked
        {
            return false
        }
        else{
            return true
        }
    }
    
    // Function for updating the state.
    func updateState(state : Bool){
        if state != didOpacityTabClicked && didOpacityTabClicked{
            didOpacityTabClicked = false
        }
        if state != didPositionTabClicked && didPositionTabClicked{
            didPositionTabClicked = false
        }
//        if state != didFlipVerticalTabClicked && didFlipVerticalTabClicked{
//            didFlipVerticalTabClicked = false
//        }
//        if state != didFlipHorizontalTabClicked && didFlipHorizontalTabClicked{
//            didFlipHorizontalTabClicked = false
//        }
        if state != didTransformTabClicked && didTransformTabClicked{
            didTransformTabClicked = false
        }
        if state != didNudgeTabClicked && didNudgeTabClicked{
            didNudgeTabClicked = false
        }
        if state != didAnimationTabClicked && didAnimationTabClicked{
            didAnimationTabClicked = false
        }
        if state != didTextEditTabClicked && didTextEditTabClicked{
            didTextEditTabClicked = false
        }
        if state != didFontStyleTabClicked && didFontStyleTabClicked{
            didFontStyleTabClicked = false
        }
        if state != didTextSizeTabClicked && didTextSizeTabClicked{
            didTextSizeTabClicked = false
        }
        if state != didTextColorTabClicked && didTextColorTabClicked{
            didTextColorTabClicked = false
        }
        if state != didBackgroubdTabClicked && didBackgroubdTabClicked{
            didBackgroubdTabClicked = false
        }
        if state != didTextFormatTabClicked && didTextFormatTabClicked{
            didTextFormatTabClicked = false
        }
        if state != didSpacingTabClicked && didSpacingTabClicked{
            didSpacingTabClicked = false
        }
        if state != didStrokeTabClicked && didStrokeTabClicked{
            didStrokeTabClicked = false
        }
        if state != didShadowTabClicked && didShadowTabClicked{
            didShadowTabClicked = false
        }
        if state != didDeleteTabClicked && didDeleteTabClicked{
            didDeleteTabClicked = false
        }
        
        //Panel State
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
            HStack{
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal, showsIndicators: false){
                        if isVisible{
                            HStack(spacing: 0){
                                if templateType != .Image {
                                    Button{
                                        updateState(state: didAnimationTabClicked)
                                        didAnimationTabClicked.toggle()
                                        lastSelectedTab = "Animation"
                                        heightConform = heightConfirm()
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
                                    .padding()
                                }
                                Button{
                                    updateState(state: didTextColorTabClicked)
                                    didTextColorTabClicked.toggle()
                                    heightConform = heightConfirm()
                                    lastSelectedTab = "Color"
                                    delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                }label: {
                                    VStack{
                                        SwiftUI.Image(systemName: "paintpalette")
                                            .renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(didTextColorTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                            .frame(width: 25,height: 25)
                                            .foregroundColor(.gray)
                                        Text("Color_").font(.caption2
                                        ).foregroundColor(didTextColorTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didTextColorTabClicked)
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
                                        Text("Opacity_").font(.caption2
                                        ).foregroundColor(didOpacityTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didOpacityTabClicked)
                                }
                                .id("Opacity")
                                .frame(width: 60)
                                //                                    .padding()
                                
                                Button{
                                    updateState(state: didFontStyleTabClicked)
                                    didFontStyleTabClicked.toggle()
                                    heightConform = heightConfirm()
                                    lastSelectedTab = "Font"
                                    delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                }label: {
                                    VStack{
                                        SwiftUI.Image(systemName:"textformat").renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(didFontStyleTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                            .frame(width: 25,height: 25)
                                            .foregroundColor(.gray)
                                        Text("Font_").font(.caption2
                                        ).foregroundColor(didFontStyleTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didFontStyleTabClicked)
                                }
                                .id("Font")
                                .frame(width: 60)
                                //                                    .padding()
                                
                                Button{
                                    updateState(state: didTextFormatTabClicked)
                                    didTextFormatTabClicked.toggle()
                                    heightConform = heightConfirm()
                                    lastSelectedTab = "Format"
                                    delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                }label: {
                                    VStack{
                                        SwiftUI.Image(systemName: "textformat.characters.dottedunderline")
                                            .renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(didTextFormatTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                            .frame(width: 25,height: 25).foregroundColor(.gray)
                                        Text("Format_").font(.caption2
                                        ).foregroundColor(didTextFormatTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didTextFormatTabClicked)
                                }
                                .id("Format")
                                .frame(width: 60)
                                //                                    .padding()
                                
                                Button{
                                    updateState(state: didSpacingTabClicked)
                                    didSpacingTabClicked.toggle()
                                    heightConform = heightConfirm()
                                    lastSelectedTab = "Spacing"
                                    delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                }label: {
                                    VStack{
                                        SwiftUI.Image(systemName: "arrow.up.and.down.text.horizontal")
                                            .renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(didSpacingTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                            .frame(width: 25,height: 25)
                                            .foregroundColor(.gray)
                                        Text("Spacing_").font(.caption2
                                        ).foregroundColor(didSpacingTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didSpacingTabClicked)
                                }
                                .id("Spacing")
                                .frame(width: 60)
                                //                                    .padding()
                                
                                Button{
                                    updateState(state: didShadowTabClicked)
                                    didShadowTabClicked.toggle()
                                    heightConform = heightConfirm()
                                    lastSelectedTab = "Shadow"
                                    delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                }label: {
                                    VStack{
                                        SwiftUI.Image(systemName: "shadow")
                                            .renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(didShadowTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                            .frame(width: 25,height: 25)
                                            .foregroundColor(.gray)
                                        Text("Shadow_").font(.caption2
                                        ).foregroundColor(didShadowTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didShadowTabClicked)
                                }
                                .id("Shadow")
                                .frame(width: 60)
                                //                                    .padding()
                                
                                Button{
                                    updateState(state: didBackgroubdTabClicked)
                                    didBackgroubdTabClicked.toggle()
                                    //                        scrollToSelectedButton(scrollViewProxy: scrollViewProxy)
                                    lastSelectedTab = "Background"
                                    heightConform = heightConfirm()
                                    delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
                                }label: {
                                    VStack{
                                        SwiftUI.Image(systemName: "circle.rectangle.filled.pattern.diagonalline")
                                            .renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(didBackgroubdTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                            .frame(width: 25,height: 25)
                                            .foregroundColor(.gray)
                                        Text("Background_").font(.caption2
                                        ).foregroundColor(didBackgroubdTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didBackgroubdTabClicked)
                                }
                                .id("Background")
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
                                        Text("Nudge_").font(.caption2
                                        ).foregroundColor(didNudgeTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didNudgeTabClicked)
                                }
                                .id("Nudge")
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
                                            .renderingMode(.template).resizable()
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
                                            .renderingMode(.template).resizable()
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
                                    updateState(state: didTextEditTabClicked)
                                    didTextEditTabClicked.toggle()
                                    heightConform = heightConfirm()
                                    delegate?.didContainerHeightChanged(height: containerDefaultHeight )
                                }label: {
                                    VStack{
                                        SwiftUI.Image(systemName: "pencil").renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(didTextEditTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                            .frame(width: 25,height: 25).foregroundColor(.gray)
                                        Text("Text_Edit").font(.caption2
                                        ).foregroundColor(didTextEditTabClicked ?AppStyle.accentColor_SwiftUI:Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didTextEditTabClicked)
                                }
                                .frame(width: 60)
                                //                                    .padding()
                                
                                
                                
                                //                    Button{
                                //                        updateState(state: didDeleteTabClicked)
                                //                        didDeleteTabClicked.toggle()
                                //                        delegate?.didContainerHeightChanged(height:  containerDefaultHeight )
                                //                    }label: {
                                //                        VStack{
                                //                            SwiftUI.Image("delete").renderingMode(.template).resizable().foregroundColor(didDeleteTabClicked ?AppStyle.accentColor_SwiftUI:.gray).frame(width: 25,height: 25).foregroundColor(.gray)
                                //                            Text("Delete").font(.caption
                                //                            ).foregroundColor(didDeleteTabClicked ?AppStyle.accentColor_SwiftUI:.gray)
                                //                        }
                                //                    }
                                //                    .padding()
                                
                                
                                
                                //Actions Model
                                Button{
                                    updateState(state: didDuplicateTabClicked)
                                    didDuplicateTabClicked.toggle()
                                    delegate?.didContainerHeightChanged(height: containerDefaultHeight )
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
                                    delegate?.didContainerHeightChanged(height: containerDefaultHeight )
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
                                //                            delegate?.didContainerHeightChanged(height: containerDefaultHeight )
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
                                            .foregroundColor(Color("PanelIcon", bundle: .main))
                                            .frame(width: 25,height: 25)
                                            .foregroundColor(.gray)
                                        Text("Group_").font(.caption2
                                        ).foregroundColor(Color("PanelIcon", bundle: .main))
                                    }.animation(.easeInOut, value: didGroupTabClicked)
                                }
                                .frame(width: 60)
                                //                                    .padding()
                                
                                Button{
                                    updateState(state: didLockUnclockTabClicked)
                                    didLockUnclockTabClicked.toggle()
                                    isLocked.toggle()
                                    delegate?.didContainerHeightChanged(height: containerDefaultHeight )
                                }label: {
                                    VStack{
                                        SwiftUI.Image(systemName: didLockUnclockTabClicked ? "lock" : "lock.open")
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
                                        didDeleteTabClicked.toggle()
                                        shouldRefreshOnAddComponent = true
                                        isCurrentModelDeleted = true
                                        delegate?.didContainerHeightChanged(height:  containerDefaultHeight )
                                        
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
                                //
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
                        }
                    }
                    .onAppear(){
                        scrollToSelectedButton(scrollViewProxy: scrollViewProxy, scrollToTab: lastSelectedTab)
                        
                        if lastSelectedTab == "Background"{
                            didBackgroubdTabClicked.toggle()
                        }else if lastSelectedTab == "Opacity"{
                            didOpacityTabClicked.toggle()
                        }else if lastSelectedTab == "Flip"{
                            didTransformTabClicked.toggle()
                        }else if lastSelectedTab == "Nudge"{
                            didNudgeTabClicked.toggle()
                        }else if lastSelectedTab == "Animation"{
                            didAnimationTabClicked.toggle()
                        }else if lastSelectedTab == "Font"{
                            didFontStyleTabClicked.toggle()
                        }else if lastSelectedTab == "Color"{
                            didTextColorTabClicked.toggle()
                        }else if lastSelectedTab == "Format"{
                            didTextFormatTabClicked.toggle()
                        }else if lastSelectedTab == "Spacing"{
                            didSpacingTabClicked.toggle()
                        }else if lastSelectedTab == "Shadow"{
                            didShadowTabClicked.toggle()
                        }
                        heightConform = heightConfirm()
                        delegate?.didContainerHeightChanged(height: heightConform ? containerHeight : containerDefaultHeight )
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
                            //.shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .animation(.easeInOut, value: didCloseButtonTapped)
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
        .onAppear{
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

//#Preview {
//    TextContainerTabbar()
//}
