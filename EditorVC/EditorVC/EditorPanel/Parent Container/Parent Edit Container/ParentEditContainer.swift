//
//  ParentEditContainer.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 10/04/24.
//

import SwiftUI
import IOS_CommonEditor

struct ParentEditContainer: View {
    
    @StateObject var currentModel : ParentInfo
    @StateObject var actionStates: ActionStates
    
    @State var didLayersTabClicked : Bool    = false
    @State var didStickerTabClicked : Bool   = false
    @State var didTextTabClicked : Bool      = false
    @State var didDoneTabClicked: Bool      = false
    
    weak var delegate : (ContainerHeightProtocol)?
    @State var stickerInfo: [String:String] = [:]
    @State var uniqueCategories: [String] = []
    @State var currentText: String = ""
    
    var body: some View {
        VStack{
            
//            ParentEditContainerTabbar(didLayersTabClicked: $didLayersTabClicked, didStickerTabClicked: $didStickerTabClicked, didTextTabClicked: $didTextTabClicked, didDoneTabClicked: $didDoneTabClicked, delegate: delegate)
        }
//        .halfSheet(showSheet: $didStickerTabClicked) {
//            NavigationView {
//                StickerPicker(/*stickerInfo: $stickerInfo, */newStickerAdded: $actionStates.addImage, isStickerPickerPresented: $didStickerTabClicked, uniqueCategories: $uniqueCategories)
//                    .navigationTitle("Stickers")
//                    .onAppear(){
////                        let stickerImages = StickerDBManager.shared.getStickerImages()
////                        
////                        let stickerInfoMap = StickerDBManager.shared.getStickerInfo(resID: stickerImages)
////
////                        uniqueCategories = Array(Set(stickerInfoMap.values)).sorted()
////                        stickerInfo = stickerInfoMap
//                        uniqueCategories = DataSourceRepository.shared.getUniqueStickerCategories()
//                    }
//            }.navigationViewStyle(.stack)
//        }
//        onEnd: {
//            print("Dismis")
//            didStickerTabClicked.toggle()
//        }
//        
//        .halfSheet(showSheet: $didTextTabClicked) {
//            TextEditorView(isTextPickerPresented: $didTextTabClicked, currentText: $currentText, oldText: $currentModel.oldText, newText: $actionStates.addNewText)
//        }
//    onEnd: {
//        print("Dismis")
//        didTextTabClicked.toggle()
//    }
    }
}


