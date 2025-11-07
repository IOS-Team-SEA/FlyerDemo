//
//  OverlayPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 04/04/24.
//

import SwiftUI
//import SwiftUIIntrospect
import IOS_CommonEditor

struct OverlayPanelView: View {
//    @State var overlayArray: [String] = BGContainerDatasource.overlayArray()!
    @State var overlayArray: [String] = ["o1","o2","o3","o4","o5","o6","o7","o8","o9","o10","o11","o12","o13","o14","o15","o16","o17","o18","o19","o20","o21","o22","o23","o24","o25","o26","o27","o28","o29","o30","o31"]
    @State var isLoading: Bool = true
    @Binding var opacity: Float
    @Binding var beginOverlayOpacity: Float
    @Binding var endOverlayOpacity: Float
//    @Binding var resId: String
    
    @Binding var imageType: ImageSourceType
    @Binding var overlayBG: AnyBGContent?
    @Binding var endBgContent:AnyBGContent?
    @State var selectedOverlay: String = ""
    @Binding var lastSelectedOverlay: AnyBGContent?
    var refSize : CGSize
    @Binding var updateThumb: Bool
    let rows = [
            GridItem(.fixed(50)), // Fixed height for each row
           
        ]
    var body: some View {
        
        let overlayBinding = bindingForOverlayValue(bg: $overlayBG)
        let lastSelectedOverlay =  bindingForOverlayValue(bg: $overlayBG)
        VStack{
            
            HStack(spacing: 0){
                
                VStack{
                    SwiftUI.Image("none")
                        .resizable()
                        .frame(width: 40, height: 40)
                    //                        .padding(.leading, 20)
                        .onTapGesture {
                            //                        selectedAnimation = "None"
                            //                        lastSelectedAnimation = selectedAnimation
                            let imageModel = ImageModel(imageType: .OVERLAY, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)
                            overlayBinding.wrappedValue = imageModel
                            lastSelectedOverlay.wrappedValue.localPath = ""
//                            endOverlayBinding.wrappedValue = imageModel
                            print("none tapped")
                            updateThumb = true
                        }
                        
                }
                .frame(width: 65, height: 65)
                .background(lastSelectedOverlay.wrappedValue.localPath == "" ? AppStyle.accentColor_SwiftUI : .gray)
                .cornerRadius(10)
                .padding(.leading, 10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(lastSelectedOverlay.wrappedValue.localPath == "" ? AppStyle.accentColor_SwiftUI :  Color.systemFill, lineWidth: 2)
//                        .frame(width: 70, height: 70)
//                        .padding(.leading, 10)
//                )
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    ScrollViewReader{ proxy in
//                        HStack{
                        LazyHGrid(rows: rows ) {
//                            if isLoading {
//                                ForEach(1..<10){ _ in
//                                    ShimmerEffectBox().frame(width: 70, height: 70).cornerRadius(10.0, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//                                }
//                            } else {
                                ForEach(overlayArray, id: \.self){ overlay in
                                    SwiftUI.Image(overlay)
                                        .resizable()
                                        .frame(width: 65, height: 65)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            selectedOverlay = overlay
                                            lastSelectedOverlay.wrappedValue.localPath = overlay
                                            // get ratioSize
                                            let image:UIImage = UIImage(named: overlay)!
                                            //                                        ratioSize = image.size
                                            let aspectratio = image.mySize
                                            let siz =  getProportionalBGSize(currentRatio: refSize, oldSize: refSize )
                                            let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: siz)
                                            
                                            //                                        lastSelectedOverlay.wrappedValue.localPath = overlay
                                            let imageModel = ImageModel(imageType: .OVERLAY, serverPath: overlay, localPath: overlay, cropRect: cropPoints, sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)
                                            overlayBinding.wrappedValue = imageModel
                                            updateThumb = true
                                          //  endOverlayBinding.wrappedValue = imageModel
                                            
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lastSelectedOverlay.wrappedValue.localPath == overlay ? AppStyle.accentColor_SwiftUI :  Color.systemFill, lineWidth: 2)
                                                .frame(width: 70, height: 70)
                                        )
                                }
                                
//                            }
                        }
                        .frame(height: 75)
                        .padding(.horizontal, 5)
                        .onAppear(){
                            scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: lastSelectedOverlay.wrappedValue.localPath )
                        }
                    }
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                
            }
            .frame(height: 75)
            
            if lastSelectedOverlay.wrappedValue.localPath != ""{
                HStack{
                    Text("Opacity_")
                        .font(.subheadline)
                    Slider(
                        value: $opacity,
                        in: 0...1,
                        onEditingChanged: { value in
                            
                            if value{
                                
                                beginOverlayOpacity = opacity
                            }else{
                                
                                endOverlayOpacity = opacity
                                updateThumb = true
                            }
                        }
                    )
//                    .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                    }
                    .tint(AppStyle.accentColor_SwiftUI)
                    
                    Text("\(String(format: "%.0f", opacity*100))%")
                        .font(.subheadline)
                }.frame(width: 350, height: 50)
            }else{
                VStack{
                    
                }.frame(height: 50)
            }
            
        }
        .frame(height: 125)
        .onAppear(){
            selectedOverlay = lastSelectedOverlay.wrappedValue.localPath 
//            loadOverlays()
        }
    }
    
    private func loadOverlays() {
        Task {
            overlayArray = await fetchOverlayArray()
            isLoading = false
        }
    }
        
    private func fetchOverlayArray() async -> [String] {
        var overlayArray: [String] = [String]()
        
        for i in 1 ... 31{
            overlayArray.append("o\(i)")
        }
        
        return overlayArray
    }
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: String) {
        // Find the ID of the last selected button and scroll to
        // Add more conditions for other tab states...
        
        // Scroll to the identified button
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
        }
            
    }
    
    func bindingForOverlayValue(bg: Binding<AnyBGContent?>) -> Binding<ImageModel> {
        return Binding<ImageModel>(
            get: {
                if let bgModel = bg.wrappedValue as? BGOverlay {
                    return bgModel.content
                } else {
                    return ImageModel(imageType: .COLOR, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)
                }
            },
            set: { newValue in
                if var bgModel = bg.wrappedValue as? BGOverlay {
                    bgModel.content = newValue
                    bg.wrappedValue = bgModel
                } else {
                    bg.wrappedValue = BGOverlay(content: newValue)
                }
            }
        )
    }
}

//#Preview {
//    OverlayPanelView(opacity: .constant(1))
//}

struct BGOverlayCell:View {
    
    @EnvironmentObject var dsStore : DataSourceStore
    @State var overlay: String?
    @Binding var selectedOverlay: String
    @Binding var lastSelectedOverlay: ImageModel
    @Binding var overlayBinding: ImageModel
    @State var image: UIImage?
    var refSize : CGSize
    
    var body: some View {
        VStack{
            if let image = image{
                SwiftUI.Image(uiImage: image)
                    .resizable()
                    .frame(width: 65, height: 65)
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedOverlay = overlay!
                        lastSelectedOverlay.localPath = overlay!
                        // get ratioSize
                        let image:UIImage = UIImage(named: overlay!)!
                        //                                        ratioSize = image.size
                        let aspectratio = image.mySize
                        let siz =  getProportionalBGSize(currentRatio: refSize, oldSize: refSize )
                        let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: siz)
                        
                        //                                        lastSelectedOverlay.wrappedValue.localPath = overlay
                        let imageModel = ImageModel(imageType: .OVERLAY, serverPath: overlay!, localPath: overlay!, cropRect: cropPoints, sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)
                        overlayBinding = imageModel
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lastSelectedOverlay.localPath == overlay ? AppStyle.accentColor_SwiftUI :  Color.systemFill, lineWidth: 2)
                            .frame(width: 70, height: 70)
                    )
            }else{
//                ShimmerEffectBox().frame(width: 65, height: 65).cornerRadius(10.0, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
        }
        .task {
            do {
                
                image = try await dsStore.fetchOverlayImage(name: overlay!)
            } catch is CancellationError {
                             print("Task was canceled \(overlay!)")
                         } catch {
                           //  print("Unexpected error: \(error)")
                         }
            
            
        }
    }
}
