//
//  ExportPage.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 30/04/24.
//

import SwiftUI
import AVKit
import IOS_CommonUtilSPM
import IOS_CommonEditor
import UIKit
import StoreKit


class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
struct ShareOutput : Identifiable {
    var id = UUID()
    var image: UIImage?
    var video: URL?
    var name : String = ""
}

struct ExportPage: View {
    @StateObject private var ratingViewModel = RatingFlowVM()
    private var variant: RatingFlowVariant {
        ratingViewModel.committedRating == 0 ? .idle : .from(ratingViewModel.committedRating)
        }
    
    let ratingManager = RatingManager(rmk: UserDefaultKeyManager())
    let router: AppRouter = Injection.shared.inject(id: "AppRouter", type: AppRouter.self)!

//    @Injected var analyticsLogger : AnalyticsLogger
    var viewModel = ShareDirectViewModel()
    let shareDirectVM = ShareDirectVM()
    @ObservedObject var dropViewModel = DropViewModel()
    
    @State var shareImage : ShareOutput?
    
    var videoName: String = "Test Video"
    @State private var isPlaying = false
    @State private var player: AVPlayer?
    @State private var thumbnailImage: UIImage? = nil
    
    @State var isMorePresented: Bool = false
    @State var isMailsPresented: Bool = false
    
    @State var exportError: ExportError = .success("Success")
    @State var isBlastFinished : Bool = false
    var videoURL: URL? = nil // = Bundle.main.url(forResource: "Test", withExtension: "mp4")
    
    let appName: String = ""
    let supportEmail: String = ""
    let exportType: ExportType
    let onCloseTapped: (() -> Void)?
    let onHomeTapped: (()->Void)?
    @State var didSave : Bool = false
    var isJpeg : Bool = false
    
    init(url: URL, isJpeg : Bool = false , exportType: ExportType, onCloseTapped: (() -> Void)?, onHomeTapped: (() -> Void)?){
        self.isJpeg = isJpeg
        self.videoURL = url
        self.exportType = exportType
        self.onCloseTapped = onCloseTapped
        self.onHomeTapped = onHomeTapped
        let fileNameWithExtension = url.lastPathComponent
        self.videoName = fileNameWithExtension.replacingOccurrences(of: ".mp4", with: "")
    }
    
    init(image:UIImage,isJpeg : Bool = false , imageName:String,  exportType: ExportType = .Photo , onCloseTapped: (() -> Void)?, onHomeTapped: (() -> Void)?){
        self.isJpeg = isJpeg
        self.exportType = exportType
        self.onCloseTapped = onCloseTapped
        self.onHomeTapped = onHomeTapped
        _thumbnailImage = State(initialValue: image)
//        let fileNameWithExtension = url.lastPathComponent
        self.videoName = imageName
        
        
    }
    
    var body: some View {
        
        ZStack(alignment: .topTrailing){
        
//        NavigationView{
        VStack(spacing:12){
                
                
              //  AppTextStyle.cardTitle("Your_CutOut_Is_SAVED".translate())
            Spacer().frame(height:44)
                       Text("Your_CutOut_Is_SAVED".translate())
                           .font(.title2.bold())
                           .lineLimit(nil)
                           .multilineTextAlignment(.center)
           //                .font(.subheadline)
                           .foregroundColor(.primary)
                           .fixedSize(horizontal: false, vertical: true) // 👈 key point
            
//                VStack{
//                    if exportType == .Video{
////                        VideoPlayer(player: player)
//                        if player != nil{
//                            CustomVideoPlayer(player: player!)
//                                .frame(width: 250, height: 350)
//                        }
//                    }else {
            VStack {
                if let thumbnailImage = thumbnailImage {
                    VStack{
                        SwiftUI.Image(uiImage: thumbnailImage)
                            .resizable()
                            .scaledToFit()
                        
                    }
                    .frame(width: 350, height: 350)
                } else {
                    ProgressView()
                        .frame(width: 350, height: 350)
                    
                        .onAppear {
                            loadImage()
                        }
                }
            }  .overlay(content: {
                if !isBlastFinished {
                    
                    PremiumLottieView(animationName: "blastEffect", loopMode: .playOnce,isCompleted: $isBlastFinished)
                        .frame(width: 350, height: 350)
                }

            })
//                    }
//                }
//                .frame(width: 250, height: 400)
//                
                
            PrimaryButton(title: "How_was_your_experience".translate(), icon: nil, isFullWidth: true, action: {
                // FIXME: -
                    ratingViewModel.showRating = true
                    
                } ) .padding(.horizontal)

            SecondaryButton(title: "Share_".translate(), icon: nil, isFullWidth: true, action: {
//                    addBackgroundTapped?()
                    shareImage = ShareOutput(image: thumbnailImage!)
                } ) .padding(.horizontal)
                
            SecondaryButton(title: "Start_Something_New".translate(), icon: nil, isFullWidth: true,   action: {
                   
                    router.popEditorIfAvailable()
                    router.popToRoot()
                    onHomeTapped?()
//                    addBackgroundTapped?()
                } ) .padding(.horizontal)
                
                
                
//           
//                Spacer()
                 
                
            }
        .sheet(item: $shareImage, content: { imageOutput in
            shareSocialCard
                .presentationDetents([.height(200)])
                .presentationDragIndicator(.visible)

        })
        .sheet(isPresented: $ratingViewModel.showRating, content: {
            FixedDetentSheetContainer(
                              variant: .constant(variant),           // or bind if Host owns the rating
                              spec: .defaults
                          ) {
                              RatingFlowView()                       // your existing view (unchanged)
                                  .environmentObject(ratingViewModel)             // if needed
                                  .fixedSize(horizontal: false, vertical: true)
                                  .layoutPriority(1)
                                  .onChange(of: ratingViewModel.showRating) { showRating in
                                      if showRating == false {
                                          
                                      }
                                  }
                          }
        })

        
            .environment(\.sizeCategory, .medium)
            .onAppear{
//                self.analyticsLogger.trackScreens(screen: .export)
//                UserDefaultKeyManager.shared.updateAppOpenCount()
            }
//            .background(Color.secondarySystemBackground.opacity(0.7))
            //            .frame(maxHeight: .infinity)
            //            .ignoresSafeArea()
            

            .onAppear {
                setupPlayer()
                vibrate()
            }
            
            //        }
            .onDisappear(){
                player?.pause()
            }
            .onReceive(dropViewModel.$drop) { newDrop in
                if let drop = newDrop {
                    
                    
                    Drops.show(drop)
                }
            }
            .navigationTitle("Ready_to_share")
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(trailing: Button(action: {
////                ratingManager.checkAndAskForReview()
//                if ratingManager.canShowReview() {
//                    ratingManager.showFeedbackPage()
//                }else {
//                    onCloseTapped?()
//                }
////                onCloseTapped?()
//            }) {
//                VStack{
//                    SwiftUI.Image("ic_Close")
//                        .resizable()
//                        .renderingMode(.template)
//                        .foregroundColor(.label)
//                        .frame(width: 20, height: 20)
//                }
//                .frame(width: 30, height: 30)
//                .background(Color.systemBackground)
//                .cornerRadius(15)
//            })
            Button(action: {
                           // Handle dismiss logic here
           //                onDismiss()
                           onCloseTapped?()
                       }) {
                           Image(systemName: "xmark.circle.fill")
                               .font(.title)
                               .foregroundColor(.gray)
                       }
                       .padding(.trailing, 20)
                       .padding(.top, 20)
        }.frame(alignment: .top)
        
           
        
        
        
//        .navigationViewStyle(.stack)
        
    }
    
    private func setupPlayer() {
        guard let videoURL = videoURL else { return }
        player = AVPlayer(url: videoURL/*Bundle.main.url(forResource: "Test", withExtension: "mp4")!*/) //AVPlayer(url: shareDirectVM.videoURL)
        player?.actionAtItemEnd = .none
        player?.play()
        isPlaying = true
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak player] _ in
            player?.seek(to: .zero)
            player?.play()
        }
    }
    
    func loadImage() {
        
        
        
        if thumbnailImage != nil {
            return
        }
        guard let videoURL = videoURL else { return }

        let task = URLSession.shared.dataTask(with: videoURL) { data, response, error in
            guard let data = data, error == nil else {
                // handle error appropriately
                return
            }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.thumbnailImage = image
                    ShareDirect.photoAlbumManager.saveToPhotoLibrary(thumbnailImage!, isJpeg: self.isJpeg)


                }
            }
        }
        task.resume()
    }
    
    private var shareSocialCard : some View {
        
    
      
                            VStack{
                                GeometryReader{ Geometry in
                                    ScrollView(.horizontal, showsIndicators: false){
                                        LazyHStack{
                                            ForEach(viewModel.myShareOptionModels, id: \.self) { shareDirectModel in
                                                ShareOptionCell(shareDirectaModel: shareDirectModel)
                                                    .onTapGesture {
                                                        DispatchQueue.global().async {
                                                            var type = "Video"
                                                            if exportType == .Video{
                                                                if let videoURL = videoURL {
                                                                    switch shareDirectModel.shareOption {
                                                                    case .InstaStory:
                                                                        _ = ShareDirect.instaManager.shareToStory(VideoUrl: videoURL)
//                                                                        exportAction = .shareToinstagram
                                                                        type = "Video"
                                                                    case .InstaPost:
                                                                        ShareDirect.instaManager.shareToFeed(video: videoURL)
//                                                                        exportAction = .shareToinstagram
                                                                        type = "Video"
                                                                    case .FBPost:
                                                                        ShareDirect.fbManager.shareToFeed(videoURL: videoURL)
//                                                                        exportAction = .shareTofacebook
                                                                        type = "Video"
            
                                                                    case .FBStory:
                                                                        ShareDirect.fbManager.shareToFeed(videoURL: videoURL)
//                                                                        exportAction = .shareTofacebook
                                                                        type = "Video"
                                                                    case .Mail:
//                                                                        exportAction = .shareToMail
                                                                        type = "Video"
                                                                        DispatchQueue.main.async {
                                                                            MailManager.shared.sendMail(video: videoURL, fileName: videoName)
                                                                        }
            
                                                                    case .More:
//                                                                        exportAction = .sharedActivityUsed
                                                                        type = "Video"
                                                                        isMorePresented = true
            
                                                                    case .PhotosAlbum:
//                                                                        exportAction = .saveToGallaery
                                                                        type = "Video"
                                                                        ShareDirect.photoAlbumManager.saveToPhotoLibrary(videoURL)
                                                                    case .Socials:
//                                                                        exportAction = .sharedActivityUsed
                                                                        type = "Video"
            
                                                                        ShareDirect.socialsManager.share(video: videoURL, videoName: videoName)
                                                                    }
                                                                }
                                                            }else{
                                                                switch shareDirectModel.shareOption {
                                                                case .InstaStory:
                                                                    _ = ShareDirect.instaManager.shareToStory(Image: thumbnailImage!)
//                                                                    exportAction = .shareToinstagram
                                                                    type = "Image"
                                                                case .InstaPost:
                                                                    ShareDirect.instaManager.shareToFeed(image: thumbnailImage!)
//                                                                    exportAction = .shareToinstagram
                                                                    type = "Image"
            
                                                                case .FBPost:
                                                                    ShareDirect.fbManager.shareToFeed(image: thumbnailImage!)
//                                                                    exportAction = .shareTofacebook
                                                                    type = "Image"
            
                                                                case .FBStory:
                                                                    ShareDirect.fbManager.shareToFeed(image: thumbnailImage!)
//                                                                    exportAction = .shareTofacebook
                                                                    type = "Image"
            
                                                                case .Mail:
                                                                    DispatchQueue.main.async {
                                                                        MailManager.shared.sendMail(image: thumbnailImage!)
            
                                                                    }
//                                                                    exportAction = .shareToMail
                                                                    type = "Image"
            
                                                                case .More:
            
                                                                    isMorePresented = true
//                                                                    exportAction = .sharedActivityUsed
                                                                    type = "Image"
            
                                                                case .PhotosAlbum:
                                                                    ShareDirect.photoAlbumManager.saveToPhotoLibrary(thumbnailImage!)
//                                                                    exportAction = .saveToGallaery
                                                                    type = "Image"
            
                                                                case .Socials:
                                                                    ShareDirect.socialsManager.share(image: thumbnailImage!)
//                                                                    exportAction = .sharedActivityUsed
                                                                    type = "Image"
            
                                                                }
                                                            }
            
            
//                                                            analyticsLogger.logExport(exportAction: exportAction, format: type)
            
                                                        }
            
                                                    }
                                            }
                                        }
                                        .frame(width: Geometry.size.width, alignment: .center)
                                    }
                                }
            
                            }
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                            .sheet(isPresented: $isMorePresented) {
                                if exportType == .Video{
                                    ActivityViewController(activityItems: [self.videoURL], applicationActivities: nil, excludedActivityTypes: nil, exportError: $exportError)
                                }else{
                                    ActivityViewController(activityItems: [self.thumbnailImage!], applicationActivities: nil, excludedActivityTypes: nil, exportError: $exportError)
                                }
                            }
                            .onChange(of: isMorePresented){ value in
                                if value == false{
                                    switch exportError {
                                    case .success(let message):
                                        dropViewModel.showDrop(title: "Success_".translate(), subtitle: message)
                                        
                                    case .failure(let message):
                                        dropViewModel.showDrop(title: "Failure_".translate(), subtitle: message)
                                    }
                                }
                            }
        
    }
    
}


struct ShareOptionCell: View {
    var shareDirectaModel: ShareDirectModel
    
    var body: some View {
        VStack{
            SwiftUI.Image(uiImage: shareDirectaModel.image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            Text(shareDirectaModel.title)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 12))
                
//                .frame(width: 50, height: 30)
        }.frame(width: 60, height: 80)
    }
}

#Preview {
    ExportPage(url: Bundle.main.url(forResource: "Test", withExtension: "mp4")!, exportType: .Video, onCloseTapped: {}, onHomeTapped: {})
}


/* ExportPage {
 
 
 @State exportError : ExportError
 
 enum ExportError : String {
 
 case succes(string)
 case error(String)
 
 
 
 
 var body {
 
 zStack {
 
 vStack {
  item 1 ( instaError )
  item 2
 }
 
 
 if instaError {
 
 exportErrror = .succes(instaError.message)
 
 }
 
 
 if exportError {
 
 switch exportErro
 case sucess(message)
 drop(message)

 case error(message)
 drop(message)

 
 }
 }
 
 
 
 mail {
 
 result
 
 sucess
  parent.success = .success("success")
 
 
 draft
 parent.error = .error("draft")

 
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */

import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true // Enables system controls (including fullscreen)
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}


import Combine

class DropViewModel: ObservableObject {
    @Published var drop: Drop?

    func showDrop(title: String, subtitle: String) {
        let newDrop = Drop(
            title: title,
            subtitle: subtitle,
            icon: nil,
            action: .init(icon: nil, handler: {
                print("Drop tapped")
                Drops.hideCurrent()
            }),
            position: .top,
            duration: 2.0
        )
        self.drop = newDrop
    }
}





class RatingManager{
    
    var key: RatingManagerKey
    var ratingPageController: UIHostingController<RatingPage>?
    
    init(rmk: RatingManagerKey){
        self.key = rmk
    }
    
    @MainActor public  func checkAndAskForReview() {
        //        call this whenever appropriate
        //        this will not be shown everytime. Apple has some internal logic on how to show this.
        
//        guard let appOpenCount = UserDefaultStandardKeys.AppOpenCount.value as? Int else {
//            UserDefaultStandardKeys.AppOpenCount.setValue(1)
//            return
//        }
//        guard let sharePageCount = UserDefaultStandardKeys.ShowSharePageCount.value as? Int else {
//            UserDefaultStandardKeys.ShowSharePageCount.setValue(1)
//            return
//        }
        
        let totalCount = key.appOpenCount + key.showSharePageCount
        
        let timeToShowRating = key.timeToShowRating
        
        switch totalCount {
            
        
        case 3,10 :
            if timeToShowRating {
//                SKStoreReviewController.requestRevie
                if let activeWindowScene = UIApplication.shared.activeWindowScene {
                    if #available(iOS 16.0, *) {
                        AppStore.requestReview(in: activeWindowScene)
                    } else {
                        // Fallback on earlier versions
                        SKStoreReviewController.requestReview(in: activeWindowScene)
                    }
                }
                key.timeToShowRating = false
            }else{
                if  key.showFeedback {
                    showFeedbackPage()
//                    UserDefaultStandardKeys.TimeToShowRating.makeActive(true)
                    key.timeToShowRating = true
                }
            }
            print("TOTAL_COUNT case1 = ", totalCount)
            
        case _ where totalCount%25 == 0 :
            
            if timeToShowRating {
                if let activeWindowScene = UIApplication.shared.activeWindowScene {
                    if #available(iOS 16.0, *) {
                        AppStore.requestReview(in: activeWindowScene)
                    } else {
                        // Fallback on earlier versions
                        SKStoreReviewController.requestReview(in: activeWindowScene)
                    }
                }
//                UserDefaultStandardKeys.TimeToShowRating.makeActive(false)
                key.timeToShowRating = false
            }else{
                if  key.showFeedback {
                    showFeedbackPage()
                }
//                UserDefaultStandardKeys.TimeToShowRating.makeActive(true)
                key.timeToShowRating = true
            }
            
            print("TOTAL_COUNT case2 = ", totalCount)
        default:
            break;
        }
    }
    
    public  func canShowReview() -> Bool {
        //        call this whenever appropriate
        //        this will not be shown everytime. Apple has some internal logic on how to show this.
        
//        guard let appOpenCount = UserDefaultStandardKeys.AppOpenCount.value as? Int else {
//            UserDefaultStandardKeys.AppOpenCount.setValue(1)
//            return
//        }
//        guard let sharePageCount = UserDefaultStandardKeys.ShowSharePageCount.value as? Int else {
//            UserDefaultStandardKeys.ShowSharePageCount.setValue(1)
//            return
//        }
        
        
        var canShowReview = false
       
        if key.showSharePageCount == 1 {
            key.timeToShowRating = true
            canShowReview = true
            return canShowReview
        }
        
        
        let totalCount = key.appOpenCount + key.showSharePageCount
        
        let timeToShowRating = key.timeToShowRating
        
        switch totalCount {
        case 3,10 :
            if timeToShowRating {
                SKStoreReviewController.requestReview()
                key.timeToShowRating = false
            }else{
                if  key.showFeedback {
//                    showFeedbackPage()
                    canShowReview = true
//                    UserDefaultStandardKeys.TimeToShowRating.makeActive(true)
                    key.timeToShowRating = true
                }
            }
            print("TOTAL_COUNT case1 = ", totalCount)
            
        case _ where totalCount%25 == 0 :
            
            if timeToShowRating {
                SKStoreReviewController.requestReview()
//                UserDefaultStandardKeys.TimeToShowRating.makeActive(false)
                key.timeToShowRating = false
            }else{
                if  key.showFeedback {
//                    showFeedbackPage()
                    canShowReview = true
                }
//                UserDefaultStandardKeys.TimeToShowRating.makeActive(true)
                key.timeToShowRating = true
            }
            
            print("TOTAL_COUNT case2 = ", totalCount)
        default:
            break;
        }
        return canShowReview
    }
    
    func askForStoreKitReviewUI() {
        SKStoreReviewController.requestReview()
    }
    
    func showFeedbackPage(){
        
        if let vc =  UIApplication.shared.keyWindowPresentedController?.children.first {
            let ratingPage = RatingPage(onTapDismissTapped: { [weak self] in
                self?.removeRatingPage()
            })
            let ratingPageController = UIHostingController(rootView: ratingPage)
            self.ratingPageController = ratingPageController
            
            self.ratingPageController!.view.backgroundColor = .clear
            
            if let ratingPageVC = self.ratingPageController {
                vc.addChildVCWithMultiplier(ratingPageVC) // Present RatingPage on top
//                vc.present(ratingPageVC, animated: true)
            }else {
                print("rating hostingerViewController is nil")
            }
        }
    }
    
    func removeRatingPage() {
        guard let ratingPageVC = ratingPageController else { return }
        
        // Notify the child view controller that it will be removed from parent
        ratingPageVC.willMove(toParent: nil)
        
        // Remove the child view controller's view from the parent's view hierarchy
        ratingPageVC.view.removeFromSuperview()
        
        // Notify the child view controller that it's being removed from the parent
        ratingPageVC.removeFromParent()
        
        // Clear the reference to the child view controller
        ratingPageController = nil
    }
}

struct RatingPage: View {
//    @Injected var analytics : AnalyticsLogger
    
    @State var selectedFeedbackType: FeedbackViewType? = FeedbackViewType.none
    var onTapDismissTapped: (() -> Void)?
    
    var body: some View {
        ZStack{
            
            HStack {} .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: UIColor.black).opacity(0.45))
                .ignoresSafeArea()
                .onTapGesture {
//                    analytics.logAppFeedbackProvided(rating: .none)
                    onTapDismissTapped?()
                }
            
            Image(systemName: "plus")
            .resizable()
            .blur(radius: 5)
            .frame(width: 350)
            .frame(height: 500)
            .cornerRadius(30)
            

            
            
            
            VStack(spacing: 0){
             
                HStack {}.frame(width: 300, height: 50)
                
//                .offset(y:selectedFeedbackType == FeedbackViewType.none ? -250 : -275)
             
                
                VStack{
//                    SwiftUI.Image("RatingCreative")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
                    LottieView(url: Bundle.main.url(forResource: "feedback1", withExtension: "lottie")!)
                        
                        .frame(width: 400, height: 350)
                        .padding(.top,0)
                }
                .frame(width: 300, height: 150)
                
                
                //                    Spacer()
                
                VStack{
//                    HStack{
//                    StarRatingView()
                    if selectedFeedbackType == FeedbackViewType.none{
                        Text("Enjoying_PartyZaa")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                   
                        Text("Please_select_how_you_feel")
                            .foregroundStyle(.white)
                            .font(.body)
                    }
//                    }
//                    .padding(.top, 0)
                    
                    FeedbackView(selectedFeedback: $selectedFeedbackType)
                        .frame(maxWidth: .infinity)
                }.frame(height: 300)
                   
                
            }
            .frame(width: 350)
            .frame(height:  500)
//            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .cornerRadius(30)
            .padding(.horizontal, 15)
            .overlay {
                VStack {
                    HStack{
                        Spacer()
                        VStack{
                            SwiftUI.Image("ic_Close")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.systemBackground)
                        }
                        .frame(width: 40, height: 40)
                        .background {
                            VisualEffectView2(blurStyle: .dark).frame(width: 40, height: 40)
                                .clipShape(.circle)

                        }
                        .onTapGesture {
//                            analytics.logAppFeedbackProvided(rating: .none)
                            onTapDismissTapped?()
                        }
                        
                        //                    .background(.black)
                        //                    .background(Color(uiColor: UIColor(hexString: "F2F2F7")!))
                        //                    .cornerRadius(15)
                        
                        
                    }
                    .background(Color.clear)
                    .frame(width: 350)
                    //.background(.black)
                    .frame(height: 50)
                    .padding(.trailing, 15)
                    
                    Spacer()
                    
                }  .frame(width: 350)
                    .frame(height:  500)
        //            .background(Color(uiColor: UIColor.secondarySystemBackground))
                    .cornerRadius(30)
                    .padding(.horizontal, 15)
            }
           

            
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .environment(\.sizeCategory, .medium)
       
    }
}

// Five-star rating with draggable selection and half-star snapping.
//struct StarRatingView: View {
//    // Public API
//    @Binding var rating: Double                     // live value (0...maxRating)
//    let maxRating: Double
//    let step: Double                                // e.g. 0.5 for half-stars
//    let starSize: CGFloat
//    let starSpacing: CGFloat
//    let onSelectionEnd: ((Double) -> Void)?
//
//    // Init with sensible defaults
//    init(
//        rating: Binding<Double>,
//        maxRating: Double = 5.0,
//        step: Double = 0.5,
//        starSize: CGFloat = 28,
//        starSpacing: CGFloat = 6,
//        onSelectionEnd: ((Double) -> Void)? = nil
//    ) {
//        self._rating = rating
//        self.maxRating = maxRating
//        self.step = step
//        self.starSize = starSize
//        self.starSpacing = starSpacing
//        self.onSelectionEnd = onSelectionEnd
//    }
//
//    private var starCount: Int { Int(maxRating.rounded()) }
//    private var totalWidth: CGFloat {
//        (CGFloat(starCount) * starSize) + (CGFloat(starCount - 1) * starSpacing)
//    }
//
//    var body: some View {
//        ZStack(alignment: .leading) {
//            // Base (empty) stars
//            starsLayer(filled: false)
//                .frame(width: totalWidth, height: starSize, alignment: .leading)
//
//            // Filled stars masked by current rating width
//            starsLayer(filled: true)
//                .frame(width: totalWidth, height: starSize, alignment: .leading)
////                .mask(
////                    ZStack(alignment: .leading) {
////                        Rectangle()
////                            .frame(width: fillWidth(for: rating))
////                    }
////                )
//                .mask(maskLayer(for: rating))
//        }
//        .frame(width: totalWidth, height: starSize, alignment: .leading)
//        .contentShape(Rectangle()) // full hit area
//        .gesture(
//            DragGesture(minimumDistance: 0)
//                .onChanged { value in
//                    let x = clamp(Double(value.location.x), min: 0, max: Double(totalWidth))
//                    let newRating = (x / Double(totalWidth)) * maxRating
//                    rating = clamp(newRating, min: 0, max: maxRating) // live update
//                }
//                .onEnded { value in
//                    let x = clamp(Double(value.location.x), min: 0, max: Double(totalWidth))
//                    let exact = (x / Double(totalWidth)) * maxRating
//                    let snapped = snap(exact, to: step, within: 0...maxRating)
//                    rating = snapped
//                    onSelectionEnd?(snapped) // <-- returns 1, 2.5, 4, etc.
//                }
//        )
//        .accessibilityElement(children: .ignore)
//        .accessibilityLabel("Rating")
//        .accessibilityValue("\(rating, specifier: "%.1f") out of \(Int(maxRating))")
//    }
//
//    // MARK: - Layers
//
//    private func starsLayer(filled: Bool) -> some View {
//        HStack(spacing: starSpacing) {
//            ForEach(0..<starCount, id: \.self) { _ in
//                Image(systemName: filled ? "star.fill" : "star")
//                    .resizable()
//                    .scaledToFit()
//            }
//        }
//        .foregroundStyle(filled ? .yellow : .secondary)
//    }
//
//    private func fillWidth(for rating: Double) -> CGFloat {
//        CGFloat(rating / maxRating) * totalWidth
//    }
//
//    // MARK: - Helpers
//
//    private func snap(_ value: Double, to step: Double, within range: ClosedRange<Double>) -> Double {
//        let snapped = (value / step).rounded() * step
//        return min(max(snapped, range.lowerBound), range.upperBound)
//    }
//
//    private func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
//        Swift.min(Swift.max(value, min), max)
//    }
//    private func maskLayer(for rating: Double) -> some View {
//        // Percentage of total width based on rating
//        let percent = rating / maxRating
//        let fillWidth = CGFloat(percent) * totalWidth
//
//        return GeometryReader { geo in
//            let centerX = geo.size.width / 2
//            Rectangle()
//                .frame(width: fillWidth, height: geo.size.height)
//                .offset(x: 0, y: 0)
//        }
//    }
//}
//#Preview {
//    RatingPage()
//}

enum FeedbackViewType{
    case none
    case bad
    case good
    case excellent
}

struct FeedbackView: View {
    
//    @Injected var  analyticsLogger : AnalyticsLogger
    @Binding var selectedFeedback: FeedbackViewType?
    @State private var isBouncingBad = false
    @State private var isBouncingGood = false
    @State private var isBouncingExcellent = false
    var viewModel = ShareDirectViewModel()
    let ratingManager = RatingManager(rmk: UserDefaultKeyManager())
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack{
            HStack(spacing: 40){
//                FeedbackViewButton(isBouncing: $isBouncingBad, feedbackType: .bad, imageName: "bad")
                VStack{
                    LottieView(url: Bundle.main.url(forResource: "bad", withExtension: "lottie")!, feedback: .bad)
                        .frame(width: 60, height: 40)
                        .clipShape(Circle())
                        .scaleEffect(selectedFeedback == .bad ? 1.5 : 0.8)
                    
                    Text("bad_")
                        .foregroundStyle(Color.secondarySystemBackground)
                    
                }
                .background(content: {
                    let width = selectedFeedback == .bad ? 100.0 : 80.0
                    let height = selectedFeedback == .bad ? 110.0 : 90.0

                    VisualEffectView2(blurStyle: .dark).frame(width: width, height: height).cornerRadius(10)
                })
                .onTapGesture {
                    vibrate()
                    withAnimation {
                        selectedFeedback = .bad
                    }
                   
//                    analyticsLogger.logAppFeedbackProvided(rating: .bad)
//                    withAnimation(Animation.spring(response: 0.2, dampingFraction: 1, blendDuration: 0).repeatCount(1)){
                        self.isBouncingBad = true
                        self.isBouncingGood = false
                        self.isBouncingExcellent = false
//                    }
                }
//                FeedbackViewButton(isBouncing: $isBouncingGood, feedbackType: .bad, imageName: "good")
                VStack{
                    LottieView(url: Bundle.main.url(forResource: "good", withExtension: "lottie")!, feedback: .good)
                        .frame(width: 60, height: 40)
                        .clipShape(Circle())
                        .scaleEffect(selectedFeedback == .good ? 1.5 : 0.8)
                        
                    Text("good_")
                        .foregroundStyle(Color.secondarySystemBackground)
                }
                .background(content: {
                    let width = selectedFeedback == .good ? 100.0 : 80.0
                    let height = selectedFeedback == .good ? 110.0 : 90.0

                    VisualEffectView2(blurStyle: .dark).frame(width: width, height: height).cornerRadius(10)
                })
                .onTapGesture {
                    vibrate()
                    selectedFeedback = .good
//                    analyticsLogger.logAppFeedbackProvided(rating: .good)
                    
//                    withAnimation(Animation.spring(response: 0.2, dampingFraction: 1, blendDuration: 0).repeatCount(1)){
                        self.isBouncingGood = true
                        self.isBouncingBad = false
                        self.isBouncingExcellent = false
//                    }
                }
//                FeedbackViewButton(isBouncing: $isBouncingExcellent, feedbackType: .bad, imageName: "excellent")
                VStack{
                    LottieView(url: Bundle.main.url(forResource: "excellent", withExtension: "lottie")!, feedback: .excellent)
                        .frame(width: 60, height: 40)
                        .clipShape(Circle())
                        .scaleEffect(selectedFeedback == FeedbackViewType.none ? 1.5 : selectedFeedback == .excellent ? 1.5 : 0.8)
                    
                    Text("excellent_")
                        .foregroundStyle(Color.secondarySystemBackground)
                }
                .background(content: {
                    let width = selectedFeedback == FeedbackViewType.none ? 100.0 :  selectedFeedback == .excellent ? 100.0 : 80.0
                    let height = selectedFeedback ==  FeedbackViewType.none ? 110.0 : selectedFeedback == .excellent ? 110.0 : 90.0

                    VisualEffectView2(blurStyle: .dark).frame(width: width, height: height).cornerRadius(10)
                })
                
                .onTapGesture {
                    withAnimation {
                        selectedFeedback = .excellent
                    }
                    vibrate()
                    
                    selectedFeedback = .excellent
//                    analyticsLogger.logAppFeedbackProvided(rating: .excellent)
                    ratingManager.askForStoreKitReviewUI()
//                    withAnimation(Animation.spring(response: 0.2, dampingFraction: 1, blendDuration: 0).repeatCount(1)){
                        self.isBouncingExcellent = true
                        self.isBouncingGood = false
                        self.isBouncingBad = false
//                    }
                }
            }

            
            if selectedFeedback == .bad{
                VStack{
                    Text("Need_Help")
                        .foregroundStyle(Color.secondarySystemBackground)
                    Text("Dont_worry_we_are_here_to_help_you")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.tertiarySystemBackground)
                        .font(.footnote)
                        .frame( height: 60)
                    
                    VStack{
                        Text("Ask_for_help")
                            .foregroundColor(.systemBackground)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 200, height: 40)
                    .background(content: {
                        VisualEffectView2(blurStyle: .dark).frame(width: 200, height: 40).cornerRadius(5)
                    })
                    .cornerRadius(5)
                    .onTapGesture {
//                        if viewModel.myShareOptionModels[5].shareOption == .Mail{
//                            ShareDirect.mailManager.sendMailNoAttachments()
//                        }
//                        MailManager.shared.askForHelpMail()
                        
                    }
                }
                .padding(.top, 10)
//                .transition(.move(edge: .bottom)) // Move transition from the bottom
//                .animation(.easeInOut(duration: 0.5), value: selectedFeedback == .bad)
            }else if selectedFeedback == .good{
                VStack{
                    Text("Got_suggestions")
                        .foregroundStyle(Color.secondarySystemBackground)
                    Text("Wed_love_to_hear_your_thoughts_on_how_we_could_improve_the_app")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.tertiarySystemBackground)
                        .font(.footnote)
                        .frame( height: 60)
                    VStack{
                        Text("Send_Suggestions")
                            .foregroundColor(.systemBackground)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 200, height: 40)
                    .background(content: {
                        VisualEffectView2(blurStyle: .dark).frame(width: 200, height: 40).cornerRadius(5)
                    })
                    .cornerRadius(5)
                    .onTapGesture {
//                        ShareDirect.mailManager.sendMailNoAttachments()
//                        MailManager.shared.sendSuggestionMail()
                    }
                }
                .padding(.top, 10)
            }else if selectedFeedback == .excellent{
                VStack{
                    Text("Thank_you")
                        .foregroundColor(Color.secondarySystemBackground)
                    Text("Will_you_write_a_review_on_App_store")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.tertiarySystemBackground)
                        .font(.footnote)
                        .frame( height: 60)
                    VStack{
                        Text("Review_")
                            .foregroundColor(.systemBackground)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 200, height: 40)
                    .background(content: {
                        VisualEffectView2(blurStyle: .dark).frame(width: 200, height: 40).cornerRadius(5)
                    })
                    .cornerRadius(5)
                    .onTapGesture {
                     
                            if let url = URL(string: "https://apps.apple.com/us/developer/saraswati-javalkar/id1305053157") {
                                openURL(url)
                            }
                        
                    }
                }
                .padding(.top, 10)
            }
            
            
            
        }
        .environment(\.sizeCategory, .medium)
    }
}

struct FeedbackViewButton: View {
    
    @Binding var isBouncing: Bool
    var feedbackType: FeedbackViewType
    var imageName: String
    @State var selectedFeedback: FeedbackViewType? = .excellent
    
    var body: some View {
        VStack{
//            SwiftUI.Image(imageName)
//                .resizable()
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//                .scaleEffect(isBouncing ? 1.2 : 1.0)
//
//            Text(imageName)
            
            LottieView(url: Bundle.main.url(forResource: imageName, withExtension: "lottie")!, feedback: feedbackType)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .scaleEffect(isBouncing ? 1.5 : 1.0)
                .onTapGesture {
                    selectedFeedback = feedbackType
                }
            
            Text(imageName)
            
        }
        .environment(\.sizeCategory, .medium)
    }
    
}


/// Five-star rating with draggable selection and half-star snapping.
//struct StarRatingView: View {
//    // Public API
//    @Binding var rating: Double                     // live value (0...maxRating)
//    let maxRating: Double
//    let step: Double                                // e.g. 0.5 for half-stars
//    let starSize: CGFloat
//    let starSpacing: CGFloat
//    let onSelectionEnd: ((Double) -> Void)?
//
//    // Init with sensible defaults
//    init(
//        rating: Binding<Double>,
//        maxRating: Double = 5.0,
//        step: Double = 0.5,
//        starSize: CGFloat = 28,
//        starSpacing: CGFloat = 6,
//        onSelectionEnd: ((Double) -> Void)? = nil
//    ) {
//        self._rating = rating
//        self.maxRating = maxRating
//        self.step = step
//        self.starSize = starSize
//        self.starSpacing = starSpacing
//        self.onSelectionEnd = onSelectionEnd
//    }
//
//    private var starCount: Int { Int(maxRating.rounded()) }
//    private var totalWidth: CGFloat {
//        (CGFloat(starCount) * starSize) + (CGFloat(starCount - 1) * starSpacing)
//    }
//
//    var body: some View {
//        ZStack(alignment: .leading) {
//            // Base (empty) stars
//            starsLayer(filled: false)
//                .frame(width: totalWidth, height: starSize, alignment: .leading)
//
//            // Filled stars masked by current rating width
//            starsLayer(filled: true)
//                .frame(width: totalWidth, height: starSize, alignment: .leading)
//                .mask(
//                    ZStack(alignment: .leading) {
//                        Rectangle()
//                            .frame(width: fillWidth(for: rating))
//                    }
//                )
//        }
//        .frame(width: totalWidth, height: starSize, alignment: .leading)
//        .contentShape(Rectangle()) // full hit area
//        .gesture(
//            DragGesture(minimumDistance: 0)
//                .onChanged { value in
//                    let x = clamp(Double(value.location.x), min: 0, max: Double(totalWidth))
//                    let newRating = (x / Double(totalWidth)) * maxRating
//                    rating = clamp(newRating, min: 0, max: maxRating) // live update
//                }
//                .onEnded { value in
//                    let x = clamp(Double(value.location.x), min: 0, max: Double(totalWidth))
//                    let exact = (x / Double(totalWidth)) * maxRating
//                    let snapped = snap(exact, to: step, within: 0...maxRating)
//                    rating = snapped
//                    onSelectionEnd?(snapped) // <-- returns 1, 2.5, 4, etc.
//                }
//        )
//        .accessibilityElement(children: .ignore)
//        .accessibilityLabel("Rating")
//        .accessibilityValue("\(rating, specifier: "%.1f") out of \(Int(maxRating))")
//    }
//
//    // MARK: - Layers
//
//    private func starsLayer(filled: Bool) -> some View {
//        HStack(spacing: starSpacing) {
//            ForEach(0..<starCount, id: \.self) { _ in
//                Image(systemName: filled ? "star.fill" : "star")
//                    .resizable()
//                    .scaledToFit()
//            }
//        }
//        .foregroundStyle(filled ? .yellow : .secondary)
//    }
//
//    private func fillWidth(for rating: Double) -> CGFloat {
//        CGFloat(rating / maxRating) * totalWidth
//    }
//
//    // MARK: - Helpers
//
//    private func snap(_ value: Double, to step: Double, within range: ClosedRange<Double>) -> Double {
//        let snapped = (value / step).rounded() * step
//        return min(max(snapped, range.lowerBound), range.upperBound)
//    }
//
//    private func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
//        Swift.min(Swift.max(value, min), max)
//    }
//}


import Lottie
import MessageUI

struct LottieView: UIViewRepresentable{
    var url: URL
    
    var feedback: FeedbackViewType?
    
//    func makeUIView(context: Context/*UIViewRepresentableContext<LottieView>*/) -> some UIView {
////        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
////        let animationView = LottieAnimationView()
////
////        animationView.translatesAutoresizingMaskIntoConstraints = false
////
////        view.addSubview(animationView)
////
////        NSLayoutConstraint.activate([
////            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
////            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
////        ])
////
////
////        animationView.contentMode = .scaleAspectFit
////        animationView.loopMode = .loop
////
////        DotLottieFile.loadedFrom(url: url) { result in
////            switch result{
////            case .success(let success):
////                animationView.play()
////            case .failure(let failure):
////                print(failure)
////            }
////        }
////
////
////        return view
//        return UIView()
//
//
//    }
//
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        let animationView = LottieAnimationView()
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        uiView.addSubview(animationView)
//
//        NSLayoutConstraint.activate([
//            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
//            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
//        ])
//
//        DotLottieFile.loadedFrom(url: url) { result in
//            switch result{
//            case .success(let success):
//                animationView.loadAnimation(from: success)
//                animationView.loopMode = .loop
//                animationView.play()
//
//            case .failure(let failure):
//                print(failure)
//            }
//        }
//    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        context.coordinator.animationView = animationView
        loadAnimation(animationView)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = context.coordinator.animationView else { return }
        loadAnimation(animationView)
        
//        let scale: CGFloat = selectedFeedback == feedback ? 1.5 : 1.0
//        animationView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func loadAnimation(_ animationView: LottieAnimationView) {
        DotLottieFile.loadedFrom(url: url) { result in
            switch result {
            case .success(let success):
                animationView.loadAnimation(from: success)
                animationView.loopMode = .loop
                animationView.play()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator {
        var animationView: LottieAnimationView?
        
    }
    
//    func playOnce(){
//        if !animationView.isAnimationPlaying {
//            animationView.loopMode = .playOnce
//            animationView.play()
//        }
//    }
//    func playLoop(){
//        if !animationView.isAnimationPlaying {
//            animationView.loopMode = .loop
//            animationView.play()
//        }
//    }
//    func stopAnim(){
//        if animationView.isAnimationPlaying {
//            animationView.stop()
//        }
//    }
}
struct NewLottieView: UIViewRepresentable{
    var url: URL
    

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        context.coordinator.animationView = animationView
        loadAnimation(animationView)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = context.coordinator.animationView else { return }
        loadAnimation(animationView)
        
//        let scale: CGFloat = selectedFeedback == feedback ? 1.5 : 1.0
//        animationView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func loadAnimation(_ animationView: LottieAnimationView) {
        DotLottieFile.loadedFrom(url: url) { result in
            switch result {
            case .success(let success):
                animationView.loadAnimation(from: success)
                animationView.loopMode = .loop
                animationView.play()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator {
        var animationView: LottieAnimationView?
        
        init() {
        }
    }
    

}

struct VisualEffectView2: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style = .prominent

    func makeUIView(context: Context) -> UIVisualEffectView {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return visualEffectView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}


func vibrate() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}


enum ExportError{
    case success(String)
    case failure(String)
}

class ShareDirectVM{
    
//    var videoURL: URL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    var videoName: String = "Test Video"
    
    
    func shareVideo(option: ShareOption) {
        //        if let video = videoURL , let videoName = videoName {
        guard let videoURL = Bundle.main.url(forResource: "Test", withExtension: "mp4") else {
            print("Video file not found in bundle.")
            return
        }
        
        switch option {
        case .InstaStory:
            _ = ShareDirect.instaManager.shareToStory(VideoUrl: videoURL)
        case .InstaPost:
            ShareDirect.instaManager.shareToFeed(video: videoURL)
        case .FBPost:
            ShareDirect.fbManager.shareToFeed(videoURL: videoURL)
        case .FBStory:
            ShareDirect.fbManager.shareToFeed(videoURL: videoURL)
        case .Mail:
//            IOSLoader.showLoader(in: self.view)
            ShareDirect.mailManager.sendMail(video: videoURL, fileName: videoName)
        case .More:
//            IOSLoader.showLoader(in: self.view)
            ShareDirect.more.share(video: videoURL, videoName: videoName)
        case .PhotosAlbum:
//            IOSLoader.showLoader(in: self.view)
            ShareDirect.photoAlbumManager.saveToPhotoLibrary(videoURL)
        case .Socials:
//            IOSLoader.showLoader(in: self.view)
            ShareDirect.socialsManager.share(video: videoURL, videoName: videoName)
        }
//        }else {
//            print("Image Not Found")
//        }
    }
    
}


struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    let excludedActivityTypes: [UIActivity.ActivityType]?
    @Binding var exportError: ExportError

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = { (activity, success, items, error)  in

            if success {
                // Activity was completed successfully
                self.exportError = .success("Video_shared_successfully".translate())
            } else {
                // Activity was cancelled or encountered an error
                self.exportError = .failure("Video_sharing_failed_or_was_cancelled".translate())
            }
            
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Update the view controller if needed
    }
}

//class MyClass : ObservableObject {
//    @Published var isPReseneted : Bool = false
//}

struct MailComposeViewController: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    let videoURL: URL
    let videoName: String
    let appName: String
    let supportEmail: String
    @Binding var exportError: ExportError
    

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = context.coordinator
        mailController.setToRecipients([supportEmail])
        mailController.setSubject("\(videoName) Share Via \(appName)")

        if let attachmentData = try? Data(contentsOf: videoURL) {
            mailController.addAttachmentData(attachmentData, mimeType: "video/mp4", fileName: "\(videoName).mp4")
        }
        

        return mailController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Update the view controller if needed
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, presentationMode: presentationMode)
    }
    

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var presentationMode: Binding<PresentationMode>
        var parent: MailComposeViewController

        init(_ parent: MailComposeViewController, presentationMode: Binding<PresentationMode>) {
            self.presentationMode = presentationMode
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            switch result{
                
            case .cancelled:
                self.parent.exportError = .failure("Email composition cancelled")
            case .saved:
                self.parent.exportError = .success("Email saved as draft")
            case .sent:
                self.parent.exportError = .success("Email sent successfully")
            case .failed:
                self.parent.exportError = .failure("Email sending failed")
                
            default:
                self.parent.exportError = .failure("Unknown error occurred")
            }
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
