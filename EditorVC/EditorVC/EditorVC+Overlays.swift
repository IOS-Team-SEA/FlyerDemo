//
//  EditorVC+Overlays.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

import UIKit
import SwiftUI
import IOS_CommonEditor

extension EditorVC {
    
    /// loader
    func addShimmerEffect() {
//        let shimmerEffect = ShimmerEditorView()
//        shimmerEditorView = UIHostingController(rootView: shimmerEffect)
//
//        if let hostingVC = shimmerEditorView {
//            hostingVC.view.frame = self.view.bounds
//            UIApplication.shared.keyWindow?.addSubview(hostingVC.view)
//            //            self.navigationController?.navigationBar.isHidden = true
//        } else {
//            print("shimmer effect hosting is nil")
//        }
        
        loaderState.image = thumbImage
        
        let idealSize = CGSize(width: UIScreen.main.bounds.width - 16 , height: UIScreen.main.bounds.height - 150)
        
        let size = getProportionalSize(currentSize: thumbImage.mySize , newSize:  idealSize )
        
        let height = min(idealSize.height,size.height)
        
        let customLoaderView = TemplateLoader(loaderState: loaderState , maxDimensions: CGSize(width: UIScreen.main.bounds.width - 16, height: height))
            .frame(width: UIScreen.main.bounds.width - 16 , height: height)
            .cornerRadius(10)
            .environmentObject(UIStateManager.shared)
//            .environment(\.sizeCategory, .medium)
        
//        let customLoaderView = PartyEditorLoader(loaderState: loaderState)
//            .environmentObject(UIStateManager.shared)
//            .environment(\.sizeCategory, .medium)

        customLoader = UIHostingController(rootView: AnyView(customLoaderView))
        
        if let loaderHostingVC = customLoader{
            loaderHostingVC.view.frame = self.view.bounds
            UIApplication.shared.keyWindow?.addSubview(loaderHostingVC.view)
        }else {
            print("shimmer effect hosting is nil")
        }
    }
    func showCustomLoader(with image: UIImage) {
        loaderState.image = image
        loaderState.progress = 0.0
        let loaderView = PartyZaLoader(loaderState: loaderState, saveType: engine?.templateHandler.exportSettings.exportType == .Video ? "Video_".translate() : "Image_".translate()).environmentObject(UIStateManager.shared).environment(\.sizeCategory, .medium)
        loaderHostingController = UIHostingController(rootView: AnyView(loaderView))
        
        if let loaderVC = loaderHostingController {
            loaderVC.modalPresentationStyle = .overFullScreen
            loaderVC.modalTransitionStyle = .crossDissolve
            UIApplication.shared.keyWindow?.rootViewController?.present(loaderVC, animated: true)
        }
    }
    
    func updateLoaderProgress(to value: CGFloat) {
        DispatchQueue.main.async {
            self.loaderState.progress = value
        }
    }

    func hideCustomLoader(completion: (() -> Void)? = nil) {
        loaderHostingController?.dismiss(animated: true) {
            self.loaderHostingController = nil
            completion?() 
        }
    }
    
    
    
    internal func presentAlertOnWindow() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            print("No active window found!")
            return
        }

        let alertController = UIAlertController(
            title: "State Changed",
            message: "An important state change has occurred.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.engine?.templateHandler.currentActionState.isTextNotValid = false // Reset state after dismissing the alert
        }
        alertController.addAction(okAction)

        // Present alert on top of the window
        keyWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    @objc  func showOverlay() {
        // Check if overlay is already visible
        if overlayHostingController != nil {
            dismissOverlay()
        }
        
        // Create the SwiftUI overlay view with a dismiss action
        let overlayView = PasteDrop(currentModel: self.engine!.templateHandler.currentModel!, currentActionState: self.engine!.templateHandler.currentActionState, image:  ((self.engine!.templateHandler.currentModel?.thumbImage) ?? UIImage(named: "none"))!) {
            self.dismissOverlay()
        }
        
        // Embed the SwiftUI overlay in a UIHostingController
        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear

        // Add as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Set up constraints to position at the top with safe area
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hostingController.view.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Animate the overlay appearance
        hostingController.view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            hostingController.view.alpha = 1
        }
        
        self.overlayHostingController = hostingController
    }
    
    
    private func dismissOverlay() {
        guard let hostingController = overlayHostingController else { return }
        hostingController.willMove(toParent: nil)
        hostingController.view.removeFromSuperview()
        hostingController.removeFromParent()
        self.overlayHostingController = nil
        
//        // Animate and remove the overlay
//        UIView.animate(withDuration: 0.0, animations: {
//            hostingController.view.alpha = 0
//        }, completion: { _ in
//            hostingController.willMove(toParent: nil)
//            hostingController.view.removeFromSuperview()
//            hostingController.removeFromParent()
//            self.overlayHostingController = nil
//        })
    }
}

struct TemplateLoader : View{
    
    @ObservedObject var loaderState: LoaderState
    @EnvironmentObject var uiStateManager : UIStateManager
    @State var progress: Float = 0
    
    @State var maxDimensions: CGSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)

  
    
    
    var body: some View {
        VStack{

                let aspectFitSize = getProportionalSize(currentSize: loaderState.image.mySize, newSize: maxDimensions)
                
                VStack {
                    ZStack{
                        Image(uiImage: loaderState.image)
                            .resizable()
                            .frame(width: aspectFitSize.width, height: aspectFitSize.height)
                            .blur(radius: 20 * CGFloat((0.9 - uiStateManager.progress))) // Blur decreases as progress increases
//                            .animation(.easeInOut, value: uiStateManager.progress)

                        Text("\(Int(uiStateManager.progress * 100)) %")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                }
                .frame(width: aspectFitSize.width, height: aspectFitSize.height)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.systemBackground)
    }
}

struct PartyZaLoader: View {
//    @Binding var progress: CGFloat
//    private let totalTime: CGFloat = 100.0
//    @Binding var image: UIImage
    @ObservedObject var loaderState: LoaderState
    @EnvironmentObject var uiStateManager : UIStateManager
    private let maxDimension: CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return 800
        }else{
            return 300
        }
    }()
    var saveType: String
    var exportText = "Exporting_".translate()
    var saveText = "saving_on_your_device".translate()
    
    private func calculateAspectFitDimensions(for image: UIImage) -> CGSize {
        let imageSize = image.mySize
        let aspectWidth = maxDimension / imageSize.width
        let aspectHeight = maxDimension / imageSize.height
        let scale = min(aspectWidth, aspectHeight) // Choose the smaller scale to fit
        
        return CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
    
    var body: some View {
        
        VStack{
            VStack(spacing: 10){
                
                Text("\(exportText) \(saveType)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
//                Text("\(saveType) \(saveText)")
//                    .font(.subheadline)
//                    .foregroundColor(.primary)
            }
            .padding(.bottom, 50)
            
            ZStack {
                
                let aspectFitSize = calculateAspectFitDimensions(for: loaderState.image)
                VStack {
                    ZStack{
                        Image(uiImage: loaderState.image)
                            .resizable()
                            .frame(width: aspectFitSize.width, height: aspectFitSize.height)
                            .background(.black).opacity(0.7)
                        Text("\(Int(loaderState.progress)) %")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                }
                .frame(width: aspectFitSize.width, height: aspectFitSize.height)
                
                // Progress as a rectangular border
                RectangleProgress(progress: loaderState.progress / 100, totalWidth: aspectFitSize.width + 5, totalHeight: aspectFitSize.height + 5)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "#84072e"), AppStyle.accentColor_SwiftUI, Color(hex: "#fd6295")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .square)
                    )
                    .frame(width: aspectFitSize.width + 5, height: aspectFitSize.height + 5)
            }
            
            VStack{
                Text("Please_do_not_lock_screen_or_switch_to_other_apps")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                
            }
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                loaderState.didCancelTapped = true
            }) {
                Text("Cancel_")
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(width: 300, height: 40)
                    .foregroundColor(.white)
                    .background(AppStyle.accentColor_SwiftUI)
                    .cornerRadius(8)
            }
            .frame(width: 300, height: 40)
            .padding(.top, 20)
            .padding(.bottom, 100)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.systemBackground)
        
    }
}

//#Preview {
//    PartyZaLoader()
//}

struct RectangleProgress: Shape {
    var progress: CGFloat
    var totalWidth: CGFloat
    var totalHeight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let totalPerimeter = 2 * (totalWidth + totalHeight) // Full perimeter

        // Calculate the progress length
        let progressLength = progress * totalPerimeter

        // Define points of the rectangle
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        // Draw the rectangle border based on progress
        path.move(to: topLeft)

        if progressLength <= totalWidth {
            path.addLine(to: CGPoint(x: topLeft.x + progressLength, y: topLeft.y)) // Top edge
        } else if progressLength <= totalWidth + totalHeight {
            path.addLine(to: topRight)
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y + (progressLength - totalWidth))) // Right edge
        } else if progressLength <= 2 * totalWidth + totalHeight {
            path.addLine(to: topRight)
            path.addLine(to: bottomRight)
            path.addLine(to: CGPoint(x: bottomRight.x - (progressLength - totalWidth - totalHeight), y: bottomRight.y)) // Bottom edge
        } else {
            path.addLine(to: topRight)
            path.addLine(to: bottomRight)
            path.addLine(to: bottomLeft)
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - (progressLength - 2 * totalWidth - totalHeight))) // Left edge
        }

        return path
    }
}
