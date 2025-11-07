//
//  FbManager.swift
//  IOSShareDirect
//
//  Created by JD on 8/11/20.
//

import Photos
import Foundation
//import IOS_CommonUtil
import IOS_CommonUtilSPM
import UIKit
import FBSDKShareKit


public protocol facebookDelegate : AnyObject {
    func postFeedback(error didReceived : SwiftError?)
    func presentFBDialog(dialog : ShareDialog)
}


public class FBManager : NSObject {
    
    enum optionsKey: String {
            case StickerImage = "com.facebook.sharedSticker.stickerImage"
            case bgImage = "com.facebook.sharedSticker.backgroundImage"
            case bgVideo = "com.facebook.sharedSticker.backgroundVideo"
            case bgTopColor = "com.facebook.sharedSticker.backgroundTopColor"
            case bgBottomColor = "com.facebook.sharedSticker.backgroundBottomColor"
            case contentUrl = "com.facebook.sharedSticker.contentURL"
        }
    
    private var facebookStoryUrl : URL!
    public weak var delegate : facebookDelegate?
    
    override init() {
        
        guard let url = URL(string: "facebook-stories://share") else {
           return
            }
        facebookStoryUrl = url
    }
    
    public func shareToStory(Image:UIImage, stickerImage:UIImage? = nil, contentURL:String? = nil) -> SwiftError? {
             var items:[[String : Any]] = [[:]]
             //Background Image
             let bgData = Image.pngData()!
             items[0].updateValue(bgData, forKey: optionsKey.bgImage.rawValue)
             //Sticker Image
             if stickerImage != nil {
                 let stickerData = stickerImage!.pngData()!
                 items[0].updateValue(stickerData, forKey: optionsKey.StickerImage.rawValue)
             }
             //Content URL
             if contentURL != nil {
                 items[0].updateValue(contentURL as Any, forKey: optionsKey.contentUrl.rawValue)
             }
             let isPosted = post(items)
             return isPosted
         }
    
    public func shareToStory(VideoUrl:URL, stickerImage:UIImage? = nil, contentURL:String? = nil) -> SwiftError? {
             var items:[[String : Any]] = [[:]]
             //Background Video
             var videoData:Data?
             do {
                 try videoData = Data(contentsOf: VideoUrl)
             } catch {
                 print("Cannot open \(VideoUrl)")
                 return nil
             }
             items[0].updateValue(videoData as Any, forKey: optionsKey.bgVideo.rawValue)
             //Sticker Image
             if stickerImage != nil {
                 let stickerData = stickerImage!.pngData()!
                 items[0].updateValue(stickerData, forKey: optionsKey.StickerImage.rawValue)
             }
             //Content URL
             if contentURL != nil {
                 items[0].updateValue(contentURL as Any, forKey: optionsKey.contentUrl.rawValue)
             }
             let isPosted = post(items)
             return isPosted
         }
    
    public func shareToStory(stickerImage:UIImage, bgTop:String = "#000000", bgBottom:String = "#000000", contentURL:String? = nil) -> SwiftError? {
            var items:[[String : Any]] = [[:]]
            //Sticker Image
            let stickerData = stickerImage.pngData()!
            items[0].updateValue(stickerData, forKey: optionsKey.StickerImage.rawValue)
            //Background Color
            items[0].updateValue(bgTop, forKey: optionsKey.bgTopColor.rawValue)
            items[0].updateValue(bgBottom, forKey: optionsKey.bgBottomColor.rawValue)
            //Content URL
            if contentURL != nil {
                items[0].updateValue(contentURL as Any, forKey: optionsKey.contentUrl.rawValue)
            }
            let isPosted = post(items)
            return isPosted
        }
    
     private func post(_ items:[[String : Any]]) -> SwiftError? {
            
             let options: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
             UIPasteboard.general.setItems(items, options: options)
          return launchApp(facebookStoryUrl)
         }
    
}

extension FBManager : SharingDelegate {
    
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("FB SUCESS")
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Error")
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        print("cancel")
    }
    
    public func shareToFeed(image:UIImage) {
        let photo = SharePhoto(image: image, isUserGenerated: true)
        shareImage(photo: photo)
    }
    public func shareToFeed(imageURL:URL) {
        let photo = SharePhoto(imageURL: imageURL, isUserGenerated: true)
        shareImage(photo: photo)
    }
    
    public func shareToFeed(imageAsset : PHAsset) {
        let photo = SharePhoto(photoAsset: imageAsset, isUserGenerated: true)
        shareImage(photo: photo)
    }
    
    public  func shareImage(photo:SharePhoto) {
        let photoContent = SharePhotoContent()
        photoContent.photos = [photo]
        
        let dialog = createFBDialog(content: photoContent)
        delegate?.presentFBDialog(dialog: dialog )
    }
    public  func shareVideo(video:ShareVideo) {
        let content = ShareVideoContent()
        content.video = video
        
        let dialog = createFBDialog(content: content)
        delegate?.presentFBDialog(dialog: dialog )
    }
    
  public  func shareToFeed(VideoAsset : PHAsset) {
        let video = ShareVideo(videoAsset: VideoAsset)
    
    shareVideo(video: video)
    }
    
    
   public func shareToFeed(videoURL:URL) {
    
      saveVideo(url: videoURL)
                        
    }

    public  func shareToFeed(videoData : Data) {
        let video = ShareVideo(data: videoData)
        shareVideo(video: video)
    }
    
    
    
    
    func messagner(image:UIImage){
        
    }
    func createFBDialog(content:SharingContent)->ShareDialog {
        let dialog = ShareDialog(viewController: nil, content: content, delegate: self)
//        dialog.delegate = self
//        dialog.shareContent = content
        dialog.mode = .automatic
        return dialog
    }
    
  
    
//
    func saveVideo(url:URL){
        
        let photoManager = PhotoLibraryManager()
        photoManager.delegate = self
        photoManager.saveToPhotoLibrary(url)
    
    }
    
    
}
extension FBManager : PhotoLibraryDelegate {
    public func photoLibrary(image: UIImage, photoAsset: PHAsset?, didSaved error: SwiftError?) {
        print("photoAlbum - image - ",error?.info.message ?? "No Error")
        if let asset = photoAsset {
            shareToFeed(imageAsset: asset)
        }
    }
    
    public func photoLibrary(video: URL, videoAsset: PHAsset?, didSaved error: SwiftError?) {
        print("photoAlbum - image - ",error?.info.message ?? "No Error")
        if let asset = videoAsset {
            shareToFeed(VideoAsset: asset)
        }
        
    }
    
    public func photoLibrary(permissionError Error: SwiftError) {
        print("photoAlbum \(Error)")

    }
    
}
