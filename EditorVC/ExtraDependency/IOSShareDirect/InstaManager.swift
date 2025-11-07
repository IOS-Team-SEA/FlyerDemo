//
//  InstaManager.swift
//  IOSShareDirect
//
//  Created by JD on 8/11/20.
//

import Foundation
import Photos
//import IOS_CommonUtil
import IOS_CommonUtilSPM
import UIKit

public protocol InstagramDelegate : AnyObject{
    func postFeedback(error didReceived : SwiftError?)
}
public class InstaManager : NSObject {
    
    enum optionsKey: String {
            case StickerImage = "com.instagram.sharedSticker.stickerImage"
            case bgImage = "com.instagram.sharedSticker.backgroundImage"
            case bgVideo = "com.instagram.sharedSticker.backgroundVideo"
            case bgTopColor = "com.instagram.sharedSticker.backgroundTopColor"
            case bgBottomColor = "com.instagram.sharedSticker.backgroundBottomColor"
            case contentUrl = "com.instagram.sharedSticker.contentURL"
        }
    
    private var instagramStoryUrl : URL!
public  weak  var delegate : InstagramDelegate?
    public static var shared = InstaManager()

    override init() {
        super.init()
        guard let url = URL(string: "instagram-stories://share") else {
           return
            }
        instagramStoryUrl = url
    }
    
    
   
    public func shareToFeed(image:UIImage) {
        write(image: image)
    }
    
    public func shareToFeed(video:URL) {
        write(video: video)
    }
    
    public func shareToFeed(asset:PHAsset) {
        share(asset: asset)
    }
    
    
}

// FEED
extension InstaManager {
    
    private func write(image : UIImage) {
        let photoManager = PhotoLibraryManager()
        photoManager.delegate = self
        photoManager.saveToPhotoLibrary(image)
    }
    
    private func write(video : URL) {
        let photoManager = PhotoLibraryManager()
        photoManager.delegate = self
        photoManager.saveToPhotoLibrary(video)
    }
    
    
    @objc   func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)  {
        if error != nil {
            delegate?.postFeedback(error:SwiftError.applicationMessage(.AppReadContent))
        }

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        if let lastAsset = fetchResult.firstObject {
           share(asset: lastAsset)
             
            }
    }
     @objc  func video(_ video: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                
                delegate?.postFeedback(error:SwiftError.applicationMessage(.AppReadContent))
            }

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)

        if let lastAsset = fetchResult.firstObject {
               share(asset: lastAsset)
               

            }
    }
 
    
    private func share(asset : PHAsset)  {
        let url = URL(string: "instagram://library?LocalIdentifier=\(asset.localIdentifier)")!
        DispatchQueue.main.async { [self] in
            let response = launchApp(url)
             delegate?.postFeedback(error: response)
        }
        
    }
}



// STORIES

extension InstaManager {
    
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
    if let isPosted = isPosted {
        delegate?.postFeedback(error: isPosted)
    }

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
    if let isPosted = isPosted {
        delegate?.postFeedback(error: isPosted)
    }

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
    if let isPosted = isPosted {
        delegate?.postFeedback(error: isPosted)
    }

           return isPosted
       }
    private func post(_ items:[[String : Any]]) -> SwiftError? {
           
            let options: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
            UIPasteboard.general.setItems(items, options: options)
         return launchApp1(instagramStoryUrl)
        }
    
    public func launchApp1(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) -> SwiftError? {
        if UIApplication.shared.canOpenURL(url)
        {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
           return nil
        }
        else
        {
            return SwiftError.applicationMessage(.AppNotInstalled)
        }
    }
        
}


extension InstaManager : PhotoLibraryDelegate {
    public func photoLibrary(image: UIImage, photoAsset: PHAsset?, didSaved error: SwiftError?) {
       // print("photoAlbum - image - ",error?.info.message ?? "No Error")
        share(asset: photoAsset!)

    }
    
    public func photoLibrary(video: URL, videoAsset: PHAsset?, didSaved error: SwiftError?) {
       // print("photoAlbum - image - ",error?.info.message ?? "No Error")
        share(asset: videoAsset!)
    }
    
    public func photoLibrary(permissionError Error: SwiftError) {
       // print("photoAlbum \(Error)")

    }
    
}
