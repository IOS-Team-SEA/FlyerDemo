//
//  UIStateManager.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 04/03/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI
//import Drops
import IOS_LoaderSPM
import IOS_CommonEditor

class UIStateManager: ObservableObject {
    static let shared = UIStateManager()
    typealias CategoryDict = [String: [DBTemplateModel]]
//    var iapVM  : IAPViewModel = IAPViewModel()
    var contentscaleFactor : CGFloat = 1
//    @Published var isTemplateLoaded: Bool           = false
    @Published var currentCategory: String          = ""
    @Published var  isConnectionLost: Bool           = false
    @Published var isDataFullyLoaded: Bool          = false
    @Published var categoriesSet: Set<CategoryDict> = []
    @Published var isTemplateDataDownloaded         = false
//    @Published var showAlert : Bool                 = false
    @Published var showDrop : Drop?                 = nil
    @Published var premiumPageDismissed : Bool      = false
    @Published var progress : Float = 0 {
        didSet {
            printLog("Progress : \(progress)")
        }
    }
    @Published var isPremium : Bool  = false
    var cancellables: Set<AnyCancellable> = []
    var loader : Loader = Loader()

    private init() {
        isPremium = PersistentStorage.shared.isUserSubscribed
        contentscaleFactor = getContentScaleFactor()

        
        $isConnectionLost.dropFirst().sink { [weak self] value in
            guard let self = self else { return }
            
            if value {
//                isTemplateLoaded = true
                showDrop = noInternetDrop
//                Loader.stopLoader()
            }
            else{
//                Loader.showLoader(in: UIApplication.shared.keyWindow!, blurr: true, text: "Loading...")
            }
        }.store(in: &cancellables)
        
        
    }
    
    
    func getContentScaleFactor()-> CGFloat{
        return UIApplication.shared.cWindow?.screen.nativeScale ?? 1
    }
    

    func presentOnWindowLevel() {
        // Create a new UIWindow
        var rootViewController = UIApplication.shared.cWindow?.rootViewController
        
        // Set the root view controller to your SwiftUI view
        let hostingController = UIHostingController(rootView: ProgressView())
        hostingController.modalPresentationStyle = .fullScreen
        
        rootViewController?.present(hostingController, animated: true, completion: {
        })
        
        // Store the window reference in the view for later dismissal
        hostingController.view.tag = 124
    }
    
    func dismissFromWindowLevel() {
        DispatchQueue.main.async {
            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                return
            }
            
            // Find the presented view controller using the tag
            if let presentedViewController = rootViewController.presentedViewController,
               presentedViewController.view.tag == 124 {
                presentedViewController.dismiss(animated: true) {
                    print("Ye Le Bhai Tera View Toh Dismissed Hpo Gya. Ab Bata Kya Karna Hai.")
                }
            }
        }
      
     }

}

var noInternetDrop : Drop {
   
    return Drop(
        title: "No_Internet".translate(),
        subtitle: "You_are_offline_Please_enable_the_Network".translate(),
                action: .init {
                    Drops.hideCurrent()
                },
                position: .top,
                duration: 2.0,
                accessibility: "Alert: Title, Subtitle"
            )
}

import UIKit
public extension UIApplication {
    class var Build: String? {
        get {
            return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
        }
    }
    
    class var Version: String? {
        get {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }
    }
     var keyWindowPresentedController: UIViewController? {
         var viewController = self.keyWindow?.rootViewController
         
         // If root `UIViewController` is a `UITabBarController`
         if let presentedController = viewController as? UITabBarController {
             // Move to selected `UIViewController`
             viewController = presentedController.selectedViewController
         }
         
         
         // Go deeper to find the last presented `UIViewController`
         while let presentedController = viewController?.presentedViewController {
             // If root `UIViewController` is a `UITabBarController`
             if let presentedController = presentedController as? UITabBarController {
                 // Move to selected `UIViewController`
                 viewController = presentedController.selectedViewController
             } else if let presenterController_ = presentedController as? UINavigationController{
                 viewController = presenterController_.topViewController
             }else{
                 // Otherwise, go deeper
                 viewController = presentedController
             }
         }
         
         return viewController
     }
     

     
     var cWindow: UIWindow? {
         // Get connected scenes
         if #available(iOS 13.0, *) {
             return UIApplication.shared.connectedScenes
             // Keep only active scenes, onscreen and visible to the user
                 .filter { $0.activationState == .foregroundActive }
             // Keep only the first `UIWindowScene`
                 .first(where: { $0 is UIWindowScene })
             // Get its associated windows
                 .flatMap({ $0 as? UIWindowScene })?.windows
             // Finally, keep only the key window
                 .first(where: \.isKeyWindow)
         } else {
             // Fallback on earlier versions
             return nil
         }
     }
}
