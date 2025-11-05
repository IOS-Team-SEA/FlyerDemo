//
//  AppResourceProvider.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import Foundation
import UIKit

//final class AppResourceProvider: TextureResourceProvider {
//    func loadImageFromBundle(named: String) async -> UIImage? {
//        return UIImage(named: named)
//    }
//
//    func loadImageFromServer(url: String) async throws -> UIImage? {
//        return try await NetworkManager.shared.fetchImage(imageURL: url)
//    }
//
//    func loadImageFromLocal(named: String) async -> UIImage? {
//        if let cgImage = await AppFileManager.shared.assets?.readDataFromFileQL(fileName: named, maxSize: CGSize(width: 500, height: 500)) {
//            return UIImage(cgImage: cgImage)
//        }
//        return nil
//    }
//
//    func saveImageToDocuments(imageData: Data, filename: String) throws {
//        try ImageDownloadManager.saveImageToDocumentsDirectory(imageData: imageData, filename: filename, directory: AppFileManager.shared.assets!)
//    }
//
//    func defaultPlaceholderImage() -> UIImage? {
//        return AppStyle.defaultImage
//    }
//}

//final class AppLogger: LoggerProtocol {
//    func logInfo(_ message: String) { print("ℹ️ \(message)") }
//    func logError(_ message: String) { print("❌ \(message)") }
//    func logVerbose(_ message: String) { print("🔍 \(message)") }
//}


//struct EditControlBar: View, ControlBarProtocol { ... }
//struct MuteControl: View, MuteControlProtocol { ... }

//let viewManager = ViewManager()
//viewManager.addControlBar(EditControlBar())
//viewManager.setMuteControl(MuteControl())

//DBManager.shared.setDBLogger(logger: AppDBLogger)


/*
 
 SceneConfiguration
 PackageLogger
 TextureResourceProvider
 ViewsProvider
 ViewManagerConfiguration
 DBLogger
 
 */
