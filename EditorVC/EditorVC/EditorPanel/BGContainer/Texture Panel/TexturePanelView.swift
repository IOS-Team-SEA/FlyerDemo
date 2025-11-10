//
//  TexturePanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 04/04/24.
//

import SwiftUI
import IOS_CommonEditor
//import SwiftUIIntrospect

struct TexturePanelView: View {
   // @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
//    @State var textureArray: [String] = BGContainerDatasource.textureArray()!
    @State var textureArray: [String] = ["t20", "t30", "t18", "t29","t31", "t32", "t33", "t34", "t35", "t36", "t37", "t38", "t39","t40", "t41", "t42", "t43", "t44", "t10", "t1", "t6", "t2","t3", "t5", "t4", "t9", "t7", "t8", "t11","t12", "t13", "t14", "t15", "t16", "t17", "t27", "t28", "t22", "t23", "t24","t21", "t25", "t26", "t19", "t45", "t46", "t47", "t48","t49", "t50", "t51", "t52", "t53", "t54", "t55", "t56", "t57","t58", "t59", "t60"]
    @State var isLoading: Bool = true
    @Binding var tileSize: Float
//    @Binding var resId: String
    @Binding var imageType: ImageSourceType
    @Binding var beginTileMultiple: Float
    @Binding var endTileMultiple: Float
    @Binding var textureBG: AnyBGContent?
    @Binding var endBgContent: AnyBGContent?
    @State var selectedTexture: String = ""
    @Binding var lastSelectedBGContent: AnyBGContent?
    var refSize : CGSize
    @State var isPremiumUser: Bool = false
    @EnvironmentObject var uiStateManager : UIStateManager
    @Binding var updateThumb: Bool
    let rows = [
            GridItem(.fixed(50)), // Fixed height for each row
           
        ]
    
    var body: some View {
        let textureBinding = bindingForTextureValue(bg: $textureBG)
        let endBGCOntent = bindingForTextureValue(bg: $endBgContent)
        let lastSelectedTexture = lastSelectedBGContent == nil ? bindingForTextureValue(bg: $textureBG)  :  bindingForTextureValue(bg: $lastSelectedBGContent)
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
                                
                                BGTextureCell(texture: texture,index: index, isPremiumUser: $isPremiumUser, lastSelectedTexture: lastSelectedTexture, selectedTexture: $selectedTexture, endBGCOntent: endBGCOntent, textureBinding: textureBinding, refSize: refSize, updateThumb: $updateThumb).environmentObject(UIStateManager.shared)
//                                ZStack{
//                                    SwiftUI.Image(texture)
//                                        .resizable()
//                                        .frame(width: 65, height: 65)
//                                        .cornerRadius(5)
//                                        .onTapGesture {
//                                            //** Neeshu 
//                                            if index > 8 && !uiStateManager.isPremium{
//                                                isPremiumUser = true
//                                            }else{
//                                                lastSelectedTexture.wrappedValue.localPath = texture
//                                                selectedTexture = texture
//                                                
//                                                // get ratioSize
//                                                let image:UIImage = UIImage(named: texture)!
//                                                //                                        ratioSize = image.size
//                                                let aspectratio = image.mySize
//                                                let siz =  getProportionalBGSize(currentRatio: refSize, oldSize: refSize )
//                                                let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: siz)
//                                                
//                                                
//                                                let imageModel = ImageModel(imageType: .TEXTURE, serverPath: texture, localPath: texture, cropRect: cropPoints, sourceType: .BUNDLE, tileMultiple: 1.0, cropType: .ratios,imageWidth: 300,imageHeight: 300)
//                                                //                                resId = bg
//                                                endBGCOntent.wrappedValue = imageModel
//                                                textureBinding.wrappedValue = imageModel
//                                            }
//                                            //                                resId = texture
//                                            //                                imageType = .TEXTURE
//                                            //                                print("texture name :\(resId)")
//                                        }
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 5)
//                                                .stroke(lastSelectedTexture.wrappedValue.localPath == texture ? AppStyle.accentColor_SwiftUI :  .clear, lineWidth: 2)
//                                                .frame(width: 70, height: 70)
//                                        )
//                                    
//                                   // ** Neeshu
//                                    if index > 8 && !uiStateManager.isPremium{
//                                        VStack{
//                                            HStack{
//                                                Spacer()
//                                                SwiftUI.Image("premiumIcon")
//                                                    .resizable()
//                                                    .frame(width: 20, height: 20)
//                                            }
//                                            .frame(width: 70)
//                                            Spacer()
//                                        }
//                                        .frame(height: 70)
//                                        
//                                    }
//                                    
//                                }
//                                .sheet(isPresented: $isPremiumUser) {
////                                    PremiumPage(checkForRestore: false)
//                                    let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .normal)
//                                    IAPView(iapViewModel: iapViewModel)
//                                }
                            }
//                        }
                    }
                    .frame(height: 75)
                    .padding(.horizontal, 5)
                    .onAppear(){
                        scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: lastSelectedTexture.wrappedValue.localPath)
                    }
                }
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            if lastSelectedTexture.wrappedValue.localPath != "" {
                HStack{
                    Text("Size_")
                        .font(.subheadline)
                    Slider(
                        value: $tileSize,
                        in: 1...10,
                        onEditingChanged: { value in
                            
                            if value{
                                
                                beginTileMultiple = tileSize
                            }else{
                                
                                endTileMultiple = tileSize
                            }
                        }
                    )
//                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                    }
                    .tint(AppStyle.accentColor_SwiftUI)
                    Text("\(String(format: "%.0f", tileSize))")
                        .font(.subheadline)
                }.frame(width: 350, height: 50)
            }else{
                VStack{
                    
                }.frame(height: 50)
            }
            
        }
        .frame(height: 125)
        .onAppear(){
            selectedTexture = lastSelectedTexture.wrappedValue.localPath
//            loadTextures()
        }
    }
    
    private func loadTextures() {
        Task {
            textureArray = await fetchTextureArray()
            isLoading = false
        }
    }
        
    private func fetchTextureArray() async -> [String] {
        var textureArray: [String] = ["t60", "t61", "t62",
                                      "t63", "t64", "t65", "t66", "t67", "t68", "t69", "t70", "t71",
                                      "t72", "t73", "t74", "t75", "t76", "t77", "t78", "t79", "t80",
                                      "t81", "t82", "t83", "t84", "t85", "t86", "t87", "t88", "t89", "t90",
                                      "t91", "t92", "t93", "t94", "t95", "t96", "t97", "t98", "t99",
                                      "t100", "t101", "t102", "t103", "t104", "t105", "t9", "t10", "t11",
                                      "t12", "t13", "t14", "t0", "t1", "t2",
                                      "t3", "t4", "t5", "t6", "t7", "t8", "t15", "t16", "t17", "t18", "t19", "t20",
                                      "t21", "t22", "t23", "t24", "t25", "t26", "t27", "t28", "t29", "t30",
                                      "t31", "t32", "t33", "t34", "t36", "t37", "t38", "t39",
                                      "t40", "t41", "t42", "t43", "t44", "t45", "t46", "t47", "t48",
                                      "t49", "t50", "t51", "t52", "t53", "t54", "t55", "t56", "t57",
                                      "t58", "t59"]
        
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
    
    func bindingForTextureValue(bg: Binding<AnyBGContent?>) -> Binding<ImageModel> {
        return Binding<ImageModel>(
            get: {
                if let bgModel = bg.wrappedValue as? BGTexture {
                    return bgModel.content
                } else {
                    return ImageModel(imageType: .COLOR, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)
                }
            },
            set: { newValue in
                if var bgModel = bg.wrappedValue as? BGTexture {
                    bgModel.content = newValue
                    bg.wrappedValue = bgModel
                } else {
                    bg.wrappedValue = BGTexture(content: newValue)
                }
            }
        )
    }
}

//#Preview {
//    var colorBinding = Binding<AnyBGContent?>(get: {
//        return BGTexture(content: ImageModel(imageType: .WALLPAPER, serverPath: "", localPath: "b0", cropRect: CGRect(origin: .zero, size: .zero), sourceType: .BUNDLE, tileMultiple: 1))
//    }, set: { _ in })
//    
//    return TexturePanelView(tileSize: .constant(1), imageType: .constant(.TEXTURE), beginTileMultiple: .constant(1), endTileMultiple: .constant(1), textureBG: colorBinding)
//}

struct BGTextureCell: View {
    @EnvironmentObject var dsStore : DataSourceStore
    @State var texture: String?
    @State var index: Int
    @EnvironmentObject var uiStateManager : UIStateManager
    @Binding var isPremiumUser: Bool
    @Binding var lastSelectedTexture: ImageModel
    @Binding var selectedTexture: String
    @Binding var endBGCOntent: ImageModel
    @Binding var textureBinding: ImageModel
    @State var image: UIImage?
    var refSize : CGSize
    @Binding var updateThumb: Bool
    
    var body: some View {
        ZStack{
            if let image = image{
                SwiftUI.Image(uiImage: image)
                    .resizable()
                    .frame(width: 65, height: 65)
                    .cornerRadius(5)
                    .onTapGesture {
                        //** Neeshu
                        if index > 8 && !uiStateManager.isPremium{
                            isPremiumUser = true
                        }else{
                            lastSelectedTexture.localPath = texture!
                            selectedTexture = texture!
                            
                            // get ratioSize
                            let image:UIImage = UIImage(named: texture!)!
                            //                                        ratioSize = image.size
                            let aspectratio = image.mySize
                            let siz =  getProportionalBGSize(currentRatio: refSize, oldSize: refSize )
                            let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: siz)
                            
                            
                            let imageModel = ImageModel(imageType: .TEXTURE, serverPath: texture!, localPath: texture!, cropRect: cropPoints, sourceType: .BUNDLE, tileMultiple: 1.0, cropType: .ratios,imageWidth: 300,imageHeight: 300)
                            //                                resId = bg
                            endBGCOntent = imageModel
                            textureBinding = imageModel
                            updateThumb = true
                        }
                        //                                resId = texture
                        //                                imageType = .TEXTURE
                        //                                print("texture name :\(resId)")
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lastSelectedTexture.localPath == texture ? AppStyle.accentColor_SwiftUI :  .clear, lineWidth: 2)
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
                ShimmerEffectBox().frame(width: 65, height: 65).cornerRadius(10.0, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            
        }
        .task {
            do {
                
                image = try await dsStore.fetchTextureImage(name: texture!)
            } catch is CancellationError {
                             print("Task was canceled \(texture!)")
                         } catch {
                           //  print("Unexpected error: \(error)")
                         }
            
            
        }
        .sheet(isPresented: $isPremiumUser) {
//                                    PremiumPage(checkForRestore: false)
           // let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .normal)
//            IAPView().environmentObject(UIStateManager.shared).interactiveDismissDisabled()
        }

    }
}



