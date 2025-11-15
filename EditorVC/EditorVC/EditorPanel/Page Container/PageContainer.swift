//
//  PageContainer.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 05/04/24.
//

import SwiftUI
import IOS_CommonEditor

struct PageContainer: View {
    
    @ObservedObject var currentModel: PageInfo
    @StateObject var actionStates: ActionStates
    @StateObject var cpm: ControlPanelManager
    @State var didLayersTabClicked : Bool    = false
    @State var didMusicTabClicked: Bool      = false
    @State var didBGTabClicked : Bool        = false
    @State var didStickerTabClicked : Bool   = false
    @State var didTextTabClicked : Bool      = false
    @State var didImageTabClicked: Bool      = false
    @State var didColorTabClikced : Bool       = false
    @State var didGradientTabClikced: Bool     = false
    @State var didBackgroundTabClikced : Bool  = false
    @State var didTextureTabClikced : Bool     = false
    @State var didGalleryTabClikced : Bool     = false
    @State var didBlurTabClikced : Bool        = false
    @State var didOverlayTabClikced : Bool     = false
    @State var didFilterAdjustmentClicked : Bool     = false
    @State var didColorAdjustmentClicked : Bool     = false
    @State var didShapesClicked : Bool     = false

    
    @State var didGifTabClicked : Bool     = false
    weak var delegate : ContainerHeightProtocol?
    @Binding var ratioInfo: RatioInfo?
    @State var musicInfo: [MusicModel] = []
    @State var stickerInfo: [String:String] = [:]
    @State var uniqueCategories: [String] = []
    @State var currentText: String = ""
    @State var cropType: ImageCropperType = .custom
    @State var bgImageModel: ImageModel?
    @State var addNewImageModel: ImageModel?
    
    
    var body: some View {
        let userImageBinding = bindingForImageValue(bg: $currentModel.bgContent)
        let endUserImageBinding = bindingForImageValue(bg: $currentModel.endBgContent)
        
        VStack{
    
            if didColorTabClikced{
                TextColorPanel(templateID: currentModel.templateID, startColor: $currentModel.beginBgContent, endColor: $currentModel.endBgContent, colorFilter: $currentModel.bgContent, showReset: false, updateThumb: $actionStates.updatePageAndParentThumb,lastSelectedBGColor: $cpm.lastSelectedBGColor, thumbImage: $actionStates.pageModelArray.first!.thumbImage, textBGType: .constant(0)).frame(height: panelHeight)
            }else if didGradientTabClikced{
                GradientPanelView(beginBgContent: $currentModel.beginBgContent, endBgContent: $currentModel.endBgContent, gradient: $currentModel.bgContent, thumbImage: $actionStates.pageModelArray.first!.thumbImage, updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight)
            }else if didBackgroundTabClikced{
                BGControlPanelView(imageType: $currentModel.imageType, wallpaper: $currentModel.bgContent, lastSelectedBGContent: $cpm.lastSelctedBGContent, endBGContent: $currentModel.endBgContent, /*ratioSize: ratioSize*/ratioSize: ratioInfo?.ratioSize ?? CGSize(width: 1, height: 1), updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight).environmentObject(UIStateManager.shared)
            }else if didTextureTabClikced{
                TexturePanelView(tileSize: $currentModel.tileMultiple, imageType: $currentModel.imageType, beginTileMultiple: $currentModel.beginTileMultiple, endTileMultiple: $currentModel.endTileMultiple, textureBG: $currentModel.bgContent, endBgContent: $currentModel.endBgContent, lastSelectedBGContent: $cpm.lastSelctedBGContent, refSize: ratioInfo?.ratioSize ?? CGSize(width: 1, height: 1), updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight).environmentObject(UIStateManager.shared)
            }else if didBlurTabClikced{
//                BlurPanelView(blur: $currentModel.bgBlurProgress, beginBlur: $currentModel.beginBlur, endBlur: $currentModel.endBlur, updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight)
                OpacityPanel(opacity: $currentModel.modelOpacity, showPanel: $didBlurTabClikced, endOpacity: $currentModel.endOpacity, beginOpacity: $currentModel.beginOpacity, updateThumb: $actionStates.updateThumb).frame(height: panelHeight)
                
            }else if didOverlayTabClikced{
                OverlayPanelView(opacity: $currentModel.overlayOpacity, beginOverlayOpacity: $currentModel.beginOverlayOpacity, endOverlayOpacity: $currentModel.endOverlayOpacity, imageType: $currentModel.overlayType, overlayBG: $currentModel.bgOverlayContent, endBgContent: $currentModel.endOverlayContent, lastSelectedOverlay: $cpm.lastSelctedOverlayContent, refSize: ratioInfo?.ratioSize ?? CGSize(width: 1, height: 1), updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight)
            }else if didFilterAdjustmentClicked{
                FilterAdjustmentView(selectedFilter: $currentModel.filterType, lastSelectedFilter: $cpm.lastSelectedFilter, updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight)
            }else if didColorAdjustmentClicked{
                ColorAdjustMentView(brightness: $currentModel.brightnessIntensity, beginBrightness: $currentModel.beginBrightnessIntensity, endBrightness: $currentModel.endBrightnessIntensity, contrast: $currentModel.contrastIntensity, beginContrast: $currentModel.beginContrastIntensity, endContrast: $currentModel.endContrastIntensity, highlight: $currentModel.highlightIntensity, beginHighlight: $currentModel.beginHighlightIntensity, endHighlight: $currentModel.endHighlightIntensity, shadows: $currentModel.shadowsIntensity, beginShadows: $currentModel.beginShadowsIntensity, endShadows: $currentModel.endShadowsIntensity, saturation: $currentModel.saturationIntensity, beginSaturation: $currentModel.beginSaturationIntensity, endSaturation: $currentModel.endSaturationIntensity, vibrance: $currentModel.vibranceIntensity, beginVibrance: $currentModel.beginVibranceIntensity, endVibrance: $currentModel.endVibranceIntensity, sharpness: $currentModel.sharpnessIntensity, beginSharpness: $currentModel.beginSharpnessIntensity, endSharpness: $currentModel.endSharpnessIntensity, warmth: $currentModel.warmthIntensity, beginWarmth: $currentModel.beginWarmthIntensity, endWarmth: $currentModel.endWarmthIntensity, tint: $currentModel.tintIntensity, beginTint: $currentModel.beginTintIntensity, endTint: $currentModel.endTintIntensity, selectedColorAdjustment: $currentModel.colorAdjustmentType, updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight)
            }else if didShapesClicked{
              //  ShapesPanelView(refSize: <#T##CGSize#>, uiStateManager: <#T##UIStateManager#>, updateThumb: <#T##Bool#>)
//                TexturePanelView(tileSize: $currentModel.tileMultiple, imageType: $currentModel.imageType, beginTileMultiple: $currentModel.beginTileMultiple, endTileMultiple: $currentModel.endTileMultiple, textureBG: $currentModel.bgContent, endBgContent: $currentModel.endBgContent, lastSelectedBGContent: $actionStates.lastSelctedBGContent, refSize: ratioInfo?.ratioSize ?? CGSize(width: 1, height: 1), updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight).environmentObject(UIStateManager.shared)
                ShapesPanelView(selectedShape: $currentModel.maskShape, lastSelectedshape: $currentModel.maskShape, refSize: ratioInfo!.ratioSize,  updateThumb: $actionStates.updatePageAndParentThumb).frame(height: panelHeight).environmentObject(UIStateManager.shared)
            }
            else{
                Spacer()
            }
            
            if didBGTabClicked{
                BGContainerTabbar(didColorTabClicked: $didColorTabClikced, didGradientTabClicked: $didGradientTabClikced, didBackgroundTabClicked: $didBackgroundTabClikced, didTextureTabClicked: $didTextureTabClikced, didGalleryTabClicked: $didGalleryTabClikced, didBlurTabClicked: $didBlurTabClikced, didOverlayTabClicked: $didOverlayTabClikced, didFilterAdjustmentClicked: $didFilterAdjustmentClicked, didColorAdjustmentClicked: $didColorAdjustmentClicked, didFilterShapesClicked: $didShapesClicked, lastSelectedTab: $cpm.lastSelectedBGTab, didCloseButtonTapped: $didBGTabClicked, delegate: delegate).frame(height: containerDefaultHeight)
                    .frame(maxWidth: tabbarWidth)
                    .frame(height: tabbarHeight)
                   
            }else{
                PageContainerTabbar(didLayersTabClicked: $didLayersTabClicked, didBGTabClicked: $didBGTabClicked, didStickerTabClicked: $didStickerTabClicked, didTextTabClicked: $didTextTabClicked, didMusicTabClicked: $didMusicTabClicked, didImageTabClicked: $didImageTabClicked, didGifTabClicked: $didGifTabClicked, delegate: delegate).frame(height: tabbarHeight)
                    .frame(maxWidth: tabbarWidth)
                    .frame(height: tabbarHeight)
                    
                    .onChange(of: didLayersTabClicked) { newValue in
                        if newValue == true{
                            cpm.didLayersTapped = true
                            didLayersTabClicked.toggle()
                        }
                    }
            }
            
                
        }
            .frame(height: tabbarHeight)
            .background(Color.systemBackground)
        
        .sheet(isPresented: $didMusicTabClicked) {
            MusicPicker(MusicInfo: $musicInfo, newMusicAdded: $actionStates.addNewMusicModel, isMusicPickerPresented: $didMusicTabClicked).environment(\.sizeCategory, .medium)
                .onAppear(){
                    musicInfo = DBManager.shared.fetchAllMusicModel()
                }
        }
        .sheet(isPresented: $didImageTabClicked) {
//            CustomGalleryPickerView(isGalleryPickerPresented: $didImageTabClicked, addImage: $actionStates.addImage, previousImage: currentModel.changeOrReplaceImage?.imageModel,replaceImage: $actionStates.replaceSticker, cropStyle: .ratios, aspectSize: ratioInfo!.ratioSize).interactiveDismissDisabled()
            
            CustomGalleryPickerView2(isGalleryPickerPresented: $didImageTabClicked, addImage: $actionStates.addImage, previousImage: currentModel.changeOrReplaceImage?.imageModel,replaceImage: $actionStates.replaceSticker, cropStyle: .ratios, aspectSize: ratioInfo!.ratioSize,fixedAspectRatio: true , needFaceDetection: true)
                .presentationDetents([.height(150)])
        }
        .sheet(isPresented: $didGifTabClicked) {
            GifStickerPicker().environment(\.sizeCategory, .medium)
        }
        .fullScreenCover(isPresented: $didStickerTabClicked) {
            NavigationView {
                StickerPicker(/*stickerInfo: $stickerInfo, */newStickerAdded: $actionStates.addImage, isStickerPickerPresented: $didStickerTabClicked, uniqueCategories: $uniqueCategories, replaceSticker: $actionStates.addImage, updateThumb: $actionStates.updateThumb)
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
                    .onAppear(){
                        
//                            uniqueCategories = DataSourceRepository.shared.getUniqueStickerCategories()
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
//        .halfSheet(showSheet: $didStickerTabClicked) {
////            if #available(iOS 16.0, *), UIDevice.current.userInterfaceIdiom == .pad{
////                
////            }else{
//                NavigationView {
//                    StickerPicker(/*stickerInfo: $stickerInfo, */newStickerAdded: $actionStates.addImage, isStickerPickerPresented: $didStickerTabClicked, uniqueCategories: $uniqueCategories)
//                        .navigationTitle("Sticker_")
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
//                        .onAppear(){
//                            
////                            uniqueCategories = DataSourceRepository.shared.getUniqueStickerCategories()
//                        }
//                }
//                .navigationViewStyle(.stack)
//                
////            }
//        }
//        onEnd: {
//            print("Dismis")
//            didStickerTabClicked.toggle()
//        }
        .onChange(of: didTextTabClicked) { newValue in
            actionStates.addNewText = "Enter Your Text Here."
        }
//        .sheet(isPresented: $didTextTabClicked) {
//            NavigationView {
//                actionStates.addNewText = "Enter Your Text Here."
//                TextEditorView(isTextPickerPresented: $didTextTabClicked, currentText: $currentText, updatedText: $actionStates.addNewText, oldText: $oldText, newText: $actionStates.addNewText)
//                    
//            }
//            .navigationViewStyle(.stack)
//        }
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
        .onAppear(){
//            templateColorArray = DataSourceRepository.shared.getTemplateColorArray(templateID: currentModel.templateID)
            if !didBGTabClicked{
                cropType = .ratios
            }else{
                cropType = .custom
            }
        }
        .onChange(of: didBGTabClicked){ newValue in
            if newValue == false{
                cropType = .ratios
            }else{
                cropType = .custom
            }
        }
        .sheet(isPresented: $didGalleryTabClikced) {
//            ImagePickerView(isImagePickerPresented: $didGalleryTabClikced, addImage: $bgImageModel, previousImage: $bgImageModel, replaceImage: $bgImageModel/*userImageBinding*/, type: $cropType, /*ratioSize: ratioSize*/ratioInfo: $ratioInfo, updateThumb: $actionStates.updatePageAndParentThumb).environment(\.sizeCategory, .medium)
            var previosImageModel = (currentModel.bgContent as? BGUserImage)?.content ?? nil
//            CustomGalleryPickerView(isGalleryPickerPresented: $didGalleryTabClikced, addImage: $bgImageModel, previousImage: previosImageModel,replaceImage: $bgImageModel, cropStyle: .custom, aspectSize: ratioInfo!.ratioSize).interactiveDismissDisabled()
            
            CustomGalleryPickerView2(isGalleryPickerPresented: $didGalleryTabClikced, addImage: $bgImageModel, previousImage: previosImageModel,replaceImage: $bgImageModel, cropStyle: .custom, aspectSize: ratioInfo!.ratioSize,fixedAspectRatio: true , needFaceDetection: true)
                .presentationDetents([.height(150)])
        }
//        .halfSheet(showSheet: $didGalleryTabClikced) {
//            ImagePickerView(isImagePickerPresented: $didGalleryTabClikced, addImage: $bgImageModel/*userImageBinding*/, type: $cropType, ratioSize: ratioSize)
//        } onEnd: {
//            didGalleryTabClikced.toggle()
//        }
        .onChange(of: addNewImageModel) { newImageModel in
            actionStates.addImage = newImageModel
        }
        .onChange(of: bgImageModel) { newImageModel in
            endUserImageBinding.wrappedValue = newImageModel
            userImageBinding.wrappedValue = newImageModel
        }
        
    }
    
    func bindingForImageValue(bg: Binding<AnyBGContent?>) -> Binding<ImageModel?> {
        return Binding<ImageModel?>(
            get: {
                if let userImage = bg.wrappedValue as? BGUserImage {
                    return userImage.content
                } else {
                    return nil
                }
            },
            set: { newValue in
                if var bgModel = bg.wrappedValue as? BGUserImage {
                    bgModel.content = newValue!
                    bg.wrappedValue = bgModel
                } else {
                    bg.wrappedValue = BGUserImage(content: newValue ?? ImageModel(imageType: .IMAGE, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .DOCUMENT, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300))
                }
            }
        )
    }
    
}

