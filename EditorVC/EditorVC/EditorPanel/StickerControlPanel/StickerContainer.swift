//
//  StickerContainer.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 12/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct StickerContainer: View {
    // Sticker Info Contain the data like transform position and color.
    @ObservedObject var currentModel : StickerInfo
//    @State var animTempalate: [DBAnimationTemplateModel] = []
//    @State var animCategory: [DBAnimationCategoriesModel] = []
//    @State var templateColorArray: [UIColor] = []
    /*
     - Define the actions like :
          -Delete, Duplicate, Copy, Paste, Unlock/Lock, Group/UnGroup, Show/Duration.
     */
    @ObservedObject var currentActionModel : ActionStates
    @ObservedObject var cpm : ControlPanelManager
    
    /* Panel State */
    @State var didReplaceTabClicked : Bool        = false
    @State var didColorTabClicked : Bool          = false
    @State var didNudgeTabClicked : Bool          = false
    @State var didCropTabClicked : Bool           = false
    @State var didTransformTabClicked : Bool      = false
    @State var didOpacityTabClicked : Bool        = false
    @State var didPositionTabClicked : Bool       = false
    @State var didAnimationTabClicked : Bool      = false
    @State var didHueTabClicked : Bool            = false
    
    /* Action State */
    @State var didCopyTabClicked : Bool           = false
    @State var didDuplicateTabClicked : Bool      = false
    @State var didPasteTabClicked : Bool          = false
    @State var didLockUnclockTabClicked : Bool    = false
    @State var didGroupTabClicked : Bool          = false
    @State var didUngroupTabClicked : Bool        = false
    @State var didFilterAdjustmentClicked : Bool     = false
    @State var didColorAdjustmentClicked : Bool     = false
//    @State var didShowDurationButtonCliked : Bool = false
    
    @State var stickerInfo: [String:String] = [:]
    @State var uniqueCategories: [String] = []
    
    weak var delegate : ContainerHeightProtocol?
    @State var showPanel: Bool = true
    
    var body: some View {
        
        let cropperBinding = bindingForCropper(stickerImageContent: $currentActionModel.replaceSticker)
        
        VStack{
            if showPanel && didOpacityTabClicked {
                OpacityPanel(opacity: $currentModel.modelOpacity, showPanel: $showPanel, endOpacity: $currentModel.endOpacity, beginOpacity: $currentModel.beginOpacity, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }else if showPanel && didColorTabClicked{
                
                ColorPanel(templateID: currentModel.templateID, startColor: $currentModel.beginStickerFilter, endColor: $currentModel.endStickerFilter, colorFilter: $currentModel.stickerFilter, updateThumb: $currentActionModel.updateThumb,lastSelectedColor: $cpm.lastSelectedColor, thumbImage: $currentActionModel.pageModelArray.first!.thumbImage, showResetText: .constant(true)).frame(height: panelHeight)
            }else if didHueTabClicked{
                
                HuePanel(beginHue: $currentModel.beginStickerFilter, endHue: $currentModel.endStickerFilter, stickerFilter: $currentModel.stickerFilter, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }
            else if didCropTabClicked{
                
                CropperView(previousImage: currentModel.changeOrReplaceImage?.imageModel,replaceImage: $currentActionModel.replaceSticker, image: currentModel.getCropperImage(engineConfig: AppEngineConfigure()), cropRect: (currentActionModel.replaceSticker?.cropRect ?? CGRect(x: 0, y: 0, width: 1, height: 1))).frame(height: panelHeight)
            }
            else if didTransformTabClicked{
                TransformPanel(flipHorizontal: $currentModel.modelFlipHorizontal, flipVertical: $currentModel.modelFlipVertical, lastSelectedFlipV: $cpm.lastSelectedFlipV, lastSelectedFlipH: $cpm.lastSelectedFlipH).frame(height: panelHeight)
            }
            else if didAnimationTabClicked{
                AnimationsPanelView(durationIN: $currentModel.inAnimationDuration, durationOUT: $currentModel.outAnimationDuration, durationLOOP: $currentModel.loopAnimationDuration, beginDurationIN: $currentModel.inAnimationBeginDuration, endDurationIN: $currentModel.inAnimationEndDuration, beginDurationOUT: $currentModel.outAnimationBeginDuration, endDurationOUT: $currentModel.outAnimationEndDuration, beginDurationLOOP: $currentModel.loopAnimationBeginDuration, endDurationLOOP: $currentModel.loopAnimationEndDuration,inAnimTemplate: $currentModel.inAnimation , outAnimTemplate: $currentModel.outAnimation,loopAnimTemplate: $currentModel.loopAnimation, lastSelectedAnimType: $currentActionModel.lastSelectedAnimType, lastSelectedCategoryId: $currentActionModel.lastSelectedCategoryId).frame(height: panelHeight)

                    
            }else if didNudgeTabClicked{
                NudgePanelView(lockStatus: $currentModel.lockStatus,baseFrame: $currentModel.baseFrame, beginFrame: $currentModel.beginFrame, endFrame: $currentModel.endFrame, isNudgeAllowed: $currentActionModel.isNudgeAllowed).frame(height: panelHeight)
            }
            
            else if didFilterAdjustmentClicked{
                FilterAdjustmentView(selectedFilter: $currentModel.filterType, lastSelectedFilter: $cpm.lastSelectedFilter, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }else if didColorAdjustmentClicked{
                ColorAdjustMentView(brightness: $currentModel.brightnessIntensity, beginBrightness: $currentModel.beginBrightnessIntensity, endBrightness: $currentModel.endBrightnessIntensity, contrast: $currentModel.contrastIntensity, beginContrast: $currentModel.beginContrastIntensity, endContrast: $currentModel.endContrastIntensity, highlight: $currentModel.highlightIntensity, beginHighlight: $currentModel.beginHighlightIntensity, endHighlight: $currentModel.endHighlightIntensity, shadows: $currentModel.shadowsIntensity, beginShadows: $currentModel.beginShadowsIntensity, endShadows: $currentModel.endShadowsIntensity, saturation: $currentModel.saturationIntensity, beginSaturation: $currentModel.beginSaturationIntensity, endSaturation: $currentModel.endSaturationIntensity, vibrance: $currentModel.vibranceIntensity, beginVibrance: $currentModel.beginVibranceIntensity, endVibrance: $currentModel.endVibranceIntensity, sharpness: $currentModel.sharpnessIntensity, beginSharpness: $currentModel.beginSharpnessIntensity, endSharpness: $currentModel.endSharpnessIntensity, warmth: $currentModel.warmthIntensity, beginWarmth: $currentModel.beginWarmthIntensity, endWarmth: $currentModel.endWarmthIntensity, tint: $currentModel.tintIntensity, beginTint: $currentModel.beginTintIntensity, endTint: $currentModel.endTintIntensity, selectedColorAdjustment: $currentModel.colorAdjustmentType, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }
            
            else{
                Spacer()
            }
            
            StcikerContainreTabBar(didReplaceTabClicked: $didReplaceTabClicked, didColorTabClicked: $didColorTabClicked, didHueTabClicked: $didHueTabClicked, didNudgeTabClicked: $didNudgeTabClicked, didCropTabClicked: $didCropTabClicked, didTransformTabClicked: $didTransformTabClicked, didOpacityTabClicked: $didOpacityTabClicked, didPositionTabClicked: $didPositionTabClicked, didAnimationTabClicked: $didAnimationTabClicked, didDeleteTabClicked: $currentModel.softDelete, didCopyTabClicked: $didCopyTabClicked, didDuplicateTabClicked: $didDuplicateTabClicked, didPasteTabClicked: $didPasteTabClicked, didLockUnclockTabClicked: $currentModel.lockStatus, didGroupTabClicked: $didGroupTabClicked, didUngroupTabClicked: $didUngroupTabClicked, didShowDurationButtonCliked: $cpm.didShowDurationButtonCliked,lastSelectedTab: $currentActionModel.lastSelectedTextTab, didCloseButtonTapped: $cpm.didCloseTabbarTapped, showPanel: $showPanel, isCurrentModelDeleted: $currentActionModel.isCurrentModelDeleted, shouldRefreshOnAddComponent: $currentActionModel.shouldRefreshOnAddComponent, delegate: delegate, didFilterAdjustmentClicked: $didFilterAdjustmentClicked, didColorAdjustmentClicked: $didColorAdjustmentClicked).frame(height: containerDefaultHeight)
                .frame(maxWidth: tabbarWidth)
                .frame(height: tabbarHeight)
//                .padding(.bottom, bottomPadding)
                .onChange(of: didDuplicateTabClicked){ newValue in
                    if newValue == true{
                        print(" duplicate tapped")
//                        currentModel.duplicate = true
                        currentActionModel.duplicateModel = currentModel.modelId
                    }
                }
                .onChange(of: didCopyTabClicked){ newValue in
                    if newValue == true{
                        print(" Copy tapped")
//                        currentModel.copy = true
                        currentActionModel.copyModel = currentModel.modelId
                    }
                }
                .onChange(of: didPasteTabClicked){ newValue in
                    if newValue == true{
                        print(" paste tapped")
//                        currentModel.paste = true
                        if currentActionModel.copyModel != 0{
                            currentActionModel.pasteModel = true
                        }
                    }
                }
                .onChange(of: didGroupTabClicked){ newValue in
                    if newValue == true{
                        print(" group tapped")
                        currentActionModel.multiModeSelected = true
                    }
                }
                
        }
//        .ignoresSafeArea()
        .frame(height: tabbarHeight)
        .background(Color.systemBackground)
        .fullScreenCover(isPresented: $didReplaceTabClicked) {
            NavigationView {
                let previousReplaceModel = currentModel.changeOrReplaceImage!.imageModel
//                StickerPicker(/*stickerInfo: $stickerInfo, */newStickerAdded: $currentActionModel.replaceSticker, isStickerPickerPresented: $didReplaceTabClicked, uniqueCategories: $uniqueCategories, ratioInfo: $ratioInfo, replaceSticker: $currentModel.stickerImageContent, updateThumb: $currentActionModel.updateThumb)
                
                StickerPicker(/*stickerInfo: $stickerInfo, */newStickerAdded: $currentActionModel.replaceSticker, isStickerPickerPresented: $didReplaceTabClicked, uniqueCategories: $uniqueCategories, previousSticker: previousReplaceModel, replaceSticker: $currentActionModel.replaceSticker, updateThumb: $currentActionModel.updateThumb)
                
                    .navigationTitle("Stickers")
                    .navigationBarItems(trailing: Button(action: {
                        // Action for done button
                        didReplaceTabClicked = false
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
                    .environment(\.sizeCategory, .medium)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
//            .halfSheet(showSheet: $didReplaceTabClicked) {
//                NavigationView {
//                    StickerPicker(/*stickerInfo: $stickerInfo, */newStickerAdded: $currentActionModel.replaceSticker, isStickerPickerPresented: $didReplaceTabClicked, uniqueCategories: $uniqueCategories)
//                        .navigationTitle("Stickers")
//                        .navigationBarItems(trailing: Button(action: {
//                            // Action for done button
//                            didReplaceTabClicked = false
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
//            }
//            onEnd: {
//                print("Dismis")
//                didReplaceTabClicked.toggle()
//            }
            .onAppear(){
                // Jay?
                // on appear of animation panel view
//                animTempalate = DBManager.shared.getAllAnimationTemplate()
//                animCategory = DBManager.shared.getAnimationCategory()
//                templateColorArray = DataSourceRepository.shared.getTemplateColorArray(templateID: currentModel.templateID)
                
//                let stickerImages = StickerDBManager.shared.getStickerImages()
//                
//                let stickerInfoMap = StickerDBManager.shared.getStickerInfo(resID: stickerImages)
//
//                uniqueCategories = Array(Set(stickerInfoMap.values)).sorted()
//                stickerInfo = stickerInfoMap
                
//                uniqueCategories = DataSourceRepository.shared.getUniqueStickerCategories()
            }
        
    }
    
    func bindingForCropper(stickerImageContent: Binding<ImageModel?>) -> Binding<CGRect> {
        return Binding<CGRect>(
            get: {
                if let imageModel = stickerImageContent.wrappedValue {
                    return imageModel.cropRect
                } else {
                    return CGRect(x: 0, y: 0, width: 1, height: 1)
                }
            },
            set: { newValue in
                if var imageModel = stickerImageContent.wrappedValue {
                    imageModel.cropRect = newValue
                    imageModel.cropType = currentModel.cropStyle
                    imageModel.tileMultiple = 0.0
                    imageModel.localPath = currentModel.changeOrReplaceImage?.imageModel.localPath ?? ""
                    imageModel.serverPath = currentModel.changeOrReplaceImage?.imageModel.serverPath ?? ""
                    imageModel.sourceType = currentModel.changeOrReplaceImage?.imageModel.sourceType ?? .BUNDLE
                    stickerImageContent.wrappedValue = imageModel
                }else{
                    if currentModel.sourceType == .BUNDLE{
                        //                    stickerImageContent.wrappedValue?.cropRect = newValue
                        stickerImageContent.wrappedValue = ImageModel(imageType:.IMAGE, serverPath: "", localPath: currentModel.changeOrReplaceImage?.imageModel.localPath ?? "", cropRect: newValue, sourceType: .BUNDLE, tileMultiple: 0.0, cropType: currentModel.cropStyle,imageWidth: 300,imageHeight: 300)
                    }else if currentModel.sourceType == .DOCUMENT{
                        stickerImageContent.wrappedValue = ImageModel(imageType:.IMAGE, serverPath: "", localPath: currentModel.changeOrReplaceImage?.imageModel.localPath ?? "", cropRect: newValue, sourceType: .DOCUMENT, tileMultiple: 0.0, cropType: currentModel.cropStyle,imageWidth: 300,imageHeight: 300)
                    }else{
                        stickerImageContent.wrappedValue = ImageModel(imageType:.IMAGE, serverPath: currentModel.changeOrReplaceImage?.imageModel.serverPath ?? "", localPath: "", cropRect: newValue, sourceType: .SERVER, tileMultiple: 0.0, cropType: currentModel.cropStyle,imageWidth: 300,imageHeight: 300)
                    }
                }
            }
        )
    }
}

//#Preview {
//    StickerContainer()
//}
