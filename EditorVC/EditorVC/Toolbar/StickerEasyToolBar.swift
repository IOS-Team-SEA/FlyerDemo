//
//  StickerEasyToolBar.swift
//  FlyerDemo
//
//  Created by HKBeast on 12/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct StickerEasyToolBar : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var currentActionModel : ActionStates

    @State var uniqueCategories: [String] = []
    @State var didReplaceClicked: Bool = false 
    
   
    
    var body: some View {
      
        if currentModel is StickerInfo {
            
            if currentModel.lockStatus {
                
                HStack {
                    
                    UnLockItem()
                    
                }.frame(width: 180)
                
                
            } else {
                HStack {
                    
                    ReplaceStickerItem(didTapReplaceSticker: $didReplaceClicked)
                    ToolSeparator()
                    LockItem()
                    ThreeDotOptionItem()
                    ToolSeparator()
                    DeleteOptionItem()
                    
                }.frame(width: 180)
                    .fullScreenCover(isPresented: $didReplaceClicked) {
                        NavigationView {
                            StickerPicker(
                                newStickerAdded: $currentActionModel.replaceSticker,
                                isStickerPickerPresented: $didReplaceClicked,
                                uniqueCategories: $uniqueCategories,
                                previousSticker : (currentModel as? StickerInfo)!.changeOrReplaceImage?.imageModel,
                                replaceSticker: $currentActionModel.replaceSticker,
                                updateThumb: $currentActionModel.updateThumb
                                
                            )
                            .navigationTitle("Sticker_").environment(\.sizeCategory, .medium)
                            .navigationBarItems(trailing: Button(action: {
                                // Action for done button
                                didReplaceClicked = false
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
                            .navigationBarTitleDisplayMode(.inline)
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
            }
            
            
            
        }
            
        
    }
}
