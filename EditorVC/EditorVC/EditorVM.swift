//
//  EditorVM.swift
//  VideoInvitation
//
//  Created by HKBeast on 21/08/23.
//

import Foundation
import Combine
import IOS_CommonEditor
import UIKit

class EditorVM: ObservableObject{
    
    deinit{
        printLog("de-init \(self)")
//        metalEngine?.templateHandler = nil
    }
    
    
   
    
//    //MARK: - Sticker Model
//    var stickerModel : StickerInfo? = StickerInfo()
//    
//    //MARK: - Sticker Action Model
////    var stickerActionsModel : ActionStates = ActionStates()
//    
//    //MARK: - Text Model
//    var textModel : TextInfo? = TextInfo()
//    
//    //MARK: - Text Action Model
//    var textActionsModel : TextActionsModel? = TextActionsModel()
//    
    //MARK: - Variables
    var metalEngine : MetalEngine?
    var thumbImage: UIImage
    var templateId: Int
    @MainActor var dsStore = DataSourceStore()

//    @Published public var didPreviewTapped: Bool = false
//    @Published public var didWatchAdsTapped: Bool = false
    @Published public var didGetPremiumTapped: Bool = false
//    @Published public var didLayersTapped: Bool = false
//    @Published public var didMusicPlayOnEditor: Bool = false
    @Published public var showThumbnailNavItems: Bool = false
    
//    @Published var editorUIState : EditorUIStates = .UseMe
    
    init(templateId: Int, thumbImage: UIImage) {
        self.templateId = templateId
        self.thumbImage = thumbImage
        printLog("init \(self)")
        metalEngine = MetalEngine(logger: AppPackageLogger(), resourceProvider: AppResourceProvider(), engineConfig: AppEngineConfigure(), sceneConfig: AppSceneConfigure(), layerConfig: AppLayersConfigure(), vmConfig: AppViewManagerConfigure())
     
    }
    //MARK: - Methods
    
//    func prepareScene(id:Int , refSize:CGSize) {
//        viewDummy.addSubview(hostingerMusic.view)
//        defer{
//            metalEngine.prepareScene(templateID: id , refSize:refSize)
//        }
//        metalEngine.canPlayScene = { success, error in
//            print("STARTED RENDERING")
//        }
//        
//        
//    }
    
//    func playCurrentScene() {
//        
//    }
//    
//    func onChangeOpacity(){
//        // must convert into 0-1
//     //   metalEngine.didChangeOpacity(0-1)
////        metalEngine.listenCurrentModel()
//        print(" Opacity: \(stickerModel?.modelOpacity)")
//    }
//    
//    func onSetSelected(){
//     //   controlPanel(model)
//       // layers(model)
//    }
    
}
