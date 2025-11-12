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
    
    var engine: MetalEngine
    
    init(engine:MetalEngine) {
        self.engine = engine
    }
    
    func getEasyToolBar() -> any View {
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
