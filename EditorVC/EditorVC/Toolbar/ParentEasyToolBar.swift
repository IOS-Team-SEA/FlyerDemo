//
//  ParentEasyToolBar.swift
//  FlyerDemo
//
//  Created by HKBeast on 12/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct ParentEasyToolBar : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var currentActionModel : ActionStates
    
    var body: some View {
        if let model = currentModel as? ParentInfo {
            
            
            
            
            if model.lockStatus {
                
                HStack {
                    
                    UnLockItem()
                    
                }.frame(width: 180)
                
                
            } else if model.editState {
                
                HStack {
                    
                    EditOnItem()
                    
                }.frame(width: 180)
                
            } else /* Selected  */{
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
