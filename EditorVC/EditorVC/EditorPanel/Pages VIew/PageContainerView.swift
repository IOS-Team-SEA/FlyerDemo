//
//  PageContainerView.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/07/24.
//

import SwiftUI
import IOS_CommonEditor

struct PageContainerView: View {
    @StateObject var actionState : ActionStates
    @StateObject var currentPageModel : PageInfo
  // Action State And PageInfo - No Template Handler
//    @State var orderInParent : Int = 0
    // A computed binding for `orderInParent`
    func updateModelDeletionStatus(models:  [PageInfo], currentIndex: Int) -> Int? {
        
        // Find the previous or next model that is not soft deleted
        var newIndex: Int?

        // Check previous models
        for i in stride(from: currentIndex - 1, through: 0, by: -1) {
            if !models[i].softDelete {
                newIndex = i
                break
            }
        }

        // If no previous model found, check next models
        if newIndex == nil {
            for i in stride(from: currentIndex + 1, to: models.count, by: 1) {
                if !models[i].softDelete {
                    newIndex = i
                    break
                }
            }
        }

        // Return the index of the new selected model or nil if no model is found
        return newIndex
    }
    
    // Environment variable to access the presentation mode
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HStack{
                HStack(alignment: .center, content: {
                    Text("Pages_").font(.title)
                }).padding()
                
                HStack(alignment: .lastTextBaseline, content: {
                    Spacer()
                    HStack{
                        Text("Done_")
                            .foregroundColor(.pink)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    .frame(width: 50, height: 28)
                    //                .background(.black)
                    //                .cornerRadius(15.0)
                }).padding()
            }
            
//            PagesView(pageActionState: actionState, orderInParent: $currentPageModel.orderInParent)
        }
        .onAppear {
            actionState.updatePageArray = true
           
        }
//        .onChange { pageInfo.thumbIamge } {
//            
//            array model id = pageInfo.id
//            thumb = image
//        }
//        .onChange(of: deletedModelID, perform: { deletedModelID in
//            actionState.currentModel?.softDelete = true
//            var pageInfoArray = actionState.currentTemplateInfo!.pageInfo
//            
//            if let index = pageInfoArray.firstIndex(where: { $0.modelId == deletedModelID }) {
//                print("Found model at index \(index)")
//                let newIndex = updateModelDeletionStatus(models: pageInfoArray, currentIndex: index)
//                let modelId = pageInfoArray[newIndex!].modelId
//                actionState.setCurrentModel(id: modelId)
//                
//            } else {
//                print("Model with ID \(deletedModelID) not found")
//            }
//            actionState.pageModelArray = actionState.getPageModelFromPageInfo()
//        })
        
//        .onChange(of: selectedModelID, perform: { selectedModelID in
//            actionState.setCurrentModel(id: selectedModelID)
//        })
//        .onReceive(actionState.$currentPageModel) { model in
//            selectedModelID = model!.modelId
//        }
    }
}
//
//// Preview for the SwiftUI view
//struct PageContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Provide a mock or real instance of TemplateHandler
//        let templateHandler = TemplateHandler()
//        PageContainerView(templateHandler: templateHandler)
//    }
//}

