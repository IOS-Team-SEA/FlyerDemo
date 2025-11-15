//
//  TextEasyToolBar.swift
//  FlyerDemo
//
//  Created by HKBeast on 12/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct TextEasyToolBar : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var currentActionModel : ActionStates
    
    var body: some View {
        
        if currentModel is TextInfo {
               
            if currentModel.lockStatus {
                    
                HStack {
                       
                        UnLockItem()
                       
                }.frame(width: 180)
                  
                  
        } else {
                HStack {
                          
                    EditItem()
                    ToolSeparator()
                    LockItem()
                    ThreeDotOptionItem()
                    ToolSeparator()
                    DeleteOptionItem()
                            
                }.frame(width: 180)
              
                }
                    
                

        }
            
        
    }
}
