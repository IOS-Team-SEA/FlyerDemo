//
//  EditorVC2.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 28/03/25.
//


import UIKit
import IOS_LoaderSPM
import Network
 import IOS_CommonEditor

//class EditorVC2 : UIViewController , NavAction {
//    func onBackPressed() {
//        if let navController = self.navigationController as? MyNavigationController {
//            navController.goBack()
//        }
//    }
//    func shouldPopToRoot() -> Bool {
//        return true
//    }
//    // @AppStorage("ShowEditorVC") static var showEditorVC : Bool = false
//    
//    var viewModel : EditorVM?
//    var engine : MetalEngine?
//    var templateID : Int
//    init(templateId:Int) {
//        self.templateID = templateId
//        super.init(nibName: "EditorVC", bundle: nil)
//        viewModel = EditorVM()
//        engine = MetalEngine()
//    }
//    var editorView : EditorView? {
//        return engine?.editorView
//    }
//    var timelineView : TimelineView?
//    override func viewDidLoad() {
//        setupButton()
//         engine?.getEditorView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 600)))
//        self.view.addSubview(editorView!)
//        
//        setup()
//    }
//    func setup() {
//        //
//        Task {
//            let didLoadScene = await engine!.prepareScene2(templateID: self.templateID, refSize: CGSize(width: 300, height: 600), loadThumbnails: false)
//            if didLoadScene {
//                DispatchQueue.main.async { [weak self ] in
//                    print("render success PREVIEw")
//                    // guard let self = self else { return }
//                    // guard let engine = self.engine else { return }
//                    // engine.viewManager = ViewManager(canvasView: engine.editorView)
//                    // engine.viewManager?.setTemplateHandler(templateHandler: engine.templateHandler)
//                    //
//                    // self.timelineView = TimelineView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)))
//                    // self.view.addSubview(timelineView!)
//                    // self.timelineView?.setTemplateHandler(templateHandler: engine.templateHandler)
//                    
//                }
//            }
//        }
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    deinit {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            engine?.drawCallManager?.stopNotifyingDrawCall()
//
//        }
//        
//        printLog("de-init \(self)")
//    }
//    private func setupButton() {
//        let button = UIButton(type: .system)
//        button.setTitle("Tap Me", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 10
//        button.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(button)
//        // Auto Layout Constraints
//        NSLayoutConstraint.activate([
//            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            button.heightAnchor.constraint(equalToConstant: 50)
//        ])
//        // Add Action
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//    }
//    @objc private func buttonTapped() {
//        // let editorVC = EditorVC2(templateId: templateID)
//        // self.navigationController?.pushViewController(editorVC, animated: true)
//        //
//        engine?.drawCallManager?.stopNotifyingDrawCall()
//        
//        // engine?.canPlayScene = { [weak self] success, error in
//        // DispatchQueue.main.async { [weak self] in
//        // guard let self = self else { return }
//        // print("render success EDIT")
//        // guard let engine = engine else { return }
//        //// engine.viewManager = ViewManager(canvasView: engine.editorView)
//        //// engine.viewManager?.setTemplateHandler(templateHandler: engine.templateHandler)
//        ////
//        //// self.timelineView = TimelineView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)))
//        //// self.view.addSubview(timelineView!)
//        //// self.timelineView?.setTemplateHandler(templateHandler: engine.templateHandler)
//        //
//        //
//        //// engine.prepareSceneUIView()
//        // // engine.observeCurrentActions()
//        //// engine.observeActionState()
//        //// engine.sceneManager.setTemplateHandler(templateHandler: engine.templateHandler)
//        //// engine.undoRedoManager?.setTemplateHandler(templateHandler: engine.templateHandler)
//        //// engine.timeLoopHandler?.setCurrentTime(3.0)
//        //// engine.templateHandler.renderingState = .Edit
//        //// engine.viewManager?.addPage(pageInfo:engine.templateHandler.currentTemplateInfo!.pageInfo.first!)
//        //// engine.templateHandler.deepSetCurrentModel(id: engine.templateHandler.currentTemplateInfo!.pageInfo.first!.modelId)
//        //
//        //
//        // }
//        //
//        // }
//        // engine?.prepareScene(templateID: self.templateID, refSize: CGSize(width: 300, height: 600))
//        Task {
//            let didLoadScene = await engine!.prepareScene2(templateID: self.templateID, refSize: CGSize(width: 300, height: 600), loadThumbnails: true)
//            if didLoadScene {
//                DispatchQueue.main.async { [weak self ] in
//                    print("render success EDIT")
//                    guard let self = self else { return }
//                    guard let engine = self.engine else { return }
//                    guard let editorView = engine.editorView else { return }
//
//                    engine.viewManager = ViewManager(canvasView: editorView)
//                    engine.viewManager?.setTemplateHandler(templateHandler: engine.templateHandler)
//                    engine.prepareSceneUIView()
//                    
//                    self.timelineView = TimelineView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)))
//                    self.view.addSubview(timelineView!)
//                    self.timelineView?.setTemplateHandler(templateHandler: engine.templateHandler)
//                    addTimelineView()
//                    
//                    engine.sceneManager.setTemplateHandler(templateHandler: engine.templateHandler)
//                    engine.undoRedoManager?.setTemplateHandler(templateHandler: engine.templateHandler)
//                    
//                    engine.viewManager?.addPage(pageInfo:engine.templateHandler.currentTemplateInfo!.pageInfo.first!)
//                    _ = engine.templateHandler.deepSetCurrentModel(id: engine.templateHandler.currentTemplateInfo!.pageInfo.first!.modelId)
//                }
//            }
//        }
//    }
//    func addTimelineView() {
//        if let timelineView = timelineView{
//            if let viewDummy = editorView{
//                timelineView.translatesAutoresizingMaskIntoConstraints = false // Enable autoresizing masks
//                // Set dummy view properties
//                timelineView.backgroundColor = .orange // Set background color
//                // Add dummy view to the main view
//                self.view.addSubview(timelineView)
//                // Apply constraints to the dummy view
//                NSLayoutConstraint.activate([
//                    // Leading constraint: 0 points from the leading edge of the main view
//                    timelineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                    // Trailing constraint: 0 points from the trailing edge of the main view
//                    timelineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//                    // Height constraint: fixed height of 44 points
//                    // timelineView.heightAnchor.constraint(equalToConstant: 400 - tabbarHeight),
//                    timelineView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
//                    // Top constraint: top of dummy view is anchored to the bottom of the editor view
//                    timelineView.topAnchor.constraint(equalTo: viewDummy.bottomAnchor , constant: 0)
//                ])
//            }
//        }
//    }
//    struct EditVCModel {
//        enum DesignType {
//            case MyDesign, Server , Scratch
//        }
//        var designType:DesignType
//        var actionState : EditorUIStates
//        var isTemplatePremium : Bool
//        var templateID : Int
//        var thumbImage : UIImage?
//    }
//    // Handle My Design Templates
//    func editMyDesign() {
//        loadAsEdit()
//    }
//    func previewMyDesign() {
//        loadAsPreview()
//    }
//    // Handle Server Templates
//    func previewFreeServerDesign() {}
//    func previewPaidServerDesign() {}
//    // Handle From Scratch Templates
//    func loadFromScratch() {
//        loadAsEdit()
//    }
//    func loadAsPreview() {
//    }
//    func loadAsEdit() {
//        addEditorViewIfNeeded()
//    }
//    func loadAsEditAfterPreview() {}
//    func loadPreview() {}
//    func dismissPreview() {}
//    func addEditorViewIfNeeded() {
//    }
//    var enableViewManager: Bool = false {
//        didSet {
//            guard let engine = engine else { return }
//            guard let editorView = engine.editorView else { return }
//
//            engine.viewManager = ViewManager(canvasView: editorView)
//            engine.viewManager?.setTemplateHandler(templateHandler: engine.templateHandler)
//            engine.prepareSceneUIView()
//            engine.viewManager?.addPage(pageInfo:engine.templateHandler.currentTemplateInfo!.pageInfo.first!)
//            engine.templateHandler.deepSetCurrentModel(id: engine.templateHandler.currentTemplateInfo!.pageInfo.first!.modelId)
//            
//        }
//    }
//    var enableGestures : Bool = false {
//        didSet {
//            guard let editorView = editorView else { return }
//            editorView.gestureView.isAllGesturesEnabled = enableGestures
//        }
//    }
//    
//    var enableSceneObservables : Bool = false {
//        didSet {
//            guard let engine = engine else { return }
//            engine.sceneManager.setTemplateHandler(templateHandler: engine.templateHandler)
//        }
//    }
//    var enableUndoRedo : Bool = false {
//        didSet {
//            guard let engine = engine else { return }
//            if engine.undoRedoManager == nil {
//                engine.undoRedoManager = UndoRedoManager()
//            }
//            if engine.undoRedoExecutor == nil {
//                engine.undoRedoExecutor = UndoRedoExecuter()
//            }
//            engine.undoRedoManager?.setTemplateHandler(templateHandler: engine.templateHandler)
//            
//        }
//    }
//}




