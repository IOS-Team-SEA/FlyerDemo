//
//  ParentContainer.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 14/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct ParentContainer: View {
    /* Model for Parent */
    @Binding var outputType: OutputType
    @ObservedObject var currentModel : ParentModel
    @ObservedObject var actionStates: ActionStates
    @ObservedObject var cpm : ControlPanelManager
   // @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
    
//    @State var animTempalate: [DBAnimationTemplateModel] = []
//    @State var animCategory: [DBAnimationCategoriesModel] = []
    
    /* Parent State for Managing Tabbar */
    @State var didLayersTabClicked : Bool    = false
    @State var didParentEditLayersTabClicked : Bool = false
    @State var didStickerTabClicked : Bool   = false
    @State var didTextTabClicked : Bool      = false
    @State var didImageTabClicked: Bool      = false
    
    /* Parent states when grouped */
    @State var didNudgeTabClicked : Bool     = false
    @State var didTransformTabClicked : Bool = false
    @State var didOpacityTabClicked : Bool   = false
    @State var didAnimationTabClicked : Bool = false
    @State var didDeleteTabClicked : Bool    = false
    @State var didCopyTabClicked : Bool      = false
    @State var didDuplicateTabClicked : Bool = false
    @State var didPasteTabClicked : Bool     = false
    @State var didLockUnclockTabClicked : Bool  = false
//    @State var didUngroupTabClicked : Bool   = false
    @State var didEditTabClicked : Bool      = false
    @State var didDoneTabClicked : Bool      = false
    @State var didGroupTabClicked : Bool     = false
//    @State var didShowDurationButtonCliked : Bool = false
    
    /* State for managing the panel */
    @State var showPanel : Bool = false
    
    /* Delegate for managing the height of the panel */
    weak var delegate : ContainerHeightProtocol?
//    var ratioSize: CGSize
    @Binding var ratioInfo: RatioInfo?
    
    @State var musicInfo: [MusicModel] = []
    @State var stickerInfo: [String:String] = [:]
    @State var uniqueCategories: [String] = []
    @State var currentText: String = ""
    @State var cropType: ImageCropperType = .ratios
    
    var body: some View {
        VStack{
            
            if didNudgeTabClicked  && !currentModel.editState{
                NudgePanelView(lockStatus: $currentModel.lockStatus, baseFrame: $currentModel.baseFrame, beginFrame: $currentModel.beginFrame, endFrame: $currentModel.endFrame, isNudgeAllowed: $actionStates.isNudgeAllowed).frame(height: panelHeight)
            }else if didOpacityTabClicked && !currentModel.editState{
                OpacityPanel(opacity: $currentModel.modelOpacity, showPanel: $showPanel, endOpacity: $currentModel.endOpacity, beginOpacity: $currentModel.beginOpacity, updateThumb: $actionStates.updateThumb).frame(height: panelHeight)
            }else if didAnimationTabClicked && !currentModel.editState{
                // TODO: Change duration with animation duration
              
                AnimationsPanelView(durationIN: $currentModel.inAnimationDuration, durationOUT: $currentModel.outAnimationDuration, durationLOOP: $currentModel.loopAnimationDuration, beginDurationIN: $currentModel.inAnimationBeginDuration, endDurationIN: $currentModel.inAnimationEndDuration, beginDurationOUT: $currentModel.outAnimationBeginDuration, endDurationOUT: $currentModel.outAnimationEndDuration, beginDurationLOOP: $currentModel.loopAnimationBeginDuration, endDurationLOOP: $currentModel.loopAnimationEndDuration,inAnimTemplate: $currentModel.inAnimation , outAnimTemplate: $currentModel.outAnimation,loopAnimTemplate: $currentModel.loopAnimation, lastSelectedAnimType: $actionStates.lastSelectedAnimType, lastSelectedCategoryId: $actionStates.lastSelectedCategoryId).frame(height: panelHeight)
                
            }else if didTransformTabClicked && !currentModel.editState{
                TransformPanel(flipHorizontal: $currentModel.modelFlipHorizontal, flipVertical: $currentModel.modelFlipVertical, lastSelectedFlipV: $cpm.lastSelectedFlipV, lastSelectedFlipH: $cpm.lastSelectedFlipH).frame(height: panelHeight)
            }else{
                Spacer()
            }
                
            
            if currentModel.editState{
                
                ParentEditContainerTabbar(didLayersTabClicked: $didParentEditLayersTabClicked, didStickerTabClicked: $didStickerTabClicked, didTextTabClicked: $didTextTabClicked, didDoneTabClicked: $currentModel.editState, didImageTabClicked: $didImageTabClicked, delegate: delegate).frame(height: containerDefaultHeight)
//                    .padding(.bottom, bottomPadding)
                    .frame(maxWidth: tabbarWidth)
                    .frame(height: tabbarHeight)
                    .onChange(of: didParentEditLayersTabClicked) { newValue in
                        if newValue == true{
                            cpm.didLayersTapped = true
                            didParentEditLayersTabClicked.toggle()
                        }
                    }
                
            }else{
                ParentContainerTabbar(templateType: $outputType, didLayersTabClicked: $didLayersTabClicked, didNudgeTabClicked: $didNudgeTabClicked, didTransformTabClicked: $didTransformTabClicked, didOpacityTabClicked: $didOpacityTabClicked, didAnimationTabClicked: $didAnimationTabClicked, didDeleteTabClicked: $currentModel.softDelete, didCopyTabClicked: $didCopyTabClicked, didDuplicateTabClicked: $didDuplicateTabClicked, didPasteTabClicked: $didPasteTabClicked, didLockUnclockTabClicked: $currentModel.lockStatus, didUngroupTabClicked: $actionStates.didUngroupTapped, didEditTabClicked: $currentModel.editState, didGroupTabClicked: $didGroupTabClicked, didShowDurationButtonCliked: $cpm.didShowDurationButtonCliked,lastSelectedTab: $actionStates.lastSelectedTextTab, didCloseButtonTapped: $cpm.didCloseTabbarTapped, showPanel: $showPanel, isCurrentModelDeleted: $actionStates.isCurrentModelDeleted, shouldRefreshOnAddComponent: $actionStates.shouldRefreshOnAddComponent, delegate: delegate).frame(height: containerDefaultHeight)
//                    .padding(.bottom, bottomPadding)
                    .frame(maxWidth: tabbarWidth)
                    .frame(height: tabbarHeight)
                    .onChange(of: didDuplicateTabClicked){ newValue in
                        if newValue == true{
                            print(" duplicate tapped")
//                            currentModel.duplicate = true
                            actionStates.duplicateModel = currentModel.modelId
                        }
                    }
                    .onChange(of: didCopyTabClicked){ newValue in
                        if newValue == true{
                            print(" Copy tapped")
//                            currentModel.copy = true
                            actionStates.copyModel = currentModel.modelId
                        }
                    }
                    .onChange(of: didPasteTabClicked){ newValue in
                        if newValue == true{
                            print(" paste tapped")
//                            currentModel.paste = true
                            if actionStates.copyModel != 0{
                                actionStates.pasteModel = true
                            }
                        }
                    }
                    .onChange(of: didLayersTabClicked) { newValue in
                        if newValue == true{
                            cpm.didLayersTapped = true
                            didLayersTabClicked.toggle()
                        }
                    }
                    .onChange(of: didGroupTabClicked){ newValue in
                        if newValue == true{
                            print(" group tapped")
                            actionStates.multiModeSelected = true
                        }
                    }
                    
            }
            
        }
        .frame(height: tabbarHeight)
        .background(Color.systemBackground)
//        .onChange(of: currentModel.editState){ newValue in
//            actionStates.parentEditState = newValue
//        }
        .fullScreenCover(isPresented: $didStickerTabClicked) {
            NavigationView {
                StickerPicker(/*stickerInfo: $stickerInfo, */newStickerAdded: $actionStates.addImage, isStickerPickerPresented: $didStickerTabClicked, uniqueCategories: $uniqueCategories, replaceSticker: $actionStates.addImage, updateThumb: $actionStates.updateThumb)//.environment(\.sizeCategory, .medium)
//                    .navigationTitle("Stickers")
//                    .onAppear(){
//                        
////                            uniqueCategories = DataSourceRepository.shared.getUniqueStickerCategories()
//                    }
//                    .navigationBarItems(trailing: Button(action: {
//                        // Action for done button
//                        didStickerTabClicked = false
//                    }) {
//                        VStack{
//                            SwiftUI.Image("ic_Close")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                        }
//                        .frame(width: 30, height: 30)
//                        .background(.white)
//                        .cornerRadius(15)
//                    })
                    .navigationTitle("Sticker_")//.environment(\.sizeCategory, .medium)
                    .navigationBarItems(trailing: Button(action: {
                        // Action for done button
                        didStickerTabClicked = false
                    }) {
                        VStack{
                            SwiftUI.Image("ic_Close")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .frame(width: 30, height: 30)
                        .background(.white)
                        .cornerRadius(15)
                    })
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
//        .halfSheet(showSheet: $didStickerTabClicked) {
////            if #available(iOS 16.0, *), UIDevice.current.userInterfaceIdiom == .pad{
////
////            }else{
//                NavigationView {
//                    StickerPicker(/*stickerInfo: $stickerInfo, */newStickerAdded: $actionStates.addImage, isStickerPickerPresented: $didStickerTabClicked, uniqueCategories: $uniqueCategories)
//                        .navigationTitle("Stickers")
//                        .onAppear(){
//                            
////                            uniqueCategories = DataSourceRepository.shared.getUniqueStickerCategories()
//                        }
//                        .navigationBarItems(trailing: Button(action: {
//                            // Action for done button
//                            didStickerTabClicked = false
//                        }) {
//                            VStack{
//                                SwiftUI.Image("ic_Close")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                            }
//                            .frame(width: 30, height: 30)
//                            .background(.white)
//                            .cornerRadius(15)
//                        })
//                }
//                .navigationViewStyle(.stack)
//                
////            }
//        }
//        onEnd: {
//            print("Dismis")
//            didStickerTabClicked.toggle()
//        }
        .sheet(isPresented: $didTextTabClicked) {
            NavigationView {
                TextEditorView(isTextPickerPresented: $didTextTabClicked, currentText: $currentText, updatedText: $actionStates.addNewText, updateThumb: $actionStates.updateThumb).environment(\.sizeCategory, .medium)
                    
            }
            .navigationViewStyle(.stack)
        }
//        .halfSheet(showSheet: $didTextTabClicked) {
//            NavigationView {
//                TextEditorView(isTextPickerPresented: $didTextTabClicked, currentText: $currentText, oldText: $oldText, newText: $actionStates.addNewText)
//                    
//            }
//            .navigationViewStyle(.stack)
//        }
//        onEnd: {
//            print("Dismis")
//            didTextTabClicked.toggle()
//        }
        .sheet(isPresented: $didImageTabClicked) {
//            CustomGalleryPickerView(isGalleryPickerPresented: $didImageTabClicked, addImage: $actionStates.addImage, replaceImage: $actionStates.replaceSticker, cropStyle: .ratios, aspectSize: ratioInfo!.ratioSize).interactiveDismissDisabled()
            
            CustomGalleryPickerView2(isGalleryPickerPresented: $didImageTabClicked, addImage: $actionStates.addImage, replaceImage: $actionStates.replaceSticker, cropStyle: .ratios, aspectSize: ratioInfo!.ratioSize,fixedAspectRatio: true , needFaceDetection: true)
                .presentationDetents([.height(150)])
            
        }
//        .halfSheet(showSheet: $didImageTabClicked) {
//            ImagePickerView(isImagePickerPresented: $didImageTabClicked, addImage: $actionStates.addImage, type: $cropType, ratioSize: ratioSize)
//        }
//        onEnd: {
//            print("Dismis")
//            didImageTabClicked.toggle()
//        }
        .onAppear(){
            // jay?
//            animTempalate = DBManager.shared.getAllAnimationTemplate()
//            animCategory = DBManager.shared.getAnimationCategory()
        }
        
    }
    
    
   
}

//#Preview {
//    ParentContainer()
//}




