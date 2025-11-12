//
//  EasyToolBar.swift
//  FlyerDemo
//
//  Created by HKBeast on 12/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct EasyToolBar: View {
    
    @EnvironmentObject var templateHandler : TemplateHandler
    
    var body : some View {
        if let currentModel = templateHandler.currentModel {
            HStack {
                
                // it will depend upon which of currentModel is of Type
                if templateHandler.currentModel is StickerInfo {
                    StickerEasyToolBar()
                } else if templateHandler.currentModel is TextInfo {
                    TextEasyToolBar()
                } else {
                    ParentEasyToolBar()
                }
                
            } .frame(width: 180,height: 40)
                .background(.white)
                .cornerRadius(20.0)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                .environmentObject(templateHandler.currentActionState)
                .environmentObject(currentModel)
                .environmentObject(templateHandler)

        }
    }
    
    
}
