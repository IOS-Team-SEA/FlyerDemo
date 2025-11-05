//
//  Image.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 18/07/23.
//

import Foundation
import UIKit

enum SOURCETYPE:String{
    case BUNDLE = "BUNDLE"
    case SERVER = "SERVER"
    case DOCUMENT = "DOCUMENT"
    
}

struct ReplaceModel :  Equatable{
    static func == (lhs: ReplaceModel, rhs: ReplaceModel) -> Bool {
        if lhs.modelID != rhs.modelID {
            return true
        }
        if lhs.imageModel != rhs.imageModel {
            return true
        }
        
      
        return false
        
    }
    
    let modelID : Int
    var imageModel : ImageModel
    var baseFrame : Frame
}
struct DBImageModel:DBImageProtocol{
    var imageID: Int = 0
    var imageType: String = ""
    var serverPath: String = ""
    var localPath: String = ""
    var resID: String = ""
    var isEncrypted: Int = 0
    var cropX: Double = 0.0
    var cropY: Double = 0.0
    var cropW: Double = 1.0
    var cropH: Double = 1.0
    var cropStyle: Int = 1
    var tileMultiple: Double = 1.0
    var colorInfo: String = ""
    var imageWidth: Double = 300
    var imageHeight: Double = 300
    var templateID : Int = -1
    var sourceTYPE : String = "BUNDLE"
    
    static func createDefaultOverlayModel(imageModel:ImageModel, templateID: Int)->DBImageModel{
        var model = DBImageModel()
        model.imageType = "OVERLAY"
        model.serverPath = imageModel.serverPath
        model.localPath = imageModel.localPath
        model.cropX = imageModel.cropRect.minX
        model.cropY = imageModel.cropRect.minY
        model.cropW = imageModel.cropRect.width
        model.cropH = imageModel.cropRect.height
        model.tileMultiple = imageModel.tileMultiple
        model.sourceTYPE = imageModel.sourceType.rawValue
        model.templateID = templateID
        return model
    }
    
    
}
struct ImageModel: Equatable{
    var imageType : ImageSourceType
    var serverPath: String
    var localPath : String
    var cropRect : CGRect
//    var cropStyle : Double
    var sourceType : SOURCETYPE
    var tileMultiple : Double
    var cropType: ImageCropperType
    var imageWidth : Double
    var imageHeight : Double
    
    
    func getImage() async->UIImage?{
        if sourceType == .BUNDLE{
            let imageName = localPath.components(separatedBy: "/").last!
         
                if let savedImage = UIImage(named: imageName) {
                    return savedImage
                }
                else{
                    print("Error loading image from documents directory")
                    return nil
                }
            
        }else if sourceType == .DOCUMENT{
            
            let imageName = localPath.components(separatedBy: "/").last!
            do{
                if let pngData = AppFileManager.shared.assets?.readDataFromFile(fileName: imageName){
                    return UIImage(data: pngData)
                }else if let pngDataLocal = AppFileManager.shared.localAssets?.readDataFromFile(fileName: imageName){
                    return UIImage(data: pngDataLocal)
                }
                
//                if let savedImage = try ImageDownloadManager.loadImageFromDocumentsDirectory(filename: "Assets/"+imageName+".png") {
//                    return savedImage
//                }
            }catch{
                    print("Error loading image from documents directory")
                    return nil
                }
            
      
        }else{
            let imageName = serverPath.components(separatedBy: "Assets/").last!
            do{
                if let savedImage = try ImageDownloadManager.loadImageFromDocumentsDirectory(filename: imageName, directory: AppFileManager.shared.assets!) {
                return savedImage
            }
            
            else {
                do{
                  
                    if let serverImage = try await NetworkManager.shared.fetchImage(imageURL: imageName){
                        let resizedImage = resizeImage(image: serverImage, targetSize: CGSize(width: 3000, height: 3000))
                        if let imageData = serverImage.pngData() {
                            try ImageDownloadManager.saveImageToDocumentsDirectory(imageData: imageData, filename: imageName, directory: AppFileManager.shared.assets!)
                        }
                        return resizedImage
                    }
                }
                catch{
                    print("image is not downloaded for server Path")
                }
            }
        }
            catch{
                print("image not found on server")
            }
        
        
        }
        return nil
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.mySize
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
//    func getDBImageModel()->DBImageModel{
//        return DBImageModel(imageID: -1,imageType: imageType.rawValue,serverPath: serverPath,localPath: localPath,cropX: cropRect.minX,cropY: <#T##Double#>)
//    }
}
