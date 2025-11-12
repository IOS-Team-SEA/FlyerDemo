//
//  EditorVC.swift
//  VideoInvitation
//
//  Created by HKBeast on 22/08/23.
//

import UIKit
import SwiftUI
import Combine
import IOS_LoaderSPM
import IOS_CommonEditor
//import IOS_CommonUtilSPM

var BASE_SIZE = CGSize.zero
var PANEL_SIZE = 50.0

enum EditorLoadingState {
    case Edit
    case Preview
    case Personalise
    case PersonaliseEdit
    case SaveNPremiumOptions
}

enum TemplatePreviewState {
    case CreateEvent
    case GotoEvent
    case Draft
}

enum EditorExitResult {
    case saved(templateId:Int)
    case discarded(templateID:Int)
    case drafted(templateID:Int)
}


class EditorVC: UIViewController, NavAction , ActionStateObserversProtocol , PlayerControlsReadObservableProtocol {
//    var personalisedVM : PersonalisedVM?
    var editorMargin : CGFloat = 0
    var safeAreaInsetsTop : CGFloat = 0.0
    var safeAreaInsetsBottom : CGFloat = 0.0
    var playerControlsCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
   
    var timelineView : IOS_CommonEditor.TimelineView?
    var actionStateCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    var editorVMCancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    var undoRedoCancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    
//    var cancellablesForPersonalised: Set<AnyCancellable> = []

    var onDismiss : ((EditorExitResult) -> ())? = nil 
    
    
//    @Injected var anayticsLogger : AnalyticsLogger
    @Injected var iapViewModel : IAPViewModel
//    @Injected var thumbStore : ThumbnailDataSource

    
    internal var overlayHostingController: UIHostingController<PasteDrop>?
    var loaderHostingController: UIHostingController<AnyView>?
    var loaderState = LoaderState()

    //MARK: - Container View
    var containerView : UIView?
    var loadingStaus : Bool = false
    var thumbnailImage: UIImage?
    var hostingerController: UIHostingController<AnyView>?
    var hostingerMusic: UIHostingController<MusicControlView>?
    var thumbImage : UIImage

    
    var exportHostingerController: UIHostingController<ExportPage>?
    
    
    var customLoader: UIHostingController<AnyView>?
    
    var containerPanelHeightConstraint : NSLayoutConstraint?
    
    let viewDummy : UIView = UIView()
    
    var muteButton: UIButton!
    
    var muteHostingerController : UIHostingController<MuteControl>!
  //  @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
    
    var controlPanelManager: ControlPanelManager?
    
    //MARK: - Outlets
    internal var navTitle: UILabel!
    
    var editorView : EditorView? {
        return engine?.editorView
    }
    
   // var cancellables: Set<AnyCancellable> = []
    var cancellablesForEditor: Set<AnyCancellable> = []
    
    //MARK: - Variables
//    var viewModel = EditorVM()
    weak var viewModel: EditorVM?


    var engine : MetalEngine? {
        return viewModel?.metalEngine
    }
    
     var undoButton:UIBarButtonItem?
     var redoButton:UIBarButtonItem?
     var exportButton:UIBarButtonItem?
     
    // menu button
    var resizeAction: UIAction?
    var layersAction: UIAction?
    var convertToImage: UIAction?
    var zoomEnable: UIAction?
    var previewAction: UIAction?
    var pagesAction: UIAction?
    var snapAction: UIMenu?
    var timelineAction: UIMenu?
    var multiSelectAction: UIAction?
    var mainMenu: UIBarButtonItem?
    
    var group: UIBarButtonItem?
    var cancel: UIBarButtonItem?
    
    //var viewManager : UISceneViewManager? = UISceneViewManager()
    
    internal var currentTemplateID:Int
//    internal var currentTemplateInfo: TemplateInfo
    
    var useMeButton : UIButton!
    var loadingState : EditorLoadingState = .Edit
    
//    var userDesignsVM = Injection.shared.inject(id: "UserDesignVM", type: UserDesignVM.self)!

//    init(templateID : Int, thumbImage : UIImage){
////        viewModel = EditorVM()
//        currentTemplateID = templateID
//       
//        self.thumbImage = thumbImage
//        super.init(nibName: "EditorVC", bundle: nil)
//       
//        
//    }
    
    init(viewModel: EditorVM){
        self.viewModel = viewModel
//        self.currentTemplateInfo = viewModel.templateInfo
        currentTemplateID = viewModel.templateId
        self.thumbImage = viewModel.thumbImage
        super.init(nibName: "EditorVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        actionStateCancellables.removeAll()
        undoRedoCancellables.removeAll()
        cancellablesForEditor.removeAll()
        playerControlsCancellables.removeAll()
        editorVMCancellables.removeAll()
        controlPanelManager?.editorVC = nil
        controlPanelManager?.cpmCancellables.removeAll()
        controlPanelManager = nil
        engine?.drawCallManager?.stopNotifyingDrawCall()
//        anayticsLogger.logEditorInteraction(action: .exit)

  //      cancellables.removeAll()
//        backButtonCleanUP()
        print("de-init \(self)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        safeAreaInsetsTop = (UIApplication.shared.cWindow?.safeAreaInsets.top ?? 0)
        safeAreaInsetsBottom = (UIApplication.shared.cWindow?.safeAreaInsets.bottom ?? 0)
        addShimmerEffect()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Create a label for the center text
        navTitle = UILabel()
        navTitle.text = loadingState == .Preview ? "Preview_".translate() : "".translate()
        navTitle.sizeToFit()
        // Set the text label as the title view
        navigationItem.titleView = navTitle
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground//UIColor(named: "editorBG")!
        
//        setEditorView()
        setupControlPanelManager()
        setViewsNLoadTemplate2()
        
        observeUndoRedoCount()
    }
   
    
    override func didReceiveMemoryWarning() {
        logError("Memory Warning")
    }
 
    //MARK: - Methods
    
    override func viewDidLayoutSubviews() {
        editorView?.layoutSubviews()
        if let hostingerController = hostingerController{
            if let containerView = containerView{
                hostingerController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
                hostingerController.reloadInputViews()
            }
        }
        
//        if let hostingVC = shimmerEditorView {
//            hostingVC.view.frame = self.view.bounds
//        }
//        
        if let loaderHostingVC = customLoader{
            loaderHostingVC.view.frame = self.view.bounds
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Check if the view controller is being popped from the navigation stack
        if isMovingFromParent {
            // Remove toolbar items here
//            navigationController?.setToolbarItems(nil, animated: true)
//            if let hostingerController = hostingerController{
//                hostingerController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
//                hostingerController.reloadInputViews()
//            }
            engine?.animTimeLoopHandler?.animLoopState = .Stop
        }
    }
  
    func setupControlPanelManager() {
        if controlPanelManager == nil {
            controlPanelManager = ControlPanelManager(editorVC: self)
        }
    }
    
    // Function for removing the all toolbar buttons.
    func removeToolBar(){
        navigationItem.rightBarButtonItems?.removeAll()
    }
    
    func updateBarButtonItem(_ barButtonItem: UIBarButtonItem, newText: String) {
        if let button = barButtonItem.customView as? UIButton {
            button.setTitle(newText, for: .normal)
            button.sizeToFit()  // Resize the button to fit the new title
        }
    }
    
    
    func addToolBar() {
        
        
        // Create a function to generate the custom view for the UIBarButtonItem
        func createBarButtonItem(imageName: String, text: String, action: Selector) -> UIBarButtonItem {
            // Create a UIButton and set its image and title
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: imageName), for: .normal)
            button.setTitle(text, for: .normal)
            button.sizeToFit()
            
            // Adjust the spacing between the image and the title
            button.tintColor = .systemBlue  // Set the desired tint color
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)  // Set the desired font size
            button.contentHorizontalAlignment = .center
            button.semanticContentAttribute = .forceLeftToRight  // Image on the left, text on the right
            
            // Add target action
            button.addTarget(self, action: action, for: .touchUpInside)
            
            // Create a UIBarButtonItem with the custom UIButton
            let barButtonItem = UIBarButtonItem(customView: button)
            
            return barButtonItem
        }
        
        var undoRedoState = false
        // Now create your undo and redo buttons with text
        if undoButton == nil{
            undoButton = createBarButtonItem(
                imageName: "arrow.uturn.backward.circle.fill",
                text: "Undo_".translate(),
                action: #selector(undoAction)
            )
        }
        else {
            undoRedoState = true
        }
        if redoButton == nil{
            redoButton = createBarButtonItem(
                imageName: "arrow.uturn.forward.circle.fill",
                text: "Redo_".translate(),
                action: #selector(redoAction)
            )
        }
        else {
            undoRedoState = true
        }
        
        
        
        
        
        
        //        let redoButton = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(redoAction))
        
        exportButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(exportAction))
        
        multiSelectAction = UIAction(title: "Multi_Select".translate(), image: UIImage(systemName: "square.on.square.dashed"), handler: { [weak engine] _ in
            guard let engine = engine else { return }
            // Perform play action
            //            hostingerController?.rootView = AnyView(ParentContainer(currentModel: ParentInfo(), actionStates: self.engine.templateHandler.actionStates, delegate: self))
            
            engine.templateHandler.currentActionState.multiModeSelected = true
        })
        
        
        resizeAction = UIAction(title: "Resize_".translate(), image: UIImage(systemName: "square.resize"), handler: { [weak self,weak engine] _ in
            guard let engine = engine else { return }
            guard let self = self else { return }
            
            // Perform play action
            self.present(UIHostingController(rootView: RatioPickerGridView(currentActionState: engine.templateHandler.currentActionState, onRatioSelected: {
                self.dismiss(animated: true)
            }, createNewTapped: false).environmentObject(UIStateManager.shared).environment(\.sizeCategory, .medium)), animated: true)
            
        })
        layersAction = UIAction(title: "Layers_".translate(), image: UIImage(systemName: "square.3.layers.3d"), handler: { [weak self,weak engine] _ in
            guard let engine = engine else { return }
            guard let self = self else { return }
            
            if engine.templateHandler.currentPageModel?.activeChildren.count == 0{
                showNoLayerAlert()
            }else{
                let layersManager = engine.layersManager
                layersManager.setTemplateHandler(th: engine.templateHandler)
                let vc = StackedViewController(viewModel:layersManager ,multiPlier: 1)
                self.addChildVCWithMultiplier(vc,heightMultiplier: 1)
                self.navigationController?.isNavigationBarHidden = true
            }
        })
        
        convertToImage = UIAction(title: "Convert to Video".translate(), image: UIImage(systemName: "square.3.layers.3d"), handler: { [weak engine] _ in
            guard let engine = engine else { return }
            engine.templateHandler.currentTemplateInfo?.outputType = .Video
        })
        
        /* Neeshu Chnage For Zoom Control Enable*/
        
        zoomEnable = UIAction(title: "Zoom_Enable".translate(), image: UIImage(systemName: "square.arrowtriangle.4.outward")) {
            [weak engine] _ in
            guard let engine = engine else { return }
            engine.templateHandler.currentActionState.zoomEnable.toggle()
        }
        
        previewAction = UIAction(title: "Preview_".translate()) {  [weak engine] _ in
            guard let engine = engine else { return }
            
            engine.templateHandler.currentActionState.didPreviewTapped = true
            //                self.viewModel.didPreviewTapped = true
        }
        
        
        pagesAction = UIAction(title: "Pages_".translate(), image: UIImage(systemName: "doc"), handler: { [weak self,weak engine] _ in
            guard let engine = engine else { return }
            guard let self = self else { return }
            guard let templateHandler = engine.templateHandler else { return }
            guard let modelId = templateHandler.currentModel?.modelId else { return }
            
            
            // Perform stop action
            let pageContainer = PageContainerView(actionState: templateHandler.currentActionState, currentPageModel: templateHandler.currentPageModel!).environmentObject(self.viewModel!.dsStore).environment(\.sizeCategory, .medium)
            
            let hostingController = UIHostingController(rootView:pageContainer)
            hostingController.modalPresentationStyle = .fullScreen
            self.present(hostingController, animated: true)
            
            
        })
        
        let basicAction = UIAction(
            title: "Basic_".translate(),
            state: PersistentStorage.snappingMode == 1 ? .on : .off,
            handler: { [weak self,weak engine] _ in
                guard let engine = engine else { return }
                guard let self = self else { return }
                
                engine.templateHandler.currentActionState.snappingMode = .basic
                PersistentStorage.snappingMode = 1
                self.removeToolBar()
                self.addToolBar()
            }
        )
        
        let advancedAction = UIAction(
            title: "Advanced_".translate(),
            state: PersistentStorage.snappingMode == 2 ? .on : .off,
            handler: { [weak self,weak engine] _ in
                guard let engine = engine else { return }
                guard let self = self else { return }
                engine.templateHandler.currentActionState.snappingMode = .advanced
                PersistentStorage.snappingMode = 2
                self.removeToolBar()
                self.addToolBar()
            }
        )
        
        let offAction = UIAction(
            title: "Off_".translate(),
            state: PersistentStorage.snappingMode == 0 ? .on : .off,
            handler: { [weak self,weak engine] _ in
                guard let engine = engine else { return }
                guard let self = self else { return }
                engine.templateHandler.currentActionState.snappingMode = .off
                PersistentStorage.snappingMode = 0
                self.removeToolBar()
                self.addToolBar()
            }
        )
        
        snapAction = UIMenu(title: "Snapping_".translate(), image: UIImage(systemName: "grid"), children: [basicAction, advancedAction, offAction])
        
        // Perform stop action
        let hideAction = UIAction(title: "Hide_".translate(), handler: { [weak engine] _ in
            guard let engine = engine else { return }
            
            
            //                print("Selected Yes")
            //                engine.templateHandler.currentActionState.timelineHide = true
            //                engine.timelineView.isHidden = true
            engine.templateHandler.currentActionState.timelineShow = false
        })
        
        let showAction = UIAction(title: "Show_".translate(), handler: { [weak engine] _ in
            guard let engine = engine else { return }
            // Handle "No" action
            //                engine.templateHandler.currentActionState.timelineShow = true
            //                engine.timelineView.isHidden = false
            engine.templateHandler.currentActionState.timelineShow = true
            print("Selected No")
        })
        
        
        timelineAction = UIMenu(title: "Timeline_".translate(), image: UIImage(systemName: "film"), children: [hideAction, showAction])
        
        
        // Create menu with menu items
        //            let menu2 = UIMenu(title: "", children: [Layers, resizeAction, pages, UIMenuElement.separator(), multiSelect, timeline, snap])
        var menu2 = UIMenu(title: "", children: [
            UIMenu(title: "", options: .displayInline, children: [layersAction!, resizeAction!]),
            UIMenu(title: "", options: .displayInline, children: [zoomEnable!]),
            UIMenu(title: "", options: .displayInline, children: [previewAction!]),
            //                UIMenu(title: "", options: .displayInline, children: [multiSelect]),
            //                UIMenu(title: "", options: .displayInline, children: [timeline]),
            UIMenu(title: "", options: .displayInline, children: [snapAction!])
        ])
        guard let engine = engine else { return }
        if engine.templateHandler.currentTemplateInfo?.outputType == .Image {
            menu2 = UIMenu(title: "", children: [
                UIMenu(title: "", options: .displayInline, children: [layersAction!, convertToImage!]),
                UIMenu(title: "", options: .displayInline, children: [zoomEnable!]),
                UIMenu(title: "", options: .displayInline, children: [previewAction!]),
                UIMenu(title: "", options: .displayInline, children: [multiSelectAction!]),
                //                UIMenu(title: "", options: .displayInline, children: [timeline]),
                UIMenu(title: "", options: .displayInline, children: [snapAction!])
            ])
            
        } else {
            menu2 = UIMenu(title: "", children: [
                UIMenu(title: "", options: .displayInline, children: [layersAction!, resizeAction!]),
                UIMenu(title: "", options: .displayInline, children: [zoomEnable!]),
                UIMenu(title: "", options: .displayInline, children: [previewAction!]),
                UIMenu(title: "", options: .displayInline, children: [multiSelectAction!]),
                UIMenu(title: "", options: .displayInline, children: [timelineAction!]),
                UIMenu(title: "", options: .displayInline, children: [snapAction!])
            ])
            
        }
        
        
        
        // Create UIBarButtonItem with the menu
        mainMenu = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu2)
        navigationItem.hidesBackButton = false
        navigationItem.rightBarButtonItems = [exportButton!,redoButton!,undoButton!,mainMenu!]
        
        if let nav = findVisibleNavigationController() {
            nav.topViewController?.navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems
            nav.topViewController?.navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems
            nav.topViewController?.title = navigationItem.title
        }
        if !undoRedoState{
            undoButton?.isEnabled = false
            redoButton?.isEnabled = false
        }
        
    }
    
    func showImageNavigationBar(){
        var menu2 = UIMenu(title: "", children: [
            UIMenu(title: "", options: .displayInline, children: [layersAction!, convertToImage!]),
            UIMenu(title: "", options: .displayInline, children: [zoomEnable!]),
            UIMenu(title: "", options: .displayInline, children: [previewAction!]),
            UIMenu(title: "", options: .displayInline, children: [multiSelectAction!]),
            //                UIMenu(title: "", options: .displayInline, children: [timeline]),
            UIMenu(title: "", options: .displayInline, children: [snapAction!])
        ])
        mainMenu = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu2)
        navigationItem.rightBarButtonItems = [exportButton!,redoButton!,undoButton!,mainMenu!]
        
        if let nav = findVisibleNavigationController() {
            nav.topViewController?.navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems
            nav.topViewController?.navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems
            nav.topViewController?.title = navigationItem.title
        }
    }
   
    func showVideoNavigationBar(){
        var menu2 = UIMenu(title: "", children: [
            UIMenu(title: "", options: .displayInline, children: [layersAction!, resizeAction!]),
            UIMenu(title: "", options: .displayInline, children: [zoomEnable!]),
            UIMenu(title: "", options: .displayInline, children: [previewAction!]),
            UIMenu(title: "", options: .displayInline, children: [multiSelectAction!]),
            UIMenu(title: "", options: .displayInline, children: [timelineAction!]),
            UIMenu(title: "", options: .displayInline, children: [snapAction!])
        ])
        mainMenu = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu2)
        navigationItem.rightBarButtonItems = [exportButton!,redoButton!,undoButton!,mainMenu!]
        
        if let nav = findVisibleNavigationController() {
            nav.topViewController?.navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems
            nav.topViewController?.navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems
            nav.topViewController?.title = navigationItem.title
        }
    }
  
   
    func onBackPressed() {
        if let navController = self.navigationController as? MyNavigationController {
            
            presentDiscardOrSaveAlert { [weak self] in
                guard let self = self else { return }
                onExitEditorVC()
                onDismiss?(.drafted(templateID: currentTemplateID))
            } onDiscard: { [weak self] in
                guard let self = self else { return }
//                _ = DBManager.shared.updateTemplateSoftDelete(templateId: currentTemplateID, newValue: 0)
                _ = DBManager.shared.deleteTemplateRow(templateId: currentTemplateID, ratioId: 0)
                onExitEditorVC()
                onDismiss?(.discarded(templateID: currentTemplateID))
            } onCancel: {
                printLog("Cancelled")
            }

            
  
        }
    }
    
    func onExitEditorVC() {
        if let navController = self.navigationController as? MyNavigationController {
            
            engine?.templateHandler.playerControls?.renderState = .Completed
            
            if engine?.templateHandler.currentTemplateInfo?.category != "DRAFT"{
//                self.anayticsLogger.endEditorSession(exitReason: .completed)
            }
            else {
//                self.anayticsLogger.endEditorSession(exitReason: .abandoned)
            }
            //            cancellables.removeAll()
            
            if let window = UIApplication.shared.keyWindow {
                Loader.showLoader(in: window, text: "Loading_".translate())
            }
            
            Task{
                await updateNecessaryValues()
                
                //            backButtonCleanUP()
                //           // UndoRedoManager.shared.clearStacks()
                //            DataSourceRepository.shared.cleanUp()
                //            print("back pressed on editor VC")
                viewModel?.dsStore.cleanUp()
                
                DispatchQueue.main.async {
                    Loader.stopLoader()
                    navController.goBack()
                }
                
            }
        }
    }
    func backButtonCleanUP() {
    
//        if let engine = engine {
//            engine.templateHandler = nil
//            engine.viewManager = nil
//            engine.editorView = nil
//            engine.timeLoopHandler = nil
//            engine.thumbManagar = nil
//            engine.cancellables.removeAll()
//        }
////        DataSourceRepository.shared.cleanUp()
//        self.viewModel.metalEngine = nil
//       // UndoRedoManager.shared.clearStacks()
//        engine?.undoRedoManager = nil
//        engine?.undoRedoManager = nil
//
    }
 
 
}
extension EditorVC {
    func presentDiscardOrSaveAlert(
        onSaveDraft: @escaping () -> Void,
        onDiscard: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: "Unsaved_Changes".translate(),
            message: "Do_you_want_to_discard_your_changes_or_save_them_as_a_draft".translate(),
            preferredStyle: .actionSheet // use `.alert` for a center popup
        )

        // Save as Draft
        let saveDraftAction = UIAlertAction(title: "Save_as_Draft".translate(), style: .default) { _ in
            onSaveDraft()
        }

        // Discard
        let discardAction = UIAlertAction(title: "Discard_".translate(), style: .destructive) { _ in
            onDiscard()
        }

        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel_".translate(), style: .cancel) { _ in
            onCancel?()
        }

        alert.addAction(saveDraftAction)
        alert.addAction(discardAction)
        alert.addAction(cancelAction)

        // iPad-specific: prevent crash by setting sourceView
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY - 60, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        self.present(alert, animated: true)
    }
}

extension EditorVC: EditorVCDelegate{
    func popEditorIfAvailable() {
        if let navController = self.navigationController as? MyNavigationController {
            navController.skipBackInterception = true
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func promptToExitEditor(_ completion: @escaping (_ shouldProceed: Bool) -> Void) {
        let alert = UIAlertController(
            title: "Do_you_wish_to_leave_the_editor".translate(),
            message: "Dont_worry_your_changes_will_be_saved_in_my_designs".translate(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel_".translate(), style: .cancel, handler: { _ in
            // dismiss action
            completion(false)
        }))
        
        // FIXME: JM Whats is This Logic
        alert.addAction(UIAlertAction(title: "Yes_".translate(), style: .destructive, handler: { _ in
            if let navController = self.navigationController as? MyNavigationController {
                navController.skipBackInterception = true
            }
            
            self.navigationController?.popViewController(animated: true)
            if let navController = self.navigationController as? MyNavigationController {
                navController.skipBackInterception = false
            }
            completion(true)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}

protocol EditorVCDelegate: AnyObject {
    func popEditorIfAvailable()
    func promptToExitEditor(_ completion: @escaping (_ shouldProceed: Bool) -> Void)
}

struct PasteDrop: View {
    @ObservedObject var currentModel: BaseModel
    @ObservedObject var currentActionState : ActionStates
    @State var image : UIImage
    var dismissAction: () -> Void
    
    var body: some View {
        VStack{
            HStack{
                //                Button("Cancel") {
                //                    dismissAction()
                //                }
                //                .frame(maxWidth: 60 , maxHeight: 30)
                //                .font(.caption)
                //                .foregroundColor(.black)
                //                .background(Color.systemGray6)
                //                .cornerRadius(10)
                
                Button{
                    dismissAction()
                }label:{
                    SwiftUI.Image("ic_Close")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.primary)
                        .frame(width: 15, height: 15)
                    
                }
                .frame(width: 30 , height: 30)
                .background(Color.secondarySystemBackground)
                .cornerRadius(15)
                
                
                ZStack {
                    if currentModel.modelType == .Sticker{
                        Color(uiColor: UIColor(named: "stickerLayer") ?? .blue)
                            .frame(width: 25, height: 25)
                            .cornerRadius(5)
                    }else  if currentModel.modelType == .Text{
                        Color(uiColor: UIColor(named: "textLayer") ?? .green)
                            .frame(width: 25, height: 25)
                            .cornerRadius(5)
                    }else{
                        Color(uiColor: UIColor(named: "parentExpanded") ?? .orange)
                            .frame(width: 25, height: 25)
                            .cornerRadius(5)
                    }
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                Text("One_item_copied")
                    .font(.caption)
                    .frame(width: 100, height: 40)
                    .padding(.vertical, 2)
                
                
                Button("Paste_") {
                    currentActionState.pasteModel = true
                    dismissAction()
                }
                .frame(maxWidth: 60, maxHeight: 30)
                .font(.caption)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
            }.padding()
                .frame(height: 50)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.horizontal, 15)
        .transition(.scale)
    }
}

class LoaderState: ObservableObject {
    @Published var progress: CGFloat = 0.0
    @Published var image: UIImage = UIImage(systemName: "plus")!
    @Published var didCancelTapped: Bool = false
    
    func reset() {
        didCancelTapped = false
        progress = 0
    }
}
