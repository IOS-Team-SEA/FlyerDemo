//
//  BGControlPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 04/04/24.
//

import SwiftUI
import IOS_CommonEditor

struct BGControlPanelView: View {
  //  @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
//    @State var bgArray: [String] = BGContainerDatasource.bgArray()!
//    @Binding var resId: String
    @State var bgArray: [String] = ["b32", "b41", "b42", "b33","b34", "b35", "b36", "b37", "b38", "b39", "b40", "b43","b49", "b50", "b10", "b5", "b6", "b1", "b4", "b2","b3", "b9", "b7", "b8", "b11","b12", "b13", "b14", "b15", "b16", "b17", "b18", "b19", "b20","b21", "b22", "b23", "b24", "b44", "b45", "b46", "b47", "b48", "b25","b26", "b27", "b28", "b29", "b30", "b31", "b51", "b52", "b53", "b54", "b55", "b56", "b57","b58", "b59", "b60"]
    @State var isLoading: Bool = true
    @Binding var imageType: ImageSourceType
    @Binding var wallpaper: AnyBGContent?
    @State var selectedWallpaper: String = ""
    @Binding var lastSelectedBGContent: AnyBGContent?
    @Binding var endBGContent: AnyBGContent?
    var ratioSize : CGSize
    @State var isPremiumUser: Bool = false
    @EnvironmentObject var uiStateManager : UIStateManager
    @Binding var updateThumb : Bool
    
    let rows = [
            GridItem(.fixed(50)), // Fixed height for each row
           
        ]
    var body: some View {
        let wallpaperBinding = bindingForBGValue(bg: $wallpaper)
        let endWallpaperBinding = bindingForBGValue(bg: $endBGContent)
        let lastSelectedWallpaper = lastSelectedBGContent == nil ? bindingForBGValue(bg: $wallpaper) : bindingForBGValue(bg: $lastSelectedBGContent)
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                ScrollViewReader{ proxy in
                    LazyHGrid(rows: rows ) {
                     
                   // HStack{
//                        if isLoading {
//                            ForEach(1..<10){ _ in
//                                ShimmerEffectBox().frame(width: 90, height: 90).cornerRadius(10.0, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//                            }
//                        } else {
                            ForEach(Array(bgArray.enumerated()), id: \.element){ index,bg in
                                
                                BGWallpaperCell(bgWallpaper: bg, index: index, isPremiumUser: $isPremiumUser, lastSelectedWallpaper: lastSelectedWallpaper, selectedWallpaper: $selectedWallpaper, endWallpaperBinding: endWallpaperBinding, wallpaperBinding: wallpaperBinding, ratioSize: ratioSize, updateThumb: $updateThumb)
                                    .environmentObject(UIStateManager.shared)
                                
//                                ZStack{
//                                    
//                                    
//                                    
//                                    SwiftUI.Image(bg)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 90, height: 90)
//                                        .cornerRadius(10)
//                                        .onTapGesture {
//                                            // ** Neeshu
//                                            if index > 8 && !uiStateManager.isPremium{
//                                                isPremiumUser = true
//                                            }else{
//                                                
//                                                lastSelectedWallpaper.wrappedValue.localPath = bg
//                                                selectedWallpaper = bg
//                                                
////                                                // get ratioSize
//                                                let image:UIImage = UIImage(named: bg)!
//        //                                        ratioSize = image.size
//                                                let aspectratio = image.mySize
//                                               let siz =  getProportionalBGSize(currentRatio: ratioSize, oldSize: ratioSize )
//                                                let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: siz)
//                                                
//                                                let imageModel = ImageModel(imageType: .WALLPAPER, serverPath: " ", localPath: bg, cropRect: CGRect(x: cropPoints.minX, y: cropPoints.minY, width: cropPoints.width, height: cropPoints.height), sourceType: .BUNDLE, tileMultiple: 1.0, cropType: .ratios,imageWidth: aspectratio.width,imageHeight: aspectratio.height)
//                                                //                                resId = bg
//                                                endWallpaperBinding.wrappedValue = imageModel
//                                                wallpaperBinding.wrappedValue = imageModel
//                                                //                                imageType = .WALLPAPER
//                                            }
//                                        }
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .stroke(lastSelectedWallpaper.wrappedValue.localPath == bg ? AppStyle.accentColor_SwiftUI :  .clear, lineWidth: 2)
//                                                .frame(width: 95, height: 95)
//                                        )
//                                    // ** Neeshu
//                                    if index > 8 && !uiStateManager.isPremium{
//                                        VStack{
//                                            HStack{
//                                                Spacer()
//                                                SwiftUI.Image("premiumIcon")
//                                                    .resizable()
//                                                    .frame(width: 30, height: 30)
//                                            }
//                                            .frame(width: 95)
//                                            Spacer()
//                                        }
//                                        .frame(height: 95)
//                                        
//                                    }
//                                }
//                                .sheet(isPresented: $isPremiumUser) {
////                                    PremiumPage(checkForRestore: false)
//                                    let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .normal)
//                                    IAPView(iapViewModel: iapViewModel)
//                                }
                            }
//                        }
                    }
                    .frame(height: 100)
                    .padding(.horizontal, 5)
                    .onAppear(){
                        scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: lastSelectedWallpaper.wrappedValue.localPath)
                    }
                }
//                .padding()
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        }
        .frame(height: 125)
        .onAppear(){
            selectedWallpaper = lastSelectedWallpaper.wrappedValue.localPath
//            loadBackgrounds()
        }
    }
    
    
    private func loadBackgrounds() {
        Task {
//            isLoading = true
            bgArray = await fetchBGArray()
//            isLoading = false
        }
    }
        
    private func fetchBGArray() async -> [String] {
        let allBackgrounds: [String] = ["b67", "b68", "b69", "b70", "b71",
                                 "b72", "b73", "b74", "b75", "b76", "b77", "b78", "b79", "b80",
                                 "b81", "b82", "b83", "b84", "b85", "b86", "b87", "b88", "b89",
                                 "b90", "b91", "b92", "b93", "b94", "b95", "b96", "b97", "b98", "b99", "b100", "b11",
                                 "b12", "b13", "b14", "b15", "b16", "b17", "b0", "b1", "b2",
                                 "b3", "b4", "b5", "b6", "b7", "b8", "b9", "b10", "b18", "b19", "b20",
                                 "b21", "b22", "b23", "b24", "b25", "b26", "b27", "b28", "b29", "b30",
                                 "b31", "b32", "b33", "b34", "b35", "b36", "b37", "b38", "b39",
                                 "b40", "b41", "b42", "b43", "b44", "b45", "b46", "b47", "b48",
                                 "b49", "b50", "b51", "b52", "b53", "b54", "b55", "b56", "b57",
                                 "b58", "b59", "b60", "b61", "b62", "b63", "b64", "b65", "b66"]
        
//        for i in 0...100 {
//            bgArray.append("b\(i)")
//        }
        
        // Jay What Is This Man ?
        for bg in allBackgrounds {
            // Simulate network delay for fetching a background
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds delay
            
            // Append the fetched background to bgArray
            await MainActor.run {
                bgArray.append(bg)
            }
        }
        
        return bgArray
    }
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: String) {
        // Find the ID of the last selected button and scroll to
        // Add more conditions for other tab states...
        
        // Scroll to the identified button
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
        }
            
    }
    
    func bindingForBGValue(bg: Binding<AnyBGContent?>) -> Binding<ImageModel> {
        return Binding<ImageModel>(
            get: {
                if let bgModel = bg.wrappedValue as? BGWallpaper {
                    return bgModel.content
                } else {
                    return ImageModel(imageType: .COLOR, serverPath: "", localPath: "", cropRect: CGRect(x: 0, y: 0, width: 1, height: 1), sourceType: .BUNDLE, tileMultiple: 1, cropType: .ratios,imageWidth: 300,imageHeight: 300)
                }
            },
            set: { newValue in
                if var bgModel = bg.wrappedValue as? BGWallpaper {
                    bgModel.content = newValue
                    bg.wrappedValue = bgModel
                } else {
                    bg.wrappedValue = BGWallpaper(content: newValue)
                }
            }
        )
    }
}

//#Preview {
//    var colorBinding = Binding<AnyBGContent?>(get: {
//        return BGWallpaper(content: ImageModel(imageType: .WALLPAPER, serverPath: "", localPath: "b0", cropRect: CGRect(origin: .zero, size: .zero), sourceType: .BUNDLE, tileMultiple: 1))
//    }, set: { _ in })
//    
//    return BGControlPanelView(imageType: .constant(.WALLPAPER), wallpaper: colorBinding, lastSelectedBGContent: colorBinding)
//}


struct BGWallpaperCell: View {
    @EnvironmentObject var dsStore : DataSourceStore

    @State var bgWallpaper: String?
    @State var index: Int
    @EnvironmentObject var uiStateManager : UIStateManager
    @Binding var isPremiumUser: Bool
    @Binding var lastSelectedWallpaper: ImageModel
    @Binding var selectedWallpaper: String
    @Binding var endWallpaperBinding: ImageModel
    @Binding var wallpaperBinding: ImageModel
    @State var image: UIImage?
    var ratioSize : CGSize
    @Binding var updateThumb : Bool
    
    var body: some View {
        ZStack{
            if let image = image{
                SwiftUI.Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .cornerRadius(10)
                    .onTapGesture {
                        // ** Neeshu
                        if index > 8 && !uiStateManager.isPremium{
                            isPremiumUser = true
                        }else{
                           
                            lastSelectedWallpaper.localPath = bgWallpaper!
                            selectedWallpaper = bgWallpaper!
                            
                            //                                                // get ratioSize
                            let image:UIImage = UIImage(named: bgWallpaper!)!
                            //                                        ratioSize = image.size
                            let aspectratio = image.mySize
                            let siz =  getProportionalBGSize(currentRatio: ratioSize, oldSize: ratioSize )
                            let cropPoints = calculateCropPoint(imageSize: aspectratio, cropSize: siz)
                            
                            let imageModel = ImageModel(imageType: .WALLPAPER, serverPath: " ", localPath: bgWallpaper!, cropRect: CGRect(x: cropPoints.minX, y: cropPoints.minY, width: cropPoints.width, height: cropPoints.height), sourceType: .BUNDLE, tileMultiple: 1.0, cropType: .ratios,imageWidth: aspectratio.width,imageHeight: aspectratio.height)
                            //                                resId = bg
                            endWallpaperBinding = imageModel
                            wallpaperBinding = imageModel
                            updateThumb = true
                            //                                imageType = .WALLPAPER
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lastSelectedWallpaper.localPath == bgWallpaper ? AppStyle.accentColor_SwiftUI :  .clear, lineWidth: 2)
                            .frame(width: 95, height: 95)
                    )
                // ** Neeshu
                if index > 8 && !uiStateManager.isPremium{
                    VStack{
                        HStack{
                            Spacer()
                            SwiftUI.Image("premiumIcon")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: 95)
                        Spacer()
                    }
                    .frame(height: 95)
                    
                }
            }else{
//                ShimmerEffectBox().frame(width: 90, height: 90).cornerRadius(10.0, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
        }
        
        .task {
//            image = downsample(imageAt: bgWallpaper!, to: CGSize(width: 90, height: 90))
         //   image = myRepo.fetchWallPaperImage(name: bgWallpaper!)
            
           // print("TT__\(Task.isCancelled)")
           // myRepo.cancelTask(name: bgWallpaper!)
            do {
                
                image = try await dsStore.fetchWallPaperImage(name: bgWallpaper!)
            } catch is CancellationError {
                             print("Task was canceled \(bgWallpaper!)")
                         } catch {
                           //  print("Unexpected error: \(error)")
                         }
            
            
        }
        .sheet(isPresented: $isPremiumUser) {
//                                    PremiumPage(checkForRestore: false)
//            let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .normal)
//            IAPView(iapViewModel: iapViewModel).environmentObject(UIStateManager.shared)
//            IAPView().environmentObject(UIStateManager.shared).interactiveDismissDisabled()

        }

    }
    
   
}

@MainActor
class DataSourceStore: ObservableObject {
   
    deinit {
        print("\(self) deinit")
    }

    private var wallpapers = [String: UIImage?]()
    private var texture = [String: UIImage?]()
    private var shapes = [String: UIImage?]()

    private var overlays = [String: UIImage?]()
    private var fonts = [String: String?]()

    func fetchWallPaperImage(name: String, refSize: CGSize = CGSize(width: 90, height: 90)) async throws -> UIImage? {
        return try await withTaskCancellationHandler {
            var imageNotFound = AppStyle.defaultImage

            // Check for cancellation
            try Task.checkCancellation()

            // Perform task in the background
            let task = Task.detached(priority: .background) { [weak self] in
                guard let self = self else {
                    return imageNotFound // If `self` is nil, return a default image
                }

                // Access cached wallpapers
                if let cachedImage = await self.wallpapers[name] {
                    return cachedImage ?? imageNotFound // Return cached wallpaper
                } else {
                    // Downsample and cache the image
                    guard let bg = downsample(imageAt: name, to: refSize) else {
                        print("Error downsampling \(name)")
                        return imageNotFound
                    }

                    // Check for cancellation
                    try Task.checkCancellation()

                    // Cache the wallpaper
                    await self.cacheWallpapaer(image: bg, forName: name)

                    return bg
                }
            }

            return try await task.value
        } onCancel: {
            print("Task canceled for \(name)")
        }
    }
    
    func fetchShapeImage(name: String, refSize: CGSize = CGSize(width: 65, height: 65)) async throws -> UIImage? {
        return try await withTaskCancellationHandler {
            var imageNotFound = AppStyle.defaultImage
            
            // Check for cancellation
            try Task.checkCancellation()
            
            // Perform task in the background
            let task = Task.detached(priority: .background) { [weak self] in
                guard let self = self else {
                    return imageNotFound // If `self` is nil, return a default image
                }
                
                // Access cached wallpapers
                if let cachedImage = await self.shapes[name] {
                    return cachedImage ?? imageNotFound // Return cached wallpaper
                } else {
                    // Downsample and cache the image
                    guard let bg = downsample(imageAt: name, to: refSize) else {
                        print("Error downsampling \(name)")
                        return imageNotFound
                    }
                    
                    // Check for cancellation
                    try Task.checkCancellation()
                    
                    // Cache the wallpaper
                    await self.cacheTexture(image: bg, forName: name)
                    
                    return bg
                }
            }
            
            return try await task.value
        } onCancel: {
            print("Task canceled for \(name)")
        }
    }

    func fetchTextureImage(name: String, refSize: CGSize = CGSize(width: 65, height: 65)) async throws -> UIImage? {
        return try await withTaskCancellationHandler {
            var imageNotFound = AppStyle.defaultImage

            // Check for cancellation
            try Task.checkCancellation()

            // Perform task in the background
            let task = Task.detached(priority: .background) { [weak self] in
                guard let self = self else {
                    return imageNotFound // If `self` is nil, return a default image
                }

                // Access cached wallpapers
                if let cachedImage = await self.texture[name] {
                    return cachedImage ?? imageNotFound // Return cached wallpaper
                } else {
                    // Downsample and cache the image
                    guard let bg = downsample(imageAt: name, to: refSize) else {
                        print("Error downsampling \(name)")
                        return imageNotFound
                    }

                    // Check for cancellation
                    try Task.checkCancellation()

                    // Cache the wallpaper
                    await self.cacheTexture(image: bg, forName: name)

                    return bg
                }
            }

            return try await task.value
        } onCancel: {
            print("Task canceled for \(name)")
        }
        
    }
    
    func fetchOverlayImage(name: String, refSize: CGSize = CGSize(width: 65, height: 65)) async throws -> UIImage? {
        return try await withTaskCancellationHandler {
            var imageNotFound = AppStyle.defaultImage

            // Check for cancellation
            try Task.checkCancellation()

            // Perform task in the background
            let task = Task.detached(priority: .background) { [weak self] in
                guard let self = self else {
                    return imageNotFound // If `self` is nil, return a default image
                }

                // Access cached wallpapers
                if let cachedImage = await self.overlays[name] {
                    return cachedImage ?? imageNotFound // Return cached wallpaper
                } else {
                    // Downsample and cache the image
                    guard let bg = downsample(imageAt: name, to: refSize) else {
//                        printLog("Error downsampling \(name)")
                        return imageNotFound
                    }

                    // Check for cancellation
                    try Task.checkCancellation()

                    // Cache the wallpaper
                    await self.cacheOverlay(image: bg, forName: name)

                    return bg
                }
            }

            return try await task.value
        } onCancel: {
//            printLog("Task canceled for \(name)")
        }
    }
    
    func fetchFonts(name: String) async throws -> String?{
        return try await withTaskCancellationHandler {
            var fontNotFound = "Default"
            
            // Check for cancellation
            try Task.checkCancellation()
            
            // Perform task in the background
            let task = Task.detached(priority: .background) { [weak self] in
                guard let self = self else {
                    return fontNotFound // If `self` is nil, return a default image
                }
                
                // Access cached wallpapers
                if let cachedFont = await self.fonts[name] {
                    
                    
                    return cachedFont ?? fontNotFound // Return cached wallpaper
                } else {
                    // Check for cancellation
                    try Task.checkCancellation()
                    
                    await self.cachefonts(font: name, forName: name)
                    
                    return name
                    
                }
            }
            return try await task.value
        }onCancel: {
//            printLog("Task canceled for \(name)")
        }
    }

    private func cacheWallpapaer(image: UIImage, forName: String) {
        wallpapers[forName] = image
    }
    
    private func cacheTexture(image: UIImage, forName: String) {
        texture[forName] = image
    }
    
    private func cacheOverlay(image: UIImage, forName: String) {
        overlays[forName] = image
    }
    
    private func cachefonts(font: String, forName: String) {
        fonts[forName] = font
    }
    
   
    func cleanUp() {
        wallpapers.removeAll()
        texture.removeAll()
        overlays.removeAll()
        fonts.removeAll()
//        printLog("Cleaned up wallpapers, texture, overlays and fonts.")
    }
}
