//
//  ImageDownloadManager.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 07/03/24.
//

import Foundation
import UIKit

enum SaveImageError: Error {
    case documentsDirectoryNotFound
}
enum LoadImageError: Error {
    case documentsDirectoryNotFound
}

struct ImageDownloadManager{
    
    // This is the utility function that provide file name from the URL.
    static func getFilenameFromURL(urlString: String) -> String? {
          guard let url = URL(string: urlString) else { return nil }
          return url.lastPathComponent
      }
    
    //Load from the local directory using the file name.
    static func loadImageFromDocumentsDirectory(filename: String, directory : Folder) throws -> UIImage? {
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            throw LoadImageError.documentsDirectoryNotFound
//        }
        var  directory : Folder? = directory//AppFileManager.shared.imageThumbnails
//        if folderName == "Assets"{
//            directory = AppFileManager.shared.assets
//        }
//        else if folderName == "LocalAssets"{
//            directory = AppFileManager.shared.localAssets
//        }
//        else if folderName == "MyDesigns"{
//            directory = AppFileManager.shared.myDesigns
//        }
//        
        if let directory = directory{
            if let data = directory.readDataFromFile(fileName: filename){
                return UIImage(data : data)
            }
            return nil
        }
        return nil
//        let fileURL = //documentsDirectory.appendingPathComponent(filename)
//        if let imageData = FileManager.default.contents(atPath: fileURL.path) {
//            return UIImage(data: imageData)//try! UIGraphicsRenderer.renderImagesAt(urls: [fileURL as NSURL], size: CGSize(width: 700, height: 700), scale: 1)
//        } else {
//            return nil
//        }
    }
    
    static func loadImageDataFromTempDirectory(filename: String, directory : Folder) throws -> Data? {
        var tempDirectory = directory.url//AppFileManager.shared.templateThumbnails?.url
//        if folderName == "TemplateThumbnails"
//        {
//            tempDirectory = AppFileManager.shared.templateThumbnails?.url
//        }
//        else if folderName == "TemplateCategoryThumbnails"{
//            tempDirectory = AppFileManager.shared.templateCategoryThumbnails?.url
//        }
//        tempDirectory = AppFileManager.shared//FileManager.default.temporaryDirectory
        guard let tempDirectory = tempDirectory else {
            throw LoadImageError.documentsDirectoryNotFound
        }
        let fileURL = tempDirectory.appendingPathComponent(filename)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return try Data(contentsOf: fileURL)
        } else {
            return nil
        }
    }
    
    static func loadFontFromDocumentsDirectory(fontName: String) -> String? {
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return nil
//        }
        if let directory = AppFileManager.shared.fontAssets?.url{
            let fileUrl = directory.appendingPathComponent("FontAssets/\(fontName)")
            return fileUrl.absoluteString
        }
        return nil
        
//        let fileURL = documentsDirectory.appendingPathComponent("FontAssets/\(fontName)")
//        return fileURL.absoluteString
        
    }
    
    //Save the Image in the directory using file name.
    static func saveImageToDocumentsDirectory(imageData: Data, filename: String, directory : Folder) throws {
        var documentsDirectory = directory.url//AppFileManager.shared.templateThumbnails?.url
//        if folderName == "Assets"
//        {
//            documentsDirectory = AppFileManager.shared.assets?.url
//        }
//        else if folderName == "MyDesigns"{
//            documentsDirectory = AppFileManager.shared.myDesigns?.url
//        }
//        else if folderName == "LocalAssets"{
//            documentsDirectory = AppFileManager.shared.localAssets?.url
//        }
//        tempDirectory = AppFileManager.shared//FileManager.default.temporaryDirectory
        guard let documentsDirectory = documentsDirectory else {
            throw SaveImageError.documentsDirectoryNotFound
        }
        
//          guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//              throw SaveImageError.documentsDirectoryNotFound
//          }
        let newImageName = filename.replacingOccurrences(of: "Assets/", with: "")
          let fileURL = documentsDirectory.appendingPathComponent(newImageName)
          try imageData.write(to: fileURL)
      }
    
    static func saveImageToTempDirectory(imageData: Data, filename: String, directory : Folder) throws {
        var tempDirectory = directory.url //AppFileManager.shared.templateThumbnails?.url
//        if folderName == "TemplateThumbnails"
//        {
//            tempDirectory = AppFileManager.shared.templateThumbnails?.url
//        }
//        else if folderName == "TemplateCategoryThumbnails"{
//            tempDirectory = AppFileManager.shared.templateCategoryThumbnails?.url
//        }
//        tempDirectory = AppFileManager.shared//FileManager.default.temporaryDirectory
        guard let tempDirectory = tempDirectory else {
            throw SaveImageError.documentsDirectoryNotFound
        }
        
//        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(filename)
        
        try imageData.write(to: fileURL)
    }
}










public extension UIGraphicsRenderer {
    static func renderImagesAt(urls: [NSURL], size: CGSize, scale: CGFloat = 1) throws -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let options: [NSString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width * scale, size.height * scale),
            kCGImageSourceCreateThumbnailFromImageAlways: true
        ]
        
        let thumbnails = try urls.map { url -> CGImage in
            guard let imageSource = CGImageSourceCreateWithURL(url, nil) else { throw RenderingError.unableToCreateImageSource }
            
            guard let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {  throw RenderingError.unableToCreateThumbnail }
            return scaledImage
        }
        
        // Translate Y-axis down because cg images are flipped and it falls out of the frame (see bellow)
        let rect = CGRect(x: 0,
                          y: -size.height,
                          width: size.width,
                          height: size.height)
        
        let resizedImage = renderer.image { ctx in
            
            let context = ctx.cgContext
            context.scaleBy(x: 1, y: -1) //Flip it ( cg y-axis is flipped)
            
            for image in thumbnails {
                context.draw(image, in: rect)
            }
        }
        
        return resizedImage
    }
}


enum RenderingError : Error{
        case unableToCreateImageSource
        case unableToCreateThumbnail
    }


extension ImageDownloadManager {
    static func saveOrUpdateImageToDocumentsDirectory(imageData: Data, filename: String, directory : Folder) throws {
//        let fileManager = FileManager.default
//        let directory = try documentsDirectory() 
//        let filePath = directory.appendingPathComponent(filename)
//        
//        // Remove existing file if it exists
//        if fileManager.fileExists(atPath: filePath.path) {
//            try fileManager.removeItem(at: filePath)
//        }
//        
//        // Save the new image
//        try imageData.write(to: filePath)
        
        guard let filePath = directory.url?.appendingPathComponent(filename) else {
            throw SaveImageError.documentsDirectoryNotFound
        }
        
        // Remove existing file if it exists
        if FileManager.default.fileExists(atPath: filePath.path) {
            try FileManager.default.removeItem(at: filePath)
        }
        
        // Save the new image
        try imageData.write(to: filePath)
    }
    
    static func saveOrUpdateImageToTempDirectory(imageData: Data, filename: String, directory: Folder) throws {
        guard let filePath = directory.url?.appendingPathComponent(filename) else {
            throw SaveImageError.documentsDirectoryNotFound
        }
        
        // Remove existing file if it exists
        if FileManager.default.fileExists(atPath: filePath.path) {
            try FileManager.default.removeItem(at: filePath)
        }
        
        // Save the new image
        try imageData.write(to: filePath)
    }
    
//    static func saveOrUpdateImageToTempDirectory(imageData: Data, filename: String, directory : Folder) throws {
//        let fileManager = FileManager.default
//        let tempDirectory = fileManager.temporaryDirectory
//        let filePath = tempDirectory.appendingPathComponent(filename)
//        
//        // Remove existing file if it exists
//        if fileManager.fileExists(atPath: filePath.path) {
//            try fileManager.removeItem(at: filePath)
//        }
//        
//        // Save the new image
//        try imageData.write(to: filePath)
//    }
    
    static func documentsDirectory() throws -> URL {
        
        if let url = AppFileManager.shared.imageThumbnails?.url{
            return url
        }
        
        throw NSError(domain: "ImageDownloadManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not locate documents directory"])
        
//        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            throw NSError(domain: "ImageDownloadManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not locate documents directory"])
//        }
//        return directory
    }
}
