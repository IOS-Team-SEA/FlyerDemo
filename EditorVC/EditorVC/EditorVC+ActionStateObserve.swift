//
//  EditorVC + Listener.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 30/03/24.
//

import Foundation
import SwiftUI
import IOS_LoaderSPM
import IOS_CommonUtilSPM
import IOS_CommonEditor

extension EditorVC {
    
     func observeCurrentActions() {
         observePlayerControls()
        
         guard let engine = engine, let templateHandler = engine.templateHandler else {
             printLog("template handler nil")
             return }
         
         actionStateCancellables.removeAll()
         logVerbose("SM + CurrentActions listeners ON \(actionStateCancellables.count)")
         
         
         
//         templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] _ in
//             guard let self = self else { return }
//             
//             
//             self.updateViewsNModelState()
//             
//         }).store(in: &actionStateCancellables)
         
  
         
            
            templateHandler.currentActionState.$isTextNotValid
                     .dropFirst()
                     .sink { [weak self] newValue in
                         guard let self = self else { return }
                         
                         if newValue {
                             self.presentAlertOnWindow()
                         }
                     }
                     .store(in: &actionStateCancellables)
            
            templateHandler.currentActionState.$copyModel.dropFirst().sink(receiveValue: { [weak self] newModel in
                print("NK Drop Paste \(newModel)")
                self?.showOverlay()
            }).store(in: &actionStateCancellables)
            
//            templateHandler.$selectedComponenet.sink { [weak self] component in
//                // conflict added neeshu
//                if component == .base{
//                    
//                    let thumbImage = engine.templateHandler.currentPageModel?.thumbImage
//                    self?.thumbnailImage = thumbImage
//                    
//                    // Use @StateObject to create a state wrapper around the image
//                    let thumbnailImageState = State(initialValue: thumbImage)
//                    
//                    self?.hostingerController?.rootView =  AnyView(
//                        BaseContainer(
//                            baseContentType: engine.editorUIState,
//                            thumbImage: Binding(
//                                get: {
//                                    
//                                    engine.templateHandler.currentPageModel?.thumbImage
////                                    thumbnailImageState.wrappedValue
//                                },
//                                set: { [weak self] newValue in
//                                    guard let self = self else { return }
//                                    
////                                    thumbnailImageState.wrappedValue = newValue
//                                    engine.templateHandler.currentPageModel?.thumbImage = newValue
//                                }
//                            ),
//                            actionStates: engine.templateHandler.currentActionState,
//                            exportSettings: engine.templateHandler.exportSettings,
//                            delegate: self // Ensure delegate is weak in BaseContainer
//                        ).environment(\.sizeCategory, .medium)
//                    )
//                }else {
//                    templateHandler.currentActionState.exportPageTapped = false
//                }
////                else if component == .sticker{
////                    hostingerController?.rootView = AnyView(StickerContainer(currentModel: engine.templateHandler.currentStickerModel!, currentActionModel: engine.templateHandler.currentActionState, delegate: self))
////                }else if component == .page{
////                    hostingerController?.rootView = AnyView(PageContainer(currentModel: engine.templateHandler.currentPageModel!, actionStates: engine.templateHandler.currentActionState, delegate: self, ratioSize: BASE_SIZE))
////                }else if component == .text{
////                    hostingerController?.rootView = AnyView(TextContainer(currentModel: engine.templateHandler.currentTextModel!, currentActionModel: engine.templateHandler.currentActionState, delegate: self))
////                }else if component == .parent{
////                    hostingerController?.rootView = AnyView(ParentContainer(currentModel: engine.templateHandler.currentParentModel!,actionStates: engine.templateHandler.currentActionState, ratioSize: BASE_SIZE))
////                }
//            }.store(in: &actionStateCancellables)
            
            
            
//            engine.templateHandler.currentStickerModel?.$lockStatus.dropFirst().sink{ [unowned  self] value in
//                print("Lock Status \(value)")
//            }.store(in: &cancellables)
//            
            
            
            
            templateHandler.currentActionState.$showNavgiationItems.dropFirst().sink { [weak self] value in
                guard let self = self else { return }
                if value == true{
                    self.addToolBar()
                }
            }.store(in: &actionStateCancellables)
            
         
         templateHandler.currentActionState.$exportPageTapped.dropFirst().sink {  [weak self ] didTappExport in
             guard let self = self else { return }
             if templateHandler.currentActionState.exportPageTapped != didTappExport {
                 //             if didTappExport {
                 //                 if engine.editorUIState == .SelectThumbnail {
                 //                     undoButton?.isEnabled = !didTappExport
                 //                     redoButton?.isEnabled = !didTappExport
                 //                     menuButton2?.isEnabled = !didTappExport
                 //                     exportButton?.isEnabled = !didTappExport
                 templateHandler.currentActionState.updatePageAndParentThumb = true
                 didTappExport ? removeToolBar() : addToolBar()
                 templateHandler.currentActionState.showMusicPickerRoundButton = !didTappExport
                 templateHandler.currentActionState.showPlayPauseButton = !didTappExport
                 viewModel?.showThumbnailNavItems = didTappExport
             }
//                 }
//             }
             
         }.store(in: &actionStateCancellables)
         
         templateHandler.currentActionState.$didGetPremiumTapped.dropFirst().sink {[weak self] value in
             guard let self = self else { return }
             // For Premium Button Tapped On Watermark & Export Option
             self.navigationController?.present(UIHostingController(rootView:IAPView().environmentObject(UIStateManager.shared).interactiveDismissDisabled().environment(\.sizeCategory, .medium)), animated: true)
         }.store(in: &actionStateCancellables)
         
            templateHandler.currentActionState.$showMultiSelectNavItems.dropFirst().sink { [weak self] value in
                guard let self = self else { return }
                if value == true{
                    addMultiSelectNavItems()
                }
            }.store(in: &actionStateCancellables)
            
            templateHandler.currentActionState.$showGroupButton.dropFirst().sink { [weak self] value in
                guard let self = self else { return }
                
                if value == true{
                    self.group?.isEnabled = true
                }else{
                    self.group?.isEnabled = false
                }
            }.store(in: &actionStateCancellables)
            
         templateHandler.currentActionState.$timelineShow.dropFirst().sink { [weak self] showTimeline in
             guard let self = self else { return }
             showTimeline ? timelineView?.showTimeline() :  timelineView?.hideTimelines()
            }.store(in: &actionStateCancellables)
            
         templateHandler.currentActionState.$didWatchAdsTapped.dropFirst().sink { [weak self] value in
             guard let self = self else { return }
             
             if value == true{
                 
                 self.onSave()
                 
             }
         }.store(in: &actionStateCancellables)
         
         templateHandler.currentActionState.$didPreviewTapped.dropFirst().sink{ [weak  self] value in
             guard let self = self else { return }
             if value != templateHandler.currentActionState.didPreviewTapped{
                 engine.editorUIState = .Preview
                 engine.templateHandler.deepSetCurrentModel(id: -1)
                 engine.templateHandler.currentActionState.timelineShow = false
                 relayoutViewForPreview2()
             }
             else{
                 engine.timeLoopHandler?.renderState = .Stopped
                 resizeViewForEdit2()
                 engine.templateHandler.currentActionState.timelineShow = true
                
             }
         }.store(in: &editorVMCancellables)
         
         UIStateManager.shared.$isPremium.sink {[weak self] isPremium in
             guard let self = self else { return }
             guard let template = templateHandler.currentTemplateInfo else { return }

//             let isDraftTemplate = templateHandler.currentTemplateInfo!.category
             engine.sceneManager.canRenderWatermark(!(isPremium || template.isThisTemplateBought))
             engine.viewManager?.canRenderWatermark(!(isPremium || template.isThisTemplateBought))
                 
         }.store(in: &playerControlsCancellables)
    }
    
    func findVisibleNavigationController() -> UINavigationController? {
        // Try multiple possibilities (embedded inside HostingController)
        if let nav = navigationController {
            return nav
        } else if let nav = parent?.navigationController {
            return nav
        } else if let hostNav = parent as? UINavigationController {
            return hostNav
        } else {
            return nil
        }
    }
    
    func observeEditorAction(){
        
        guard let engine = engine else {
            printLog("template handler nil")
            return }
        
        editorVMCancellables.removeAll()
        logVerbose("editor VM listeners ON \(editorVMCancellables.count)")
        
         // conflict with neeshu
        
//        viewModel.$didUseMeTapped.dropFirst().sink{ [weak  self] value in
//            guard let self = self else { return }
//            
//            addShimmerEffect()
//            if value != engine.templateHandler.currentActionState.didUseMeTapped{
//                if  engine.templateHandler.playerControls?.renderState == .Playing{
//                    engine.templateHandler.playerControls?.renderState = .Completed
//                }
//                relayoutViewForEdit2()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//                    guard let self = self else { return }
////                        engine.showDrop = autoSaveDesignDrop
//                    Drops.show(autoSaveDesignDrop)
//                }
//               
//            }
//        }.store(in: &actionStateCancellables)
        
        //Neeshu do this work for the Premium Page.
//        viewModel.$didPurchasedTapped.dropFirst().sink{[weak  self] value in
//            guard let self = self else { return }
//            
//            if  engine.templateHandler.playerControls?.renderState == .Playing{
//                engine.templateHandler.playerControls?.renderState = .Completed
//            }
//          /*  let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: true, consumableImage: Image(uiImage: thumbImage), defaultProductType: .onetime, premiumPageLoadingState: .normal)*/
//            
//            // Create the SwiftUI IAPView with an optional callback
//            let iapView = IAPView(onConsumablePurchased : { [weak self] purchaseSuccessful in
//                guard let self = self else { return }
//                
//                if purchaseSuccessful {
//                    if let templateId = engine.templateHandler.currentTemplateInfo?.templateId{
//                        let tempName = engine.templateHandler.currentTemplateInfo?.templateName
//
//                        // Handle the purchase success
//                        print("Purchase was successful!")
//                        if iapViewModel.consumablePurchasedProduct != nil{
////                                engine.sceneManager.canRenderWatermark(false)
////                                engine.viewManager?.canRenderWatermark(false)
//                            let templateId =  DBManager.shared.duplicateTemplate(templateID: templateId, templateType: "NonDraft", isSavedDesignDuplicate: true)
//                            //relayoutViewForPreviewAfterPurchase2(templateId: templateId)
//                            self.addShimmerEffect()
//                            self.resizeViewForEdit2(templateId: templateId)
//                        }
//                        else if !iapViewModel.purchasedProducts.isEmpty{
//                            //relayoutViewForPreviewAfterPurchase2(templateId: templateId)
//                            
//                            // doing on a urgent basis , would give it a thought before actual product release
//                            if engine.templateHandler.currentTemplateInfo!.isPremium == 1 && engine.templateHandler.currentTemplateInfo!.category == "TEMPLATE" {
//                                let templateId =  DBManager.shared.duplicateTemplate(templateID: templateId, templateType: "NonDraft", isSavedDesignDuplicate: true)
//                                self.addShimmerEffect()
//                                self.resizeViewForEdit2(templateId: templateId)
//
//                            } else {
//                                self.addShimmerEffect()
//                                self.resizeViewForEdit2(templateId: templateId)
//
//                            }
//                        }
//                        
//                        if iapViewModel.consumablePurchasedProduct != nil{
//                            if let product = iapViewModel.consumablePurchasedProduct{
//                                let currency = getCurrencySymbol(from: product)!
//                                _ = Double(truncating: product.price as NSNumber)
////                                    self.anayticsLogger.logPremiumInteraction(action: .SinglePurchase, planType: product.displayName, currency: currency, templateName: tempName ?? "None")
//                            }
//                        }
//                        
//                       
//                    }
//                } else {
////                        engine.sceneManager.canRenderWatermark(true)
////                        engine.viewManager?.canRenderWatermark(true)
////                        isTemplateConsumed = false
//
//                    // Handle the purchase failure
//                    print("Purchase failed!")
//                }
//            },isSingleTemplateSelectedOrNot: true, consumableImage: Image(uiImage: thumbImage)).environmentObject(UIStateManager.shared)
//            var hostingerController = UIHostingController(rootView: iapView)
//            hostingerController.isModalInPresentation = true
//            self.present(hostingerController, animated: true)
//        }.store(in: &actionStateCancellables)
        
        
        
        
        viewModel?.$showThumbnailNavItems.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            if value == true{
                addThumbnailNavItems()
            }
        }.store(in: &editorVMCancellables)
           
        controlPanelManager?.$didLayersTapped.dropFirst().sink { [weak self] value in
               guard let self = self else { return }
               if value == true{
                   logErrorJD(tag: .LockAllLayers)
//                    let lockAllState = templateHandler.filterAndTransformLockAll(templateHandler.currentPageModel!)
//
//                    let vc = StackedViewController(viewModel: engine.layersManager,multiPlier: 1)
//                    self.addChildVCWithMultiplier(vc,heightMultiplier: 1)
//
//                    self.navigationController?.isNavigationBarHidden = true
                   if engine.templateHandler.currentPageModel?.activeChildren.count == 0{
                       showNoLayerAlert()
                   }else{
                       let layersManager = engine.layersManager
                       layersManager.setTemplateHandler(th: engine.templateHandler)
                       let vc = StackedViewController(viewModel:layersManager ,multiPlier: 1)
                       self.addChildVCWithMultiplier(vc,heightMultiplier: 1)
                       self.navigationController?.isNavigationBarHidden = true
                   }
               }
//                self.anayticsLogger.logEditorInteraction(action: .layersTapped)

           }.store(in: &editorVMCancellables)
    }
    
    
    func addMultiSelectNavItems(){
        group = UIBarButtonItem(title: "Group_".translate(), style: .plain, target: self, action: #selector(GroupAction))
        cancel = UIBarButtonItem(title: "Cancel_".translate(), style: .plain, target: self, action: #selector(cancelAction))
        
        group?.isEnabled = false
        navigationItem.rightBarButtonItems = [cancel!,group!]
        
        if let nav = findVisibleNavigationController() {
                nav.topViewController?.navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems
                nav.topViewController?.navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems
                nav.topViewController?.title = navigationItem.title
            }
    }
    
    func addThumbnailNavItems(){
        navigationItem.hidesBackButton = true
        
        cancel = UIBarButtonItem(title: "Cancel_".translate(), style: .plain, target: self, action: #selector(cancelAction2))

        navigationItem.rightBarButtonItems = [cancel!]
        
        if let nav = findVisibleNavigationController() {
                nav.topViewController?.navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems
                nav.topViewController?.navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems
                nav.topViewController?.title = navigationItem.title
            }
    }
    
    func showNoLayerAlert(){
        let alertController = UIAlertController(
            title: "No_Layers_Found".translate(),
            message: "",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func GroupAction() {
        if let engine = engine{
            engine.templateHandler.currentActionState.didGroupTapped = true
        }
    }
    
    @objc func cancelAction() {
        if let engine = engine{
            engine.templateHandler.currentActionState.didCancelTapped = true
        }
    }
    
    @objc func cancelAction2() {
        if let engine = engine{
            engine.templateHandler.currentActionState.isCurrentModelDeleted = false
        }
    }
    
    var autoSaveDesignDrop: Drop{
        return Drop(
            title: "Design_Saved".translate(),
            subtitle: "PartyZa_auto_saves_designs".translate(),
             action: .init {
                 print("Drop tapped")
                 Drops.hideCurrent()
             },
             position: .top,
             duration: 2.0,
             accessibility: "Alert: Title, Subtitle"
         )
    }
}

