//
//  EditControlBar.swift
//  FlyerDemo
//
//  Created by HKBeast on 12/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct EditControlBar: View, Identifiable {
    let id : Int
    @ObservedObject var currentModel : ParentInfo
    
    var body: some View {
        VStack{
            
            if currentModel.editState {
                Button {
                    currentModel.editState = false
                } label: {
                    HStack {
                        ToolbarImageViewSystem(imageName: AppIcons.doneCheckMark,color: AppStyle.accentColor_SwiftUI.opacity(0.5))
                        ToolBarTextItem(text: "Edit_OFF".translate(),textColor: AppStyle.accentColor_SwiftUI)
                        
                        
                    }
                }
            }else {
                Button {
                    currentModel.editState = true
                } label: {
                    VStack {
                        ToolBarTextItem(text: "Edit_".translate(),textColor: AppStyle.accentColor_SwiftUI)
                    }
                }
            }
        }
        .frame(width: 30 , height: 30)
        .background(.white)
        .cornerRadius(25.0)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
    
}
