import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
import IOS_CommonEditor

//struct PagesView: View {
//    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
//    @State private var draggingItem : MultiSelectedArrayObject?
//    @StateObject var pageActionState : ActionStates
//    @Binding var orderInParent : Int
//    var body: some View {
//        VStack{
//            ScrollView(.vertical, showsIndicators: false) {
//                ScrollViewReader { proxy in
//                    LazyVGrid(columns: columns, spacing: 16) {
//                        ForEach(pageActionState.pageModelArray, id: \.id) { page in
//                            let image = page.thumbImage
//                            let width = image?.mySize.width ?? 1.0
//                            let height = image?.mySize.width ?? 1.0
//                            let aspectRatio = width / height //image.mySize?.width / image.mySize?.height
//                            if let image = page.thumbImage {
//                                VStack {
//                                    SwiftUI.Image(uiImage: image)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
//                                        .frame(width: aspectRatio * 150, height: 150)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 8)
//                                                .stroke((pageActionState.selectedPageID == page.id ? Color.systemPink : Color.clear), lineWidth: 4)
//                                        )
//                                        .cornerRadius(8)
//                                        .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 15)
//                                        .onTapGesture {
//                                            pageActionState.selectedPageID = page.id
//                                        }
//                                }.onDrag({
//                                    print("Dragging Start")
//                                    draggingItem = page
//                                    return NSItemProvider()
//                                    
//                                })
//                                .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: page, pages: $pageActionState.pageModelArray, draggedItem: $draggingItem, orderInParent: $orderInParent, hasOnce: $pageActionState.hasOnce))
//                            }
//                            else{
//                                ProgressView()
//                                    .frame(width: aspectRatio * 150, height: 150)
//                            }
//                        }
//                        
//                        VStack{
//                            Button(action: {
//                                pageActionState.addNewpage = BGColor(bgColor: .clear)
//                            }) {
//                                VStack{
//                                    SwiftUI.Image(systemName: "plus")
//                                        .resizable()
//                                        .foregroundColor(.black)
//                                        .padding()
//                                        .frame(width: 50, height: 50)
//                                }.frame(width: 150, height: 150)
//                                
//                            }
//                            .frame(width: 150, height: 150)
//                            
//                        }
//                        .frame(width: 150, height: 150)
//                        .background(.white)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray, lineWidth: 2)
//                        )
//                        .cornerRadius(8)
//                        
//                    }
//                    .padding()
//                    .onAppear {
//                        proxy.scrollTo(3455, anchor: nil)
//                    }
//                }
//            }
//            
//            HStack(spacing: 20){
//                // Button to add a new PageContentView
//                Button(action: {
//                    pageActionState.duplicateModel = pageActionState.selectedPageID
//                }) {
//                    HStack {
//                        SwiftUI.Image("Duplicate")
//                            .resizable()
//                            .renderingMode(.template)
//                            .tint(.gray)
//                            .frame(width: 25, height: 25)
//                        
//                        Text("Duplicate_").foregroundColor(.gray)
//                    }
//                    .frame(width: 160, height: 50)
//                    .background(Color.white)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.gray, lineWidth: 2)
//                    )
//                    .cornerRadius(8)
//                }
//                
//                // Button to delete the last PageContentView
//                Button(action: {
//                    if pageActionState.pageModelArray.count > 1{
//                        pageActionState.deletedPageID = pageActionState.selectedPageID
//                    }
//                    
//                }) {
//                    HStack {
//                        SwiftUI.Image("delete")
//                            .resizable()
//                            .renderingMode(.template)
//                            .tint(.pink)
//                            .frame(width: 25, height: 25)
//                        
//                        Text("Delete_").foregroundColor(.pink)
//                    }
//                    .frame(width: 160, height: 50)
//                    .background(Color.white)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.pink, lineWidth: 2)
//                    )
//                    .cornerRadius(8)
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//    
//}

