//
//  PhotoAlbumManager.swift
//  IOSShareDirect
//
//  Created by JD on 8/11/20.
//



import PhotosUI
//import IOS_CommonUtil
import IOS_CommonUtilSPM

public protocol PhotoLibraryDelegate : AnyObject {
      func photoLibrary(image : UIImage , photoAsset : PHAsset?, didSaved error : SwiftError?)
      func photoLibrary(video : URL , videoAsset : PHAsset? , didSaved error : SwiftError?)
      func photoLibrary(permissionError Error : SwiftError)
}


public class PhotoLibraryManager : NSObject {
    
    typealias assetIdentifier = String
    
    public static var shared = PhotoLibraryManager()
    
    
    public weak var delegate : PhotoLibraryDelegate?
    
    public override init() {
        super.init()
    }
    
    
   
    func saveVideo(videoURL: URL) {
        
//        self.checkAuthorizationWithHandler { (success) in
//            if success, self.assetCollection != nil {
//                var assetPlaceHolder: PHObjectPlaceholder?
//                PHPhotoLibrary.shared().performChanges({
//
//                    if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL) {
//                       assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
//                        if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
//                            let enumeration: NSArray = [assetPlaceHolder!]
//                            albumChangeRequest.addAssets(enumeration)
//                        }
//
//                    }
//
//                }, completionHandler:  { [self] (success, error) in
//                    if success {
//                        print("Successfully saved video to Camera Roll.")
//                      guard let placeholder = assetPlaceHolder else {
//                            return
//                        }
//                        let fetchOptions = PHFetchOptions()
//                        let fetchResult:PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: fetchOptions)
//
//                        if let assetph = fetchResult.firstObject {
//                              let options: PHVideoRequestOptions = PHVideoRequestOptions()
//                                                           options.version = .original
//                            PHImageManager.default().requestAVAsset(forVideo: assetph, options: options, resultHandler: { [self](asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
//                                                               if let urlAsset = asset as? AVURLAsset {
//                                                                   let localVideoUrl: URL = urlAsset.url as URL
//                                                                self.delegate?.photoAlbum(video: localVideoUrl, videoAsset: assetph, didSaved: nil)
//                                                               } else {
//                                                                self.delegate?.photoAlbum(video: videoURL, videoAsset: assetph, didSaved:SwiftError.float("Saving Failed", message: "Error writing video to library:"))
//                                                               }
//                                                           })
//                        }
//
//                    } else {
//                        print("Error writing to movie library: \(error!.localizedDescription)")
//                        self.delegate?.photoAlbum(video: videoURL, videoAsset: nil, didSaved: SwiftError.float("Saving Failed", message: "Error writing video to library:"))
//
//                    }
//                })
//
//
//            }
//        }
        
    }
    
    


}


extension PhotoLibraryManager {
    
   

    public  func saveToPhotoLibrary(_ image : UIImage , isJpeg : Bool = false ) {
        
        Permissions.defaults.askForPhotoLibraryStatus { [self] (status, error) in
            
            switch status {
            case .authorized , .limited :
                OnSaveToCameraRoll(image: image , isJpeg: isJpeg)
            case .denied :
                permissionsDenied()
                
            case .notDetermined :
                permissionsDenied()
                
            case .restricted :
            permissionsRestricted()
            
            @unknown default:
                fatalError()
            }
        }
        
    }
    
  public  func saveToPhotoLibrary(_ video : URL) {
        
        Permissions.defaults.askForPhotoLibraryStatus { [self] (status, error) in
            
            switch status {
            case .authorized , .limited :
//                OnSaveToCameraRoll(video: video)
                OnSaveToCameraRoll(videoURL: video)
            case .denied :
                permissionsDenied()
                
            case .notDetermined :
                permissionsDenied()
                
            case .restricted :
            permissionsRestricted()
            @unknown default:
                fatalError()
            
            }
        }
        
    }
    
  
}



extension PhotoLibraryManager {
    
    private func OnSaveToCameraRollNoAlbum(video:URL) {
        var identifier : String = ""
        PHPhotoLibrary.shared().performChanges {
            let req = PHAssetCreationRequest.forAsset()
            let holder =  req.placeholderForCreatedAsset
            identifier = holder?.localIdentifier ?? ""
            req.addResource(with: .video, fileURL: video, options: nil)
            
        } completionHandler: { [self] success, error in
            
            if error != nil || success != true{
                let er = SwiftError.generalMessage(.savingFailed)
                delegate?.photoLibrary(video: video, videoAsset: nil, didSaved: er)
                return
            }
            
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject {
                let options: PHVideoRequestOptions = PHVideoRequestOptions()
                    options.version = .original
                
                PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: { [self](assetav: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                        if let urlAsset = assetav as? AVURLAsset {
                            let localVideoUrl: URL = urlAsset.url
                            delegate?.photoLibrary(video: localVideoUrl, videoAsset: asset, didSaved: nil)
                            
                        }
                
                })
            }
            
        }
            

    }
    
    private func OnSaveToCameraRoll(videoURL: URL) {
        let albumName = "Auto CutPaste"
        
        // Check if the album exists
        var album: PHAssetCollection?
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if collections.count == 0 {
            // Album doesn't exist, create it
            createAlbum(named: albumName) { createdAlbum in
                if let createdAlbum = createdAlbum {
                    self.saveVideoToAlbum(videoURL: videoURL, album: createdAlbum)
                } else {
                    // Handle album creation failure
                    self.OnSaveToCameraRollNoAlbum(video: videoURL)
                    print("Failed to create album")
                }
            }
        } else {
            album = collections.firstObject
            if let album = album {
                // If the album exists, save video to it
                saveVideoToAlbum(videoURL: videoURL, album: album)
            }
        }
    }

    private func createAlbum(named albumName: String, completion: @escaping (PHAssetCollection?) -> Void) {
        
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            let placeholder = creationRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, error in
            if success {
                // Fetch the newly created album
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
                let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                completion(collections.firstObject)
            } else {
                completion(nil)
            }
        })
    }
    
    private func saveVideoToAlbum(videoURL: URL, album: PHAssetCollection) {
        var identifier : String = ""
        PHPhotoLibrary.shared().performChanges({
            // Create asset from video URL
            let creationRequest = PHAssetCreationRequest.forAsset()
            let holder =  creationRequest.placeholderForCreatedAsset
            identifier = holder?.localIdentifier ?? ""
            creationRequest.addResource(with: .video, fileURL: videoURL, options: nil)
            
            // Add video to the specific album
            if let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) {
                let assetPlaceholder = creationRequest.placeholderForCreatedAsset
                albumChangeRequest.addAssets([assetPlaceholder] as NSArray)
            }
        }, completionHandler: { [self] success, error in
            if error != nil || success != true{
                let er = SwiftError.generalMessage(.savingFailed)
                delegate?.photoLibrary(video: videoURL, videoAsset: nil, didSaved: er)
                return
            }
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject {
                let options: PHVideoRequestOptions = PHVideoRequestOptions()
                    options.version = .original
                
                PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: { [self](assetav: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                        if let urlAsset = assetav as? AVURLAsset {
                            let localVideoUrl: URL = urlAsset.url
                            delegate?.photoLibrary(video: localVideoUrl, videoAsset: asset, didSaved: nil)
                            
                        }
                
                })
            }
        })
    }
    
  private  func OnSaveToCameraRollNoAlbum(image:UIImage) {
        var identifier : String = ""
    if let data = image.pngData() {

        PHPhotoLibrary.shared().performChanges {
            
            let req = PHAssetCreationRequest.forAsset()
            
            let holder =  req.placeholderForCreatedAsset
            identifier = holder?.localIdentifier ?? ""
            req.addResource(with: .photo, data: data, options: nil)
            
            
            
        } completionHandler: { [self] success, err in
            
            if err != nil || success != true{
                let er = SwiftError.generalMessage(.savingFailed)
                delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)
                return
            }
            
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject {
                delegate?.photoLibrary(image: image, photoAsset: asset, didSaved: nil)
                return
            }
            
            let er = SwiftError.generalMessage(.savingFailed)
            delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)
        }
    }else{
        let er = SwiftError.generalMessage(.savingFailed)
        delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)

    }
    
    }
    
    private  func OnSaveToCameraRoll(image:UIImage , isJpeg : Bool = false ) {
        let albumName = "Ace LogoMaker"
        // Check if the album exists
        var album: PHAssetCollection?
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if collections.count == 0 {
            // Album doesn't exist, create it
            createAlbum(named: albumName) { createdAlbum in
                if let createdAlbum = createdAlbum {
                    self.savePhotoToAlbum(image: image, album: createdAlbum , isJpeg : isJpeg )
                } else {
                    // Handle album creation failure
                    self.OnSaveToCameraRollNoAlbum(image: image)
                    print("Failed to create album")
                }
            }
        } else {
            album = collections.firstObject
            if let album = album {
                // If the album exists, save video to it
                self.savePhotoToAlbum(image: image, album: album , isJpeg : isJpeg )
            }
        }
    }
    
    func savePhotoToAlbum(image: UIImage, album: PHAssetCollection , isJpeg : Bool = false){
        var identifier : String = ""
      
        if isJpeg {
            if let data = image.jpegData(compressionQuality: 1.0) {
                PHPhotoLibrary.shared().performChanges({
                    // Create asset from video URL
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    let holder =  creationRequest.placeholderForCreatedAsset
                    identifier = holder?.localIdentifier ?? ""
                    creationRequest.addResource(with: .photo, data: data, options: nil)
                    
                    // Add video to the specific album
                    if let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) {
                        let assetPlaceholder = creationRequest.placeholderForCreatedAsset
                        albumChangeRequest.addAssets([assetPlaceholder] as NSArray)
                    }
                }, completionHandler: { [self] success, err in
                    if err != nil || success != true{
                        let er = SwiftError.generalMessage(.savingFailed)
                        delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)
                        return
                    }
                    
                    if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject {
                        delegate?.photoLibrary(image: image, photoAsset: asset, didSaved: nil)
                        return
                    }
                    
                    let er = SwiftError.generalMessage(.savingFailed)
                    delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)
                })
            }else{
                let er = SwiftError.generalMessage(.savingFailed)
                delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)
                
            }
            return
        } else  if let data = image.pngData() {
            PHPhotoLibrary.shared().performChanges({
                // Create asset from video URL
                let creationRequest = PHAssetCreationRequest.forAsset()
                let holder =  creationRequest.placeholderForCreatedAsset
                identifier = holder?.localIdentifier ?? ""
                creationRequest.addResource(with: .photo, data: data, options: nil)
                
                // Add video to the specific album
                if let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) {
                    let assetPlaceholder = creationRequest.placeholderForCreatedAsset
                    albumChangeRequest.addAssets([assetPlaceholder] as NSArray)
                }
            }, completionHandler: { [self] success, err in
                if err != nil || success != true{
                    let er = SwiftError.generalMessage(.savingFailed)
                    delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)
                    return
                }
                
                if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject {
                    delegate?.photoLibrary(image: image, photoAsset: asset, didSaved: nil)
                    return
                }
                
                let er = SwiftError.generalMessage(.savingFailed)
                delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)
            })
        }else{
            let er = SwiftError.generalMessage(.savingFailed)
            delegate?.photoLibrary(image: image, photoAsset: nil, didSaved: er)
            
        }
        
    }
    
    func permissionsDenied(){
        delegate?.photoLibrary(permissionError: .permissionMessage(.photoAccessDenied))
    }
    func permissionsNotDetermined(){
        
    }
    func permissionsRestricted(){
        delegate?.photoLibrary(permissionError: .permissionMessage(.photoAccessDenied))
        
    }
    
    
    
    
    
    
}
