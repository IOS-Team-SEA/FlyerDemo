//
//  ToolBarOptions.swift
//  FlyerDemo
//
//  Created by HKBeast on 12/11/25.
//

import SwiftUI
import IOS_CommonEditor

struct EditOnItem : View {
    @EnvironmentObject var currentModel : BaseModel
    
    var body: some View {
        if let model = currentModel as? ParentInfo {
            Button {
                model.editState = false
            } label: {
                HStack {
                    ToolbarImageViewSystem(imageName: AppIcons.doneCheckMark,color: AppStyle.accentColor_SwiftUI.opacity(0.5))
                    ToolBarTextItem(text: "Edit_OFF".translate(),textColor: AppStyle.accentColor_SwiftUI)

                        
                }
            }
        }
    }
}

struct UnLockItem : View {
    @EnvironmentObject var currentModel : BaseModel
    
    var body: some View {
        
        Button {
            currentModel.lockStatus = false
        } label: {
            HStack {
                ToolbarImageViewSystem(imageName: AppIcons.lock,color: AppStyle.accentColor_SwiftUI)
                ToolBarTextItem(text: "unlock_".translate(),textColor: AppStyle.accentColor_SwiftUI)

            }
        }
    }
}


struct DeleteOptionItem : View {
   
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var currentActionModel : ActionStates
    @EnvironmentObject var templateHandler : TemplateHandler

   
    
    var body : some View {
        HStack {
            Menu {
                Button(action: {
                    currentModel.softDelete = true
                   // templateHandler.deepSetCurrentModel(id: currentModel.parentId, smartSelect: false)
                   // currentActionModel.isSelectLastModel = true
                    currentActionModel.isCurrentModelDeleted = true
                    currentActionModel.updatePageAndParentThumb = true

                    currentActionModel.shouldRefreshOnAddComponent = true
                }) {
                    Text("Yes_")
                }

                Button(action: {}) {
                    Text("No_")
                }
            } label: {
                VStack {
                    ToolbarImageViewSystem(imageName: AppIcons.delete,color: .red)
                }
            }

        }
    }
}


struct LockItem : View {
    @EnvironmentObject var currentModel : BaseModel
    
    var body: some View {
      
        Button {
            currentModel.lockStatus = true
        } label: {
            VStack {
                ToolbarImageViewSystem(imageName: AppIcons.unLock)
            }
        }
           
    }
}

struct EditItem : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var actions : ActionStates
    
    var body: some View {
        if let model = currentModel as? ParentInfo {
            Button {
                model.editState = true
            } label: {
                VStack {
                    ToolBarTextItem(text: "Edit_".translate(),textColor: AppStyle.accentColor_SwiftUI)
                }
            }
        }else if let model = currentModel as? TextInfo {
            Button {
                actions.didEditTextClicked = true
            } label: {
                VStack {
                    ToolBarTextItem(text: "Edit_".translate(),textColor: AppStyle.accentColor_SwiftUI)
                }
            }
        }
           
    }
}

struct ReplaceStickerItem : View {
    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var actionState : ActionStates
    @Binding var didTapReplaceSticker : Bool
    var body: some View {
        if let currentModel = currentModel as? StickerInfo {
            Button {
                didTapReplaceSticker = true
            } label: {
                VStack {
                    ToolbarImageViewSystem(imageName: AppIcons.stickerReplace)
                }
            }
            
        }
    }
}


struct ThreeDotOptionItem : View {

    @EnvironmentObject var currentModel : BaseModel
    @EnvironmentObject var templateHandler: TemplateHandler
  //  @Binding var didReplaceClicked : Bool
    var currentActionModel : ActionStates {
        return templateHandler.currentActionState
    }
    var body : some View {
        HStack {
            // Action Menu
            Menu {
                Button {
                    currentActionModel.copyModel = currentModel.modelId
                } label: {
                    Text("Copy_")
                }

                Button {
                    currentActionModel.duplicateModel = currentModel.modelId
                } label: {
                    Text("Duplicate_")
                }
                if !currentActionModel.multiModeSelected {
                    Button {
                        currentActionModel.multiModeSelected = true
                    } label: {
                        Text("Create_Group_")
                    }
                }
            } label: {
                ToolbarImageViewSystem(imageName: AppIcons.threeDotButton)
            }
        }
    }
}


public struct AppIcons {
    static var threeDotButton = "ellipsis.circle"
    static public var delete = "trash"
    static var lock = "lock.fill"
    static var unLock = "lock.open"
    static var doneCheckMark = "checkmark"
    static var stickerReplace = "repeat"
    
}

struct ToolbarImageViewSystem : View {
    var imageName: String
    var color: Color = .black
    var size: CGFloat = 20
    
    var body: some View {
       
        SwiftUI.Image(systemName: imageName)
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .frame(width: size, height: size)
            .frame(width: 25, height: 25)

    }
}

struct ToolSeparator : View {
    var body: some View {
        
        Text("|").multilineTextAlignment(.center).font(.footnote).frame(height: 30).foregroundStyle(.secondary)
    }
}

struct ToolBarTextItem : View {
    var text: String
    var textColor : Color = .secondary
    var body: some View {
        Text(text).multilineTextAlignment(.center).font(.footnote).frame(height: 30).foregroundStyle(textColor)

    }
}
