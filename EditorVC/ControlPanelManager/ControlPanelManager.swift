//
//  ControlPanelManager.swift
//  FlyerDemo
//
//  Created by HKBeast on 10/11/25.
//

import Foundation
import IOS_CommonEditor
import Combine
import SwiftUI

class ControlPanelManager: ObservableObject{
    
    @Published var lastSelectedBGContent: AnyBGContent?
    @Published public var lastSelctedOverlayContent: AnyBGContent?
    @Published public var lastSelectedFilter: FiltersEnum = .none
    @Published public var lastSelectedFont: String = "Default"
    @Published public var lastSelectedFlipH: Bool = false
    @Published public var lastSelectedFlipV: Bool = false
    @Published public var lastSelectedBGColor: AnyBGContent?
    
    @Published public var didCloseTabbarTapped: Bool = false
    
    @Published public var didShowDurationButtonCliked: Bool = false
    @Published public var lastSelectedShadowButton: ShadowType = .direction
    @Published public var lastSelectedBGButton: BGPanelType = .color
    @Published public var lastSelectedFormatButton: HTextGravity = .Center
    @Published public var lastSelectedBGTab: String = ""
    @Published public var lastSelectedColor: AnyColorFilter?
    @Published public var lastSelctedBGContent: AnyBGContent?
    @Published public var didLayersTapped: Bool = false
    
    weak var editorVC: EditorVC?
//    var engine: MetalEngine?
    var cpmCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
//    var hostController: UIHostingController<AnyView>?
    
    init(editorVC: EditorVC?){
//        self.engine = engine
        self.editorVC = editorVC
        printLog("init \(self)")
//        observeTemplateHandlerChanges()
    }
    
    deinit {
        printLog("de-init \(self)")
    }
    
    func observeControlManager() {
        cpmCancellables.removeAll()
        
        guard let editorVC = editorVC else { return }
        guard let engine = editorVC.engine, let templateHandler = engine.templateHandler else {
            printLog("template handler nil")
            return
        }
        
        // Observe selection changes from templateHandler
        templateHandler.$setSelectedModelChanged
            .dropFirst()
            .sink { [weak self] _ in
                self?.updateControlPanel()
            }
            .store(in: &cpmCancellables)
        
        $didCloseTabbarTapped.dropFirst().sink { [weak self] value in
            if value == true{
                // templateHandler.deepSetCurrentModel(id: templateHandler.currentModel!.parentId)
                templateHandler.setCurrentModel(id: templateHandler.currentModel!.parentId)
            }
        }.store(in: &cpmCancellables)
        
        templateHandler.$selectedComponenet.sink { [weak self, weak editorVC] component in
            // conflict added neeshu
            guard let self, let editorVC else { return }
            if component == .base{
                
                let thumbImage = engine.templateHandler.currentPageModel?.thumbImage
//                self?.thumbnailImage = thumbImage
                
                // Use @StateObject to create a state wrapper around the image
                let thumbnailImageState = State(initialValue: thumbImage)
                
                editorVC.hostingerController?.rootView =  AnyView(
                    BaseContainer(
                        baseContentType: engine.editorUIState,
                        thumbImage: Binding(
                            get: {
                                
                                engine.templateHandler.currentPageModel?.thumbImage
//                                    thumbnailImageState.wrappedValue
                            },
                            set: { [weak self] newValue in
                                guard let self = self else { return }
                                
//                                    thumbnailImageState.wrappedValue = newValue
                                engine.templateHandler.currentPageModel?.thumbImage = newValue
                            }
                        ),
                        actionStates: engine.templateHandler.currentActionState,
                        exportSettings: engine.templateHandler.exportSettings,
                        delegate: editorVC // Ensure delegate is weak in BaseContainer
                    ).environment(\.sizeCategory, .medium)
                )
            }else {
                templateHandler.currentActionState.exportPageTapped = false
            }
        }.store(in: &cpmCancellables)
    }
    
    func updateControlPanel() {
        guard let editorVC = editorVC else { return }
        guard let engine = editorVC.engine else { return }
        guard let currentModel = engine.templateHandler.currentModel else { return }
        
        
        let controlPanel: AnyView
        
        if currentModel is StickerInfo {
            controlPanel = AnyView(
                StickerContainer(
                    currentModel: engine.templateHandler.currentStickerModel!,
                    currentActionModel: engine.templateHandler.currentActionState,
                    cpm: self,
                    delegate: editorVC
                )
                .environment(\.sizeCategory, .medium)
            )
        }
        else if currentModel is TextInfo {
            controlPanel = AnyView(
                TextContainer(
                    currentModel: engine.templateHandler.currentTextModel!,
                    currentActionModel: engine.templateHandler.currentActionState,
                    cpm: self,
                    delegate: editorVC
                )
                .environment(\.sizeCategory, .medium)
            )
        }
        else if currentModel is ParentInfo {
            controlPanel = AnyView(
                ParentContainer(
                    currentModel: engine.templateHandler.currentParentModel!,
                    actionStates: engine.templateHandler.currentActionState,
                    cpm: self,
                    delegate: editorVC,
                    ratioInfo: Binding.constant(engine.templateHandler.currentTemplateInfo?.ratioInfo)
                )
                .environment(\.sizeCategory, .medium)
            )
        }
        else if currentModel is PageInfo {
            controlPanel = AnyView(
                PageContainer(
                    currentModel: engine.templateHandler.currentPageModel!,
                    actionStates: engine.templateHandler.currentActionState,
                    cpm: self,
                    delegate: editorVC,
                    ratioInfo: Binding.constant(engine.templateHandler.currentTemplateInfo?.ratioInfo)
                )
                .environment(\.sizeCategory, .medium)
            )
        }
        else {
            controlPanel = AnyView(EmptyView())
        }
        
        DispatchQueue.main.async {
            editorVC.hostingerController?.rootView = controlPanel
        }
    }
    
    func addSwiftUIOpacityView() {
        guard let editorVC = editorVC else { return }
        if let engine = editorVC.engine{
            if let containerView = editorVC.containerView{
                
                let thumbImage = engine.templateHandler.currentPageModel?.thumbImage
                        
                        // Use @StateObject to create a state wrapper around the image
                let thumbnailImageState = State(initialValue: thumbImage)
                editorVC.hostingerController?.view.removeFromSuperview()
                editorVC.hostingerController?.removeFromParent()
                editorVC.hostingerController = UIHostingController(
                    rootView: AnyView(
                        BaseContainer(
                            baseContentType: engine.editorUIState,
                            thumbImage: Binding(
                                get: {
                                    thumbnailImageState.wrappedValue
                                },
                                set: { [weak self] newValue in
                                    guard let self = self else { return }
                                    
                                    thumbnailImageState.wrappedValue = newValue
                                }
                            ),
                            actionStates: engine.templateHandler.currentActionState,
                            exportSettings: engine.templateHandler.exportSettings,
                            delegate: editorVC // Ensure delegate is weak in BaseContainer
                        ).environment(\.sizeCategory, .medium)
                    )
                )
                
                
                editorVC.observeCurrentActions()
                editorVC.observeEditorAction()
                observeControlManager()
                //        self.engine.currentModel = TextInfo()
                //        hostingerController = UIHostingController(rootView: TextContainer(currentModel: self.engine.currentModel as! TextInfo, currentActionModel: self.engine.actionStates, delegate: self))
                
                editorVC.addChild(editorVC.hostingerController!)
                containerView.addSubview(editorVC.hostingerController!.view)
                editorVC.hostingerController!.didMove(toParent: editorVC)
                        
                editorVC.hostingerController!.view.frame = CGRect(x: 0, y: 0, width: Int(containerView.frame.size.width), height: Int(containerView.frame.size.height) )
                editorVC.hostingerController?.view.backgroundColor = UIColor.systemBackground//UIColor(named: "editorBG")
              
                //        }
                //        }
                
            }
        }
    }
       
}
