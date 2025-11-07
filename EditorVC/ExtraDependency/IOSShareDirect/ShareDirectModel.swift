//
//  ShareDirectModel.swift
//  IOSShareDirect
//
//  Created by JD on 8/10/20.
//

import Foundation
import UIKit
import IOS_CommonUtilSPM
import MessageUI
import Photos
import FBSDKShareKit

public enum ShareOption : CaseIterable{
    case PhotosAlbum
    case InstaStory
    case InstaPost
    case FBStory
    case FBPost
    case Mail
    case Socials
    case More

    static func getModel(for Option : Self) -> ShareDirectModel {
        switch Option {
        case .PhotosAlbum:
           return ShareDirectModel(imageName: "photos", title: "Photos", url: "", shareOption: .PhotosAlbum)
            
        case .InstaStory :
            return ShareDirectModel(imageName: "insta", title: "Insta Story", url: "", shareOption:  .InstaStory)
        
        case .InstaPost :
            return ShareDirectModel(imageName: "insta", title: "Instagram", url: "", shareOption: .InstaPost)
        
        case .FBStory :
            return  ShareDirectModel(imageName: "fb", title: "Facebook", url: "", shareOption: .FBStory)
        
        case .FBPost :
            return  ShareDirectModel(imageName: "fb", title: "FB Post", url: "", shareOption: .FBPost)
            
        case .Mail :
            return  ShareDirectModel(imageName: "mail", title: "Mail", url: "", shareOption: .Mail)

        case .Socials:
        return ShareDirectModel(imageName: "wp", title: "Socials", url: "", shareOption: .Socials)

            
        case .More :
            return  ShareDirectModel(imageName: "more", title: "More", url: "", shareOption: .More)
            
        
        }
    }
    

   public static var allImageOptions : [ShareOption] = ShareOption.allCases.filter { (option) -> Bool in
        let model = getModel(for: option)
        if model.shareOption != .FBStory {
            return true
        }
        return false
    }
  public static var allVideoOptions : [ShareOption] = ShareOption.allCases.filter { (option) -> Bool in
        let model = getModel(for: option)
      if model.shareOption != .InstaStory && model.shareOption != .FBPost && model.shareOption != .Socials{
            return true
        }
        return false
    }

}

struct ShareDirectModel: Hashable {
    var image : UIImage
    var title : String
    var shareOption : ShareOption
    
    init(imageName:String , title : String ,url : String , shareOption : ShareOption) {
        self.image = /*ShareOption.getModel(for: shareOption).image *//*Resource.getImage(name: imageName)*/UIImage(named: imageName) ?? UIImage(named: "none")!
        self.title = title
        self.shareOption = shareOption
    }
    
    
    
    func createModel(){
        
    }
    
}


class ShareDirectViewModel: ObservableObject, SharingDelegate{
    
    @Published var isSuccessSharing : Bool = false
    
    func sharer(_ sharer: FBSDKShareKit.Sharing, didCompleteWithResults results: [String : Any]) {
        print("successfully posted to FB")
        DispatchQueue.main.async { [weak self] in
        
            self?.isSuccessSharing = true
        }
    }
    
    func sharer(_ sharer: FBSDKShareKit.Sharing, didFailWithError error: Error) {
        print("error sharing to fb")
    }
    
    func sharerDidCancel(_ sharer: FBSDKShareKit.Sharing) {
        print("cancel posting to fb")
    }
    
    
     
    init(){
        ShareDirect.instaManager.delegate = self
        ShareDirect.mailManager.delegate = self
        ShareDirect.photoAlbumManager.delegate = self
        ShareDirect.socialsManager.delegate = self
        ShareDirect.more.delegate = self
        ShareDirect.fbManager.delegate = self
        initialiseShareOptionArray(for: ShareOption.allVideoOptions)
        
    }
    
    var myShareOptionModels = [ShareDirectModel]()
    
    private func createModel(for Option : ShareOption) -> ShareDirectModel {
        return ShareOption.getModel(for: Option)
    }
    
    
    func initialiseShareOptionArray(for options : [ShareOption]) -> Bool{
        options.forEach { (option) in
           let model = createModel(for: option)
            myShareOptionModels.append(model)
        }
        return true
    }
    
    func getModel(at Index : Int) -> ShareDirectModel {
        return myShareOptionModels[Index]
    }
    
    func getModelCount() -> Int {
        return myShareOptionModels.count
    }
    
    
}

extension ShareDirectViewModel: InstagramDelegate{
    
    public func postFeedback(error didReceived: SwiftError?) {
        //  DispatchQueue.main.async {
        IOSLoader.stopLoader()
        
        if let error = didReceived {
//            Loaf(error.info.message!, sender: self).show()
            let newDrop = Drop(
                title: "Failed_to_share".translate(),
             subtitle: "\(error.info.message!)",
             icon: nil,
             action: .init(icon: nil, handler: {
                 print("Drop tapped")
                 Drops.hideCurrent()
             }),
             position: .top,
             duration: 2.0
         )
         Drops.show(newDrop)
            print("error sharing to Insta")
        }
    }
}

extension ShareDirectViewModel : MailDelegate {
    public func presentMail(_ mailControlller: MFMailComposeViewController, with error: SwiftError?) {
        print("Mail Present - ",error?.info.message ?? "No Error")
        IOSLoader.stopLoader()

        if let error = error {
//            Loaf(error.info.message!, sender: self).show()
            print("error sharing to Mails")
        }else{
            if let vc =  UIApplication.shared.keyWindowPresentedController {
                vc.present( mailControlller , animated: true, completion: nil)
            }
//        present(mailControlller, animated: true,completion: nil)
        }
    }
    
    public func sentMail(_ mailControlller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: SwiftError?) {
    
        print("Mail Finish - ",error?.info.message ?? "No Error")
        mailControlller.dismiss(animated: true) {
            IOSLoader.stopLoader()
            
            switch result{
                
            case .cancelled:
//                self.feedbackError = .failure("Email composition cancelled")
                let newDrop = Drop(
                    title: "Failure",
                    subtitle: "Email composition cancelled",
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
            case .saved:
//                self.feedbackError = .success("Email saved as draft")
                let newDrop = Drop(
                    title: "Success",
                    subtitle: "Email saved as draft",
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
                
            case .sent:
//                self.feedbackError = .success("Email sent successfully")
                let newDrop = Drop(
                    title: "Success",
                    subtitle: "Email sent successfully",
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
                DispatchQueue.main.async { [weak self] in
                
                    self?.isSuccessSharing = true
                }
            case .failed:
//                self.feedbackError = .failure("Email sending failed")
                let newDrop = Drop(
                    title: "Failure",
                    subtitle: "Email sending failed",
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
                
            default:
//                self.feedbackError = .failure("Unknown error occurred")
                let newDrop = Drop(
                    title: "Failure",
                    subtitle: "Unknown error occurred",
                    icon: nil,
                    action: .init(icon: nil, handler: {
                        print("Drop tapped")
                        Drops.hideCurrent()
                    }),
                    position: .top,
                    duration: 2.0
                )
                Drops.show(newDrop)
            }
            
        }
    }
    
    
}

extension ShareDirectViewModel : PhotoLibraryDelegate {
    public func photoLibrary(image: UIImage, photoAsset: PHAsset?, didSaved error: SwiftError?) {
        print("photoAlbum - image - ",error?.info.message ?? "No Error")
                DispatchQueue.main.async {
                    IOSLoader.stopLoader()
                    if error == nil {
                        
                       let newDrop = Drop(
                        title: "Image Saved",
                        subtitle: "Your Image saved successfully",
                        icon: nil,
                        action: .init(icon: nil, handler: {
                            print("Drop tapped")
                            Drops.hideCurrent()
                        }),
                        position: .top,
                        duration: 2.0
                    )
                    Drops.show(newDrop)
                        DispatchQueue.main.async { [weak self] in
                        
                            self?.isSuccessSharing = true
                        }
                            
//                    Loaf(SwiftError.generalMessage(.savingSuccessful).info.message!, state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                    }else{
                        
                        let newDrop = Drop(
                         title: "Saving Failed",
                         subtitle: "Failed to save image to Photos",
                         icon: nil,
                         action: .init(icon: nil, handler: {
                             print("Drop tapped")
                             Drops.hideCurrent()
                         }),
                         position: .top,
                         duration: 2.0
                     )
                     Drops.show(newDrop)
                        
//                        Loaf((error?.info.message)!, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()

                    }
                }

        
    }
    
    public func photoLibrary(video: URL, videoAsset: PHAsset?, didSaved error: SwiftError?) {
      //  print("photoAlbum - image - ",error?.info.message ?? "No Error")
        DispatchQueue.main.async {
            IOSLoader.stopLoader()

        if let error = error {
            
            let newDrop = Drop(
                title: "Saving_Failed".translate(),
                subtitle: "Failed_to_save_video_to_Photos".translate(),
             icon: nil,
             action: .init(icon: nil, handler: {
                 print("Drop tapped")
                 Drops.hideCurrent()
             }),
             position: .top,
             duration: 2.0
         )
         Drops.show(newDrop)
//                Loaf(error.info.message!, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }else{
                let newDrop = Drop(
                    title: "Video_Saved".translate(),
                    subtitle: "Your_Video_saved_successfully".translate(),
                 icon: nil,
                 action: .init(icon: nil, handler: {
                     print("Drop tapped")
                     Drops.hideCurrent()
                 }),
                 position: .top,
                 duration: 2.0
             )
             Drops.show(newDrop)
                DispatchQueue.main.async { [weak self] in
                
                    self?.isSuccessSharing = true
                }
//                Loaf(SwiftError.generalMessage(.savingSuccessful).info.message!, state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
        }
    }

    
    
    public func photoLibrary(permissionError Error: SwiftError) {
        
        print("photoAlbum \(Error)")
            DispatchQueue.main.async {
                IOSLoader.stopLoader()
             
                let goAction = UIAlertAction(title: Error.info.actionLabel, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                     UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                 })
               // let v = Translation.forkey("_Cancel")
                let h = UIAlertAction(title: "Cancel_".translate(), style: .cancel, handler: nil)
                guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                    return
                }
                self.showActionSheet(Error.info.title, message: Error.info.message, alertActions: [goAction,h])
            }

        
    }
    
    public func showActionSheet(_ title: String?, message: String?, alertActions: [UIAlertAction]) {
        showAlert(title, message: message, preferredStyle: .actionSheet, alertActions: alertActions)
    }
    
    public func showAlert(_ title: String?, message: String?, preferredStyle: UIAlertController.Style, alertActions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.topMostViewController() {
                if let popoverController = alertController.popoverPresentationController {
                    popoverController.sourceView = topVC.view
                    popoverController.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                
                for alertAction in alertActions {
                    alertController.addAction(alertAction)
                }
                
                topVC.present(alertController, animated: true, completion: nil)
            }
        }
//        self.present(alertController, animated: true, completion: nil)
    }
    
    

}

extension ShareDirectViewModel : SocialsAndMoreDelegate {
    public func present(socialsVC: UIActivityViewController, error: SwiftError?) {
        DispatchQueue.main.async {
            IOSLoader.stopLoader()
        
                if error == nil {
//        self.present(socialsVC, animated: true, completion: nil)
            }else{
//                Loaf((error?.info.message)!, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
        }
    }
    
    public func present(moreSystemVC: UIActivityViewController, error: SwiftError?) {
        DispatchQueue.main.async {
            IOSLoader.stopLoader()
            if error == nil {
//            self.present(moreSystemVC, animated: true, completion: nil)
            }else{
//                Loaf((error?.info.message)!, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
        }
    }
    
 
}


extension ShareDirectViewModel : facebookDelegate {
    public func presentFBDialog(dialog: ShareDialog) {
        DispatchQueue.main.async { [self] in
            IOSLoader.stopLoader()
            if dialog.canShow {
                dialog.delegate = self
                dialog.fromViewController =  UIApplication.shared.keyWindowPresentedController
                dialog.show()
            }else{
                let newDrop = Drop(
                    title: "App_Not_Installed".translate(),
                 subtitle: "",
                 icon: nil,
                 action: .init(icon: nil, handler: {
                     print("Drop tapped")
                     Drops.hideCurrent()
                 }),
                 position: .top,
                 duration: 2.0
             )
             Drops.show(newDrop)
//                Loaf(SwiftError.applicationMessage(.AppNotInstalled).info.message ?? "", sender: self).show()
            }
        }
        
    }
    

}

//extension UIViewController{
//    public func showActionSheet(_ title: String?, message: String?, alertActions: [UIAlertAction]) {
//        showAlert(title, message: message, preferredStyle: .actionSheet, alertActions: alertActions)
//    }
//    
//    public func showAlert(_ title: String?, message: String?, preferredStyle: UIAlertController.Style, alertActions: [UIAlertAction]) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
//       if let popoverController = alertController.popoverPresentationController {
//            popoverController.sourceView = self.view
//            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//
//        for alertAction in alertActions {
//            alertController.addAction(alertAction)
//        }
//        DispatchQueue.main.async {
//            if let topVC = UIApplication.shared.topMostViewController() {
//                topVC.present(alertController, animated: true, completion: nil)
//            }
//        }
////        self.present(alertController, animated: true, completion: nil)
//    }
//
//}

extension UIApplication {
    func topMostViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let presented = controller?.presentedViewController {
            return topMostViewController(controller: presented)
        }
        if let navigationController = controller as? UINavigationController {
            return topMostViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            return topMostViewController(controller: tabController.selectedViewController)
        }
        return controller
    }
}
