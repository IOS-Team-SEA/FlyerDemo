//
//  TextContainer.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 13/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct TextContainer: View {
    
    @Binding var outputType: OutputType
    // Text Info Contain the data like transform position and color.
    @ObservedObject var currentModel : TextInfo
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
    @State var didOpacityTabClicked : Bool        = false
    @State var didPositionTabClicked : Bool       = false
//    @State var didFlipVerticalTabClicked : Bool   = false
//    @State var didFlipHorizontalTabClicked : Bool = false
    @State var didTransformTabClicked : Bool      = false
    @State var didNudgeTabClicked : Bool          = false
    @State var didAnimationTabClicked : Bool      = false
    @State var didTextEditTabClicked : Bool       = false
    @State var didFontStyleTabClicked : Bool      = false
    @State var didTextSizeTabClicked : Bool       = false
    @State var didTextColorTabClicked : Bool      = false
    @State var didBackgroubdTabClicked : Bool     = false
    @State var didTextFormatTabClicked : Bool     = false
    @State var didSpacingTabClicked : Bool        = false
    @State var didStrokeTabClicked : Bool         = false
    @State var didShadowTabClicked : Bool         = false
    @State var didDeleteTabClicked : Bool         = false
    
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
    
    /* Show Panel State */
    @State var showPanel : Bool = true
    
    /* Delegate for Height */
   weak var delegate : ContainerHeightProtocol?
    
    
    var body: some View {
        VStack{
            if showPanel && didOpacityTabClicked {
//                OpacityPanel(opacity: $currentModel.modelOpacity, showPanel: $showPanel, endOpacity: $currentActionModel.endOpacity, beginOpacity: $currentActionModel.beginOpacity).frame(height: 125).animation(.bouncy())
                OpacityPanel(opacity: $currentModel.modelOpacity, showPanel: $showPanel, endOpacity: $currentModel.endOpacity, beginOpacity: $currentModel.beginOpacity, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }else if didBackgroubdTabClicked{
                BGPanelView(bgAplha: $currentModel.bgAlpha, endbgAlpha: $currentModel.endBGAlpha, beginBgAlpha: $currentModel.beginBGAlpha, startColor: $currentModel.beginTextBGContent, endColor: $currentModel.endTextBGContent, colorFilter: $currentModel.textBGContent, templateID: currentModel.templateID, updatePageAndParentThumb: $currentActionModel.updateThumb, lastSelectedBGButton: $cpm.lastSelectedBGButton,lastSelectedBGColor: $cpm.lastSelectedBGColor, thumbImage: $currentActionModel.pageModelArray.first!.thumbImage, textBGType: $currentModel.bgType).frame(height: panelHeight)
            }else if didTextFormatTabClicked{
                FormatPanelView(alignment: $currentModel.textGravity, lastSelectedAlignment: $cpm.lastSelectedFormatButton, text: $currentModel.text, updatedText: $currentActionModel.updatedText, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }else if didSpacingTabClicked{
                SpacingView(letterSpacing: $currentModel.letterSpacing, lineSpacing: $currentModel.lineSpacing, beginLetterSpacing: $currentModel.beginLetterSpacing, endLetterSpacing: $currentModel.endLetterSpacing, beginLineSpacing: $currentModel.beginLineSpacing, endLineSpacing: $currentModel.endLineSpacing, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }else if didTransformTabClicked{
                TransformPanel(flipHorizontal: $currentModel.modelFlipHorizontal, flipVertical: $currentModel.modelFlipVertical, lastSelectedFlipV: $cpm.lastSelectedFlipV, lastSelectedFlipH: $cpm.lastSelectedFlipH).frame(height: panelHeight)
            }else if didShadowTabClicked{
                ShadowPanelView(dx: $currentModel.shadowDx, dy: $currentModel.shadowDy, beginDx: $currentModel.beginDx, beginDy: $currentModel.beginDy, endDx: $currentModel.endDx, endDy: $currentModel.endDy, shadowOpacity: $currentModel.shadowRadius, beginShadowOpacity: $currentModel.beginShadowOpacity, endShadowOpacity: $currentModel.endShadowOpacity, startColor: $currentModel.beginTextShadowColorFilter, endColor: $currentModel.endTextShadowColorFilter, lastShadowSelectedButton: $cpm.lastSelectedShadowButton, templateID: currentModel.templateID, colorFilter: $currentModel.textShadowColorFilter, updateThumb: $currentActionModel.updateThumb,lastSelectedColor: $cpm.lastSelectedColor, thumbImage: $currentActionModel.pageModelArray.first!.thumbImage).frame(height: panelHeight)
            }else if didFontStyleTabClicked{
                FontsPicker(currentFont: $currentModel.textFont, lastSelectedFont: $cpm.lastSelectedFont, fontName: $currentModel.fontName, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }else if didNudgeTabClicked{
                NudgePanelView(lockStatus: $currentModel.lockStatus,baseFrame: $currentModel.baseFrame, beginFrame: $currentModel.beginFrame, endFrame: $currentModel.endFrame, isNudgeAllowed: $currentActionModel.isNudgeAllowed).frame(height: panelHeight)
            }else if didTextColorTabClicked{
                TextColorPanel(templateID: currentModel.templateID, startColor: $currentModel.beginTextContentColor, endColor: $currentModel.endTextContentColor, colorFilter: $currentModel.textContentColo, showReset: false, updateThumb: $currentActionModel.updateThumb,lastSelectedBGColor: $cpm.lastSelectedBGColor, thumbImage: $currentActionModel.pageModelArray.first!.thumbImage, textBGType: $currentModel.bgType).frame(height: panelHeight)
            }else if didAnimationTabClicked{
                // TODO: Change internalHeightMargin with animation duration
//                AnimationsPanelView(animationTemplate: $animTempalate, animationCategories: $animCategory, duration: $currentModel.internalHeightMargin, beginDuration: $currentActionModel.beginDuration, endDuration: $currentActionModel.endDuration).frame(height: 125)
                AnimationsPanelView(durationIN: $currentModel.inAnimationDuration, durationOUT: $currentModel.outAnimationDuration, durationLOOP: $currentModel.loopAnimationDuration, beginDurationIN: $currentModel.inAnimationBeginDuration, endDurationIN: $currentModel.inAnimationEndDuration, beginDurationOUT: $currentModel.outAnimationBeginDuration, endDurationOUT: $currentModel.outAnimationEndDuration, beginDurationLOOP: $currentModel.loopAnimationBeginDuration, endDurationLOOP: $currentModel.loopAnimationEndDuration,inAnimTemplate: $currentModel.inAnimation , outAnimTemplate: $currentModel.outAnimation,loopAnimTemplate: $currentModel.loopAnimation, lastSelectedAnimType: $currentActionModel.lastSelectedAnimType, lastSelectedCategoryId: $currentActionModel.lastSelectedCategoryId).frame(height: panelHeight)

                    
            }else if didFilterAdjustmentClicked{
                FilterAdjustmentView(selectedFilter: $currentModel.filterType, lastSelectedFilter: $cpm.lastSelectedFilter, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }else if didColorAdjustmentClicked{
                ColorAdjustMentView(brightness: $currentModel.brightnessIntensity, beginBrightness: $currentModel.beginBrightnessIntensity, endBrightness: $currentModel.endBrightnessIntensity, contrast: $currentModel.contrastIntensity, beginContrast: $currentModel.beginContrastIntensity, endContrast: $currentModel.endContrastIntensity, highlight: $currentModel.highlightIntensity, beginHighlight: $currentModel.beginHighlightIntensity, endHighlight: $currentModel.endHighlightIntensity, shadows: $currentModel.shadowsIntensity, beginShadows: $currentModel.beginShadowsIntensity, endShadows: $currentModel.endShadowsIntensity, saturation: $currentModel.saturationIntensity, beginSaturation: $currentModel.beginSaturationIntensity, endSaturation: $currentModel.endSaturationIntensity, vibrance: $currentModel.vibranceIntensity, beginVibrance: $currentModel.beginVibranceIntensity, endVibrance: $currentModel.endVibranceIntensity, sharpness: $currentModel.sharpnessIntensity, beginSharpness: $currentModel.beginSharpnessIntensity, endSharpness: $currentModel.endSharpnessIntensity, warmth: $currentModel.warmthIntensity, beginWarmth: $currentModel.beginWarmthIntensity, endWarmth: $currentModel.endWarmthIntensity, tint: $currentModel.tintIntensity, beginTint: $currentModel.beginTintIntensity, endTint: $currentModel.endTintIntensity, selectedColorAdjustment: $currentModel.colorAdjustmentType, updateThumb: $currentActionModel.updateThumb).frame(height: panelHeight)
            }
            else{
                Spacer()
            }
            TextContainerTabbar(templateType: $outputType, didReplaceTabClicked: $didReplaceTabClicked, didOpacityTabClicked: $didOpacityTabClicked, didPositionTabClicked: $didPositionTabClicked, /*didFlipVerticalTabClicked: $didFlipVerticalTabClicked, didFlipHorizontalTabClicked: $didFlipHorizontalTabClicked*/didTransformTabClicked: $didTransformTabClicked, didNudgeTabClicked: $didNudgeTabClicked, didAnimationTabClicked: $didAnimationTabClicked, didTextEditTabClicked: $didTextEditTabClicked, didFontStyleTabClicked: $didFontStyleTabClicked, didTextSizeTabClicked: $didTextSizeTabClicked, didTextColorTabClicked: $didTextColorTabClicked, didBackgroubdTabClicked: $didBackgroubdTabClicked, didTextFormatTabClicked: $didTextFormatTabClicked, didSpacingTabClicked: $didSpacingTabClicked, didStrokeTabClicked: $didStrokeTabClicked, didShadowTabClicked: $didShadowTabClicked, didDeleteTabClicked: $currentModel.softDelete, didCopyTabClicked: $didCopyTabClicked, didDuplicateTabClicked: $didDuplicateTabClicked, didPasteTabClicked: $didPasteTabClicked, didLockUnclockTabClicked: currentModel.softDelete, didGroupTabClicked: $didGroupTabClicked, didUngroupTabClicked: $didUngroupTabClicked, didShowDurationButtonCliked: $cpm.didShowDurationButtonCliked, isLocked: $currentModel.lockStatus, lastSelectedTab: $currentActionModel.lastSelectedTextTab, didCloseButtonTapped: $cpm.didCloseTabbarTapped, showPanel: $cpm.didShowDurationButtonCliked, isCurrentModelDeleted: $currentActionModel.isCurrentModelDeleted, shouldRefreshOnAddComponent: $currentActionModel.shouldRefreshOnAddComponent, delegate: delegate, didFilterAdjustmentClicked: $didFilterAdjustmentClicked, didColorAdjustmentClicked: $didColorAdjustmentClicked).frame(height: containerDefaultHeight)
//                .padding(.bottom, bottomPadding)
                .frame(maxWidth: tabbarWidth)
                .frame(height: tabbarHeight)
            
                .onChange(of: didDuplicateTabClicked){ newValue in
                    if newValue == true{
                        print(" duplicate tapped")
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
        .sheet(isPresented: $didTextEditTabClicked) {
            TextEditorView(isTextPickerPresented: $didTextEditTabClicked, currentText: $currentModel.text, updatedText: $currentActionModel.updatedText, updateThumb: $currentActionModel.updateThumb).onDisappear{
                currentActionModel.didEditTextClicked = false
            }
        }
        .environment(\.sizeCategory, .medium)
        .onReceive(currentActionModel.$didEditTextClicked, perform: { didEditTextClicked in
            didTextEditTabClicked = didEditTextClicked
        })
//        .halfSheet(showSheet: $didTextEditTabClicked) {
//            TextEditorView(isTextPickerPresented: $didTextEditTabClicked, currentText: $currentModel.text, oldText: $currentModel.oldText, newText: $currentActionModel.addNewText)
//        }
//        onEnd: {
//            print("Dismis")
//            didTextEditTabClicked.toggle()
//        }
        .onAppear(){
            //Jay/
//            animTempalate = DBManager.shared.getAllAnimationTemplate()
//            animCategory = DBManager.shared.getAnimationCategory()
            
//            templateColorArray = DataSourceRepository.shared.getTemplateColorArray(templateID: currentModel.templateID)
        }
    }
}

//#Preview {
//    TextContainer()
//}
