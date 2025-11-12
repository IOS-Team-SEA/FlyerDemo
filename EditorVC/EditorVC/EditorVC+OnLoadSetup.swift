//
//  EditorVC+OnLoadSetup.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//
import UIKit
import SwiftUI
import IOS_LoaderSPM
import IOS_CommonEditor

extension EditorVC {

    func setViewsNLoadTemplate2(){
        setEditorView()
        
        if loadingState == .Edit {
            let updatedAt = Date()
            // Create a DateFormatter
            let dateFormatter = DateFormatter()

            // Set the desired date format
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            // Convert Date to String
            let updatedAtString = dateFormatter.string(from: updatedAt)

            // Print the value
            print("Updated At: \(updatedAtString)")
            
            _ = DBManager.shared.updateTemplateUpdatedDate(templateId: currentTemplateID, newValue: updatedAtString)
            
            self.loadingStaus = true
        }
        addPlayerControlView()
        Task {
            let didLoadScene = await engine!.prepareScene2(templateID: self.currentTemplateID, refSize: BASE_SIZE, loadThumbnails: loadingState == .Edit ? true : false)
            if didLoadScene {
                logInfo("DD_STARTED RENDERING", didLoadScene)
//                createContainerView()
//                addSwiftUIOpacityView()
                onSceneLoad()
            }
        }
        

    }
    
    
    func onSceneLoad() {
        DispatchQueue.main.async { [weak self , weak engine , weak editorView ] in
           
                UIStateManager.shared.progress = 1.0
            
            guard let self = self else { return }
            guard let engine = engine else { return }
            guard let editorView = editorView else { return }
            
            setupControlPanelManager()
            createContainerView()
            controlPanelManager?.addSwiftUIOpacityView()
            
            
                if let customloaderView = self.customLoader?.view{
                    customloaderView.removeFromSuperview()
                }
                
                if let currentTemplate = engine.templateHandler.currentTemplateInfo{
                    if self.loadingState == .Preview{
//                        self.anayticsLogger.logTemplateInteraction(action: .viewed, templateTitle: currentTemplate.templateName, categoryName: currentTemplate.categoryTemp)
//                        self.anayticsLogger.logTemplateInteraction(action: .viewed, templateId: String(currentTemplate.serverTemplateID), templateTitle: currentTemplate.templateName, categoryName: currentTemplate.categoryTemp)
//                        self.anayticsLogger.trackScreens(screen: .preview)
                    }
                    else if self.loadingState == .Edit{
//                        self.anayticsLogger.logTemplateInteraction(action: .editStarted, templateTitle: currentTemplate.templateName, categoryName: currentTemplate.categoryTemp)

//                        self.anayticsLogger.logTemplateInteraction(action: .editStarted, templateId: String(currentTemplate.serverTemplateID), templateTitle: currentTemplate.templateName, categoryName: currentTemplate.categoryTemp)
//                        self.anayticsLogger.startEditorSession()
//                        self.anayticsLogger.trackScreens(screen: .editor)
                    }
                }
            logInfo("Loading State -> \(self.loadingState)")
                if (self.loadingState == .Edit && self.loadingStaus){
                    if engine.templateHandler.currentTemplateInfo?.outputType == .Video {
                        self.addTimelineView()
                        self.timelineView?.setTemplateHandler(templateHandler: engine.templateHandler)

                    } else {
                        // add MockUP View here in future
                    }
//                    self.addTimelineView()
                    if engine.viewManager == nil
                    {
                        self.addViewManager(engine: engine, editorView: editorView)
//                        engine.viewManager = ViewManager(canvasView: editorView, logger: AppPackageLogger(), vmConfig: AppViewManagerConfigure())
                        engine.prepareSceneUIView()
                        engine.viewManager?.editView?.gestureView.isAllGesturesEnabled = true
                    }
                    engine.viewManager?.setTemplateHandler(templateHandler: engine.templateHandler)
                    engine.viewManager?.setZoomController()
                    engine.sceneManager.setTemplateHandler(templateHandler: engine.templateHandler)
                    engine.undoRedoManager?.setTemplateHandler(templateHandler: engine.templateHandler)
                    if engine.viewManager?.rootView?.currentPage == nil {
                        engine.viewManager?.addPage(pageInfo:engine.templateHandler.currentTemplateInfo!.pageInfo.first!)
                    }
                    logInfo("CurrentPageModel Set")
                    engine.templateHandler.deepSetCurrentModel(id: engine.templateHandler.currentTemplateInfo!.pageInfo.first!.modelId)
                    engine.templateHandler.currentActionState.showNavgiationItems = true
                }
                
//                if self.loadingState == .Edit{
//                    engine.templateHandler.currentActionState.didMusicPlayOnEditor = true
//                }
            if engine.templateHandler.currentTemplateInfo?.outputType == .Video {

                for subview in viewDummy.subviews {
                    subview.removeFromSuperview()
                }

                    // MUSIC ADD
                if let hostingerMusic = self.hostingerMusic, self.loadingState == .Edit{
                    viewDummy.addSubview(hostingerMusic.view)
                }
                
                
               
                
                
                if let containerView = self.containerView{
                    self.view.bringSubviewToFront(containerView)
                }
                
                self.addMusicControlView(engine: engine)
//                self.hostingerMusic?.view.removeFromSuperview() // Remove the previous view if it exists
//                self.hostingerMusic = UIHostingController(rootView: MusicControlView(templateHandler: engine.templateHandler, playerVm: engine.templateHandler.playerControls!, actionStates: engine.templateHandler.currentActionState))
//                
//                let viewDummy = self.viewDummy
//                self.hostingerMusic?.view.frame = viewDummy.bounds
//                self.hostingerMusic?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                
//                if let hostingerMusic = self.hostingerMusic {
//                    viewDummy.addSubview(hostingerMusic.view)
//                }
                
                if self.loadingState == .Preview{
                    engine.templateHandler.currentActionState.didMusicPlayOnEditor = false
                }
                else{
                    engine.templateHandler.currentActionState.didMusicPlayOnEditor = true
                }
                
                self.addMuteControls(engine: engine)
//                self.muteHostingerController = UIHostingController(rootView: MuteControl(isMute: Binding(get: {
//                    engine.templateHandler.currentActionState.isMute
//                }, set: { newValue in
//                    engine.templateHandler.currentActionState.isMute = newValue
//                })))
//                
//                self.muteHostingerController.view.frame = CGRect(x: 10, y: 120, width: 40, height: 40)
//                self.muteHostingerController.view.backgroundColor = .clear
//                self.muteHostingerController.view.isHidden = true
//                
//                
//                if  let muteView = self.muteHostingerController.view {
//                    self.view.addSubview(muteView)
//                    self.view.bringSubviewToFront(muteView)
//                }
            } else if engine.templateHandler.currentTemplateInfo?.outputType == .Image  {
                

                
            }
                
//                if self.loadingState == .Preview{
//                    if engine.templateHandler.playerControls?.renderState != .Playing{
//                        engine.templateHandler.playerControls?.renderState = .Playing
//                    }
//                }
//                
//                if self.loadingState == .Edit{
//                    if engine.templateHandler.renderingState != .Edit{
//                        engine.templateHandler.renderingState = .Edit
//                    }
//                }
//                
           
                UIStateManager.shared.progress = 0
            
            
        }
    }
    
    func addViewManager(engine: MetalEngine, editorView: EditorView){
       
        engine.viewManager = ViewManager(canvasView: editorView, logger: AppPackageLogger(), vmConfig: AppViewManagerConfigure(), toolbarConfig: ToolBarMiniViewManager(engine: engine))
    }
    
    func addMusicControlView(engine: MetalEngine){
        self.hostingerMusic?.view.removeFromSuperview() // Remove the previous view if it exists
        self.hostingerMusic = UIHostingController(rootView: MusicControlView(templateHandler: engine.templateHandler, playerVm: engine.templateHandler.playerControls!, actionStates: engine.templateHandler.currentActionState))
        
        let viewDummy = self.viewDummy
        self.hostingerMusic?.view.frame = viewDummy.bounds
        self.hostingerMusic?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let hostingerMusic = self.hostingerMusic {
            viewDummy.addSubview(hostingerMusic.view)
        }
    }
    
    func addMuteControls(engine: MetalEngine){
        self.muteHostingerController = UIHostingController(rootView: MuteControl(isMute: Binding(get: {
            engine.templateHandler.currentActionState.isMute
        }, set: { newValue in
            engine.templateHandler.currentActionState.isMute = newValue
        })))
        
        self.muteHostingerController.view.frame = CGRect(x: 10, y: 120, width: 40, height: 40)
        self.muteHostingerController.view.backgroundColor = .clear
        self.muteHostingerController.view.isHidden = true
        
        
        if  let muteView = self.muteHostingerController.view {
            self.view.addSubview(muteView)
            self.view.bringSubviewToFront(muteView)
        }
    }
    
    func relayoutViewForEdit2() {
        navTitle.text = "" //NK*
        if loadingState == .Preview{
            loadingState = .Edit
            loadingStaus = true
            setEditorView()
            
            engine?.templateHandler.currentActionState.didMusicPlayOnEditor = true
            let templateInfo = DBManager.shared.getTemplate(templateId: currentTemplateID)
            if (templateInfo?.category != "DRAFT" && templateInfo?.isPremium != 1 && !UIStateManager.shared.isPremium) || (UIStateManager.shared.isPremium && templateInfo?.category != "DRAFT"){
                currentTemplateID = DBManager.shared.duplicateTemplate(templateID: currentTemplateID, templateType: "NonDraft", isSavedDesignDuplicate: true)
            }
            
            let updatedAt = Date()
            // Create a DateFormatter
            let dateFormatter = DateFormatter()
            
            // Set the desired date format
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            // Convert Date to String
            let updatedAtString = dateFormatter.string(from: updatedAt)
            
            // Print the value
            print("Updated At: \(updatedAtString)")
            
            _ = DBManager.shared.updateTemplateUpdatedDate(templateId: currentTemplateID, newValue: updatedAtString)
           
            Task {
                let didLoadScene = await engine!.prepareScene2(templateID: self.currentTemplateID, refSize: BASE_SIZE, loadThumbnails: true)
                if didLoadScene {
                    print("DD_STARTED RENDERING", didLoadScene)
//                    self.observeCurrentActions()
                    onSceneLoad()
                    
                }
            }
            
        }
    }
    
//    func relayoutViewForEdit() {
////         AdsEngine.shared.showAdsIfNeeded{ [self] in
//          
//            if loadingState == .Preview{
//                loadingState = .Edit
//                loadingStaus = true
//                setEditorView()
//                engine?.templateHandler.currentActionState.didMusicPlayOnEditor = true
//                let templateInfo = DBManager.shared.getTemplate(templateId: currentTemplateID)
//                if (templateInfo?.category != "DRAFT" && templateInfo?.isPremium != 1 && !UIStateManager.shared.isPremium) || (UIStateManager.shared.isPremium && templateInfo?.category != "DRAFT"){
//                    currentTemplateID = DBManager.shared.duplicateTemplate(templateID: currentTemplateID, templateType: "NonDraft")
//                }
//                
//                let updatedAt = Date()
//                // Create a DateFormatter
//                let dateFormatter = DateFormatter()
//                
//                // Set the desired date format
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                
//                // Convert Date to String
//                let updatedAtString = dateFormatter.string(from: updatedAt)
//                
//                // Print the value
//                print("Updated At: \(updatedAtString)")
//                
//                _ = DBManager.shared.updateTemplateUpdatedDate(templateId: currentTemplateID, newValue: updatedAtString)
//                
//                engine!.prepareScene(templateID: currentTemplateID , refSize: BASE_SIZE)
////                engine!.templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] _ in
////                    self?.updateViewsNModelState()
////                }).store(in: &cancellables)
//                self.observeCurrentActions()
//            }
//            navTitle.text = "" //NK*
//  
//   }
   
//   func resizeViewForEdit() {
//       self.navigationItem.hidesBackButton = false
//          
//           if loadingState == .Preview{
//               loadingStaus = true
//               loadingState = .Edit
//               setEditorView()
//               engine?.templateHandler.currentActionState.didMusicPlayOnEditor = true
//               engine!.prepareScene(templateID: currentTemplateID , refSize: BASE_SIZE)
////               engine!.templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] _ in
////                   self?.updateViewsNModelState()
////               }).store(in: &cancellables)
//               self.observeCurrentActions()
//           }
//           navTitle.text = ""
//  }
    func resizeViewForEdit2() {
        self.navigationItem.hidesBackButton = false
           
          
            navTitle.text = ""
        if loadingState == .Preview{
            loadingStaus = true
            loadingState = .Edit
            setEditorView()
            Task {
                let didLoadScene = await engine!.prepareScene2(templateID: self.currentTemplateID, refSize: BASE_SIZE, loadThumbnails: true)
                if didLoadScene {
                    print("DD_STARTED RENDERING", didLoadScene)
                    engine?.viewManager?.editView?.gestureView.isAllGesturesEnabled = true
                    self.observeCurrentActions()
                    self.observeEditorAction()
                    self.controlPanelManager?.observeControlManager()
                    onSceneLoad()
                    
                }
            }
        }
   }
    
    
    func resizeViewForEdit2(templateId : Int) {
        self.navigationItem.hidesBackButton = false
           
          
            navTitle.text = ""
        if loadingState == .Preview{
            loadingStaus = true
            loadingState = .Edit
            setEditorView()
            Task {
                let didLoadScene = await engine!.prepareScene2(templateID: templateId, refSize: BASE_SIZE, loadThumbnails: true)
                if didLoadScene {
                    print("DD_STARTED RENDERING", didLoadScene)
                    self.observeCurrentActions()
                    self.observeEditorAction()
                    self.controlPanelManager?.observeControlManager()
                    onSceneLoad()
                    
                }
            }
        }
   }

    
    func relayoutViewForPreview2(){

        self.navigationItem.hidesBackButton = true
        removeToolBar()
        navTitle.text = "Preview_".translate()
//        engine?.viewManager?.removePage()
        guard let engine = engine else { return }
        engine.viewManager?.removePage()
        engine.viewManager?.editView?.gestureView.isAllGesturesEnabled = false
        loadingStaus = true
        self.loadingState = .Preview
        setEditorView()

        engine.templateHandler.currentActionState.didMusicPlayOnEditor = false

        timelineView?.removeFromSuperview()
        timelineView = nil
       

        Task {
            let didLoadScene = await engine.prepareScene2(templateID: self.currentTemplateID, refSize: BASE_SIZE, loadThumbnails: true)
            if didLoadScene {
                print("DD_STARTED RENDERING", didLoadScene)
               
                engine.editorUIState = .Preview
                self.observeCurrentActions()
                self.observeEditorAction()
                self.controlPanelManager?.observeControlManager()
                onSceneLoad()
                
            }
        }
        
    }
    
//   func relayoutViewForPreview(){
//       // Hide the back button
//       self.navigationItem.hidesBackButton = true
//       removeToolBar()
//       engine?.viewManager?.removePage()
//     
//       loadingStaus = true
//       self.loadingState = .Preview
//       setEditorView()
//       engine?.templateHandler.currentActionState.didMusicPlayOnEditor = false
//       timelineView?.removeFromSuperview()
//       engine!.prepareScene(templateID: currentTemplateID , refSize: BASE_SIZE)
////       engine!.templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] _ in
////           self?.updateViewsNModelState()
////       }).store(in: &cancellablesForEditor)
//      
//       engine!.editorUIState = .Preview
//       addSwiftUIOpacityView()
//       self.observeCurrentActions()
////       engine?.templateHandler.playerControls?.renderState = .Playing
//       navTitle.text = "Preview_".translate()
//   }
    
    
    func relayoutViewForPreviewAfterPurchase2(templateId : Int){
        guard let engine = engine else { return }

        currentTemplateID = templateId
        removeToolBar()
        loadingStaus = true
        self.loadingState = .Preview
        setEditorView()
        engine.templateHandler.currentActionState.didMusicPlayOnEditor = false

        timelineView?.removeFromSuperview()
        timelineView = nil
        
        navTitle.text = "Preview_".translate()
        
        Task {
            let didLoadScene = await engine.prepareScene2(templateID: self.currentTemplateID, refSize: BASE_SIZE, loadThumbnails: true)
            if didLoadScene {
                print("DD_STARTED RENDERING", didLoadScene)
//                    self.observeCurrentActions()
                engine.editorUIState = .UseMe
                onSceneLoad()
                
            }
        }
        
    }
    
    
//   func relayoutViewForPreviewAfterPurchase(templateId : Int){
//       currentTemplateID = templateId
//       // Hide the back button
//       removeToolBar()
//       loadingStaus = true
//       self.loadingState = .Preview
//       setEditorView()
//
//       engine?.templateHandler.currentActionState.didMusicPlayOnEditor = false
//       timelineView?.removeFromSuperview()
//       engine!.prepareScene(templateID: currentTemplateID , refSize: BASE_SIZE)
////       engine!.templateHandler.$setSelectedModelChanged.dropFirst().sink(receiveValue: { [weak self] _ in
////           self?.updateViewsNModelState()
////       }).store(in: &cancellables)
//       engine!.editorUIState = .UseMe
//       addSwiftUIOpacityView()
//       self.observeCurrentActions()
//       navTitle.text = "Preview_".translate()
//   }
    
    func loadEditorView(frame:CGRect,center:CGPoint) {
        if let metalEngine = viewModel?.metalEngine{
            
            
            if editorView == nil{
                metalEngine.getEditorView(frame: frame)
                editorView?.backgroundColor = .white
                
                if let engine = engine{
                    self.view.addSubview(engine.editorView!)
                    if let editorView = engine.editorView{
                        editorView.center = center
                    }
                    
                   
                }
            }
            else{
                editorView?.backgroundColor = .white
                UIView.animate(withDuration: 0.3, animations: {
                    self.editorView?.frame.size.height = frame.size.height
                    self.view.layoutIfNeeded()
                    self.editorView?.layoutSubviews()
                })
            }
        }
   // }

    }
    
    func setEditorView() {
           
        let rectAndCenter =  calculateSizeForEditorView()
        loadEditorView(frame:rectAndCenter.0 , center:rectAndCenter.1)
    
    }
    
//    // This function calls at the time of Use Me Button Tapped.
//    func reSetupOfEditor(templateID : Int , templateLoadingState : EditorLoadingState){
//        // Show the ads if exist.
//        AdsEngine.shared.showAdsIfNeeded{ [self] in
//            var newTemplateID = templateID
//            // Remove the Previous Editor View.
//            editorView = nil
//            // Duplicate the template if it is in Edit State.
//            if templateLoadingState == .Edit{
//                var newTemplateID = DBManager.shared.duplicateTemplate(templateID: templateID, templateType: "NonDraft")
//            }
//            // Resize the view.
//        }
//        
//    }
   
}
