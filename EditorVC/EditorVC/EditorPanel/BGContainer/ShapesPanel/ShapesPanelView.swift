//
//  ShapesPanelView.swift
//  VideoInvitation
//
//  Created by J D on 16/10/25.
//

import SwiftUI

struct ShapesPanelView: View {
   // @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
//    @State var textureArray: [String] = BGContainerDatasource.textureArray()!
    @State var textureArray: [String] = []
    @State var isLoading: Bool = true
   

    @Binding var selectedShape: String
    @Binding  var lastSelectedshape : String
    
    var refSize : CGSize
    @State var isPremiumUser: Bool = false
    @EnvironmentObject var uiStateManager : UIStateManager
    @Binding var updateThumb: Bool
    
    let rows = [
            GridItem(.fixed(50)), // Fixed height for each row
           
        ]
    
    var body: some View {
       
        VStack{
            
            ScrollView(.horizontal, showsIndicators: false){
                ScrollViewReader{ proxy in
//                    HStack{
                    LazyHGrid(rows: rows ){
//                        if isLoading {
//                            ForEach(1..<10){ _ in
//                                ShimmerEffectBox().frame(width: 70, height: 70).cornerRadius(10.0, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//                            }
//                        }else{
                            ForEach(Array(textureArray.enumerated()), id: \.element){ index,texture in
                                
                                ShapeCell(texture: texture,index: index, isPremiumUser: $isPremiumUser, lastSelectedTexture: $lastSelectedshape, selectedTexture: $selectedShape,  refSize: refSize, updateThumb: $updateThumb).environmentObject(UIStateManager.shared)

                            }
                    }
                    .frame(height: 75)
                    .padding(.horizontal, 5)
                    .onAppear(){
                        scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: lastSelectedshape)
                    }
                }
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            
        }
        .frame(height: 125)
        .onAppear(){
//            if selectedShape != lastSelectedshape {
//                selectedShape = lastSelectedshape
//            }
            loadTextures()
        }
    }
    
    private func loadTextures() {
        Task {
            textureArray = await fetchTextureArray()
            isLoading = false
        }
    }
        
    private func fetchTextureArray() async -> [String] {
        var textureArray: [String] = BGContainerDatasource.maskArray()!
        
//        for i in 0 ... 105{
//            textureArray.append("t\(i)")
//        }
        
        return textureArray
    }
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: String) {
        // Find the ID of the last selected button and scroll to
        // Add more conditions for other tab states...
        
        // Scroll to the identified button
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
        }
            
    }
    
//    func bindingForTextureValue(bg: Binding<AnyBGContent?>) -> Binding<ImageModel> {
//        return Binding<ImageModel>(
//            get: {
//                if let bgModel = bg.wrappedValue as? BGTexture {
//                    return bgModel.content
//                } else {
//                    return ImageModel(imageType: .COLOR, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)
//                }
//            },
//            set: { newValue in
//                if var bgModel = bg.wrappedValue as? BGTexture {
//                    bgModel.content = newValue
//                    bg.wrappedValue = bgModel
//                } else {
//                    bg.wrappedValue = BGTexture(content: newValue)
//                }
//            }
//        )
//    }
}

//#Preview {
//    var colorBinding = Binding<AnyBGContent?>(get: {
//        return BGTexture(content: ImageModel(imageType: .WALLPAPER, serverPath: "", localPath: "b0", cropRect: CGRect(origin: .zero, size: .zero), sourceType: .BUNDLE, tileMultiple: 1))
//    }, set: { _ in })
//
//    return TexturePanelView(tileSize: .constant(1), imageType: .constant(.TEXTURE), beginTileMultiple: .constant(1), endTileMultiple: .constant(1), textureBG: colorBinding)
//}

struct ShapeCell: View {
    @EnvironmentObject var dsStore : DataSourceStore
    @State var texture: String?
    @State var index: Int
    @EnvironmentObject var uiStateManager : UIStateManager
    @Binding var isPremiumUser: Bool
    @Binding var lastSelectedTexture: String
    @Binding var selectedTexture: String
    @State var image: UIImage?
    var refSize : CGSize
    @Binding var updateThumb: Bool
    var renderingMode : Image.TemplateRenderingMode {
  
//        if ThemeManager.shared.currentTheme == .darkMode {
//            return .template
//        }
    
        
        return .template
    }
    var foregroundColor  : Color {
  
        if ThemeManager.shared.currentTheme == .darkMode {
            return .white
        }
    
        
        return .black
    }
    
    
    var body: some View {
        ZStack{
            if let image = image{
                SwiftUI.Image(uiImage: image)
                    .resizable()
                    .renderingMode(renderingMode)
                    .frame(width: 65, height: 65)
                    .cornerRadius(5)
                    .foregroundStyle(foregroundColor)
                    .onTapGesture {
                        //** Neeshu
                        if index > 8 && !uiStateManager.isPremium{
                            isPremiumUser = true
                        }else{
                          //  lastSelectedTexture = texture!
                            selectedTexture = texture!
                            
//                            // get ratioSize
//                            let image:UIImage = UIImage(named: texture!)!
//                            //                                        ratioSize = image.size
//                            let aspectratio = image.mySize
//                            let siz =  getProportionalBGSize(currentRatio: refSize, oldSize: refSize )
//                            let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: siz)
//                            
//                            
//                            let imageModel = ImageModel(imageType: .TEXTURE, serverPath: texture!, localPath: texture!, cropRect: cropPoints, sourceType: .BUNDLE, tileMultiple: 1.0, cropType: .ratios,imageWidth: 300,imageHeight: 300)
//                            //                                resId = bg
//                            endBGCOntent = imageModel
//                            textureBinding = imageModel
                            updateThumb = true
                        }
                        //                                resId = texture
                        //                                imageType = .TEXTURE
                        //                                print("texture name :\(resId)")
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lastSelectedTexture == texture ? AppStyle.accentColor_SwiftUI :  .clear, lineWidth: 2)
                            .frame(width: 70, height: 70)
                    )
                
                // ** Neeshu
                if index > 8 && !uiStateManager.isPremium{
                    VStack{
                        HStack{
                            Spacer()
                            SwiftUI.Image("premiumIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .frame(width: 70)
                        Spacer()
                    }
                    .frame(height: 70)
                    
                }
            }else{
//                ShimmerEffectBox().frame(width: 65, height: 65).cornerRadius(10.0, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            
        }
        .task {
            do {
                
                image = try await dsStore.fetchShapeImage(name: texture!)
            } catch is CancellationError {
                             print("Task was canceled \(texture!)")
                         } catch {
                           //  print("Unexpected error: \(error)")
                         }
            
            
        }
        .sheet(isPresented: $isPremiumUser) {
//                                    PremiumPage(checkForRestore: false)
           // let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .normal)
            IAPView().environmentObject(UIStateManager.shared).interactiveDismissDisabled()
        }

    }
}
