//
//  EditorVC+ControlPanels.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

import UIKit
import SwiftUI
import IOS_CommonEditor

extension EditorVC {
   
    // setup UIkit swiftUI ControlPnael Interface HostingerVC
    // show control panel container based on type ( delegate , info , actionStates )
    
    
    
    // Function used for updating the containers model with the change of sticker on model.
//    func updateViewsNModelState(){
//        if let engine = engine{
//            if let currentModel = engine.templateHandler.currentModel{
//                if currentModel is StickerInfo{
//                    hostingerController?.rootView = AnyView(StickerContainer(currentModel: engine.templateHandler.currentStickerModel!, currentActionModel: engine.templateHandler.currentActionState, cpm: viewModel.controlPanelManager!, delegate: self).environment(\.sizeCategory, .medium))
//
//                }
//                else if currentModel is TextInfo{
//                    hostingerController?.rootView = AnyView(TextContainer(currentModel: engine.templateHandler.currentTextModel!, currentActionModel: engine.templateHandler.currentActionState, cpm: viewModel.controlPanelManager!, delegate: self).environmentObject(viewModel.dsStore).environment(\.sizeCategory, .medium))
////                    engine.undoRedoManager?.observeTextModel( currentModel: engine.templateHandler.currentTextModel!, actionStates: engine.templateHandler.currentActionState)
//                }
//                else if currentModel is ParentInfo {
//                    hostingerController?.rootView = AnyView(ParentContainer(currentModel: engine.templateHandler.currentParentModel!, actionStates: engine.templateHandler.currentActionState, cpm: viewModel.controlPanelManager!, delegate: self, /*ratioSize: engine.templateHandler.currentTemplateInfo?.ratioSize ?? CGSize(width: 1, height: 1)*/ ratioInfo: Binding(
//                        get: {
//                            
//                            engine.templateHandler.currentTemplateInfo?.ratioInfo
////                                    thumbnailImageState.wrappedValue
//                        },
//                        set: { [weak self] newValue in
////                                    thumbnailImageState.wrappedValue = newValue
////                            engine.templateHandler.currentPageModel?.thumbImage = newValue
//                        }
//                    )).environment(\.sizeCategory, .medium))
//                   // engine.undoRedoManager?.observeParentModel(currentModel: engine.templateHandler.currentParentModel!, actionStates: engine.templateHandler.currentActionState)
//                }else if currentModel is PageInfo{
//                    
//                    let pageView = PageContainer(currentModel: engine.templateHandler.currentPageModel!, actionStates: engine.templateHandler.currentActionState, cpm: self.viewModel.controlPanelManager!, delegate: self, /*ratioSize: engine.templateHandler.currentTemplateInfo?.ratioSize ?? CGSize(width: 1, height: 1)*/ ratioInfo: Binding(
//                        get: {
//                            
//                            engine.templateHandler.currentTemplateInfo?.ratioInfo
//                            
////
//                        },
//                        set: { [weak self] newValue in
////                                    thumbnailImageState.wrappedValue = newValue
////                            engine.templateHandler.currentPageModel?.thumbImage = newValue
//                        }
//                    )).environmentObject(viewModel.dsStore).environment(\.sizeCategory, .medium)
//                        
//                    hostingerController?.rootView = AnyView(pageView)
//                   // engine.undoRedoManager?.observePageModel(currentModel: engine.templateHandler.currentPageModel!, actionStates: engine.templateHandler.currentActionState, templateHandler: engine.templateHandler)
//                }
//                
//               
//            }
//        }
//    }
}
