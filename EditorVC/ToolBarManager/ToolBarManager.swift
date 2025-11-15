//
//  ToolBarManager.swift
//  FlyerDemo
//
//  Created by HKBeast on 12/11/25.
//

import Foundation
import IOS_CommonEditor
import SwiftUI

class ToolBarMiniViewManager : ToolBarIntegrator {
    
    weak var engine: MetalEngine?
    
    init(engine: MetalEngine) {
        self.engine = engine
    }
    
    func getEasyToolBar() -> any View {
        guard let engine = engine else {
            logError("engine nil inside tool bar manager")
            return EmptyView()
        }
        let view = EasyToolBar()
            .environmentObject(engine.templateHandler!)
            .environment(\.sizeCategory, .medium)
        return view
    }
    
    func getEditToolBar(id: Int, currentModel: IOS_CommonEditor.ParentInfo) -> any View {
        let view = EditControlBar(id: id, currentModel: currentModel)
        return view
    }
}
