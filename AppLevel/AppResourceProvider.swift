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

//DBManager.shared.setDBLogger(logger: AppDBLogger, engineConfig: )

//final class AppDependencyResolver: DependencyResolverProtocol {
//
//    private var container: [String: Any] = [:]
//
//    init() {
//        // Register your app-level dependencies
//        register(PipelineLibrary(), for: PipelineLibrary.self)
//    }
//
//    func register<T>(_ instance: T, for type: T.Type) {
//        let key = String(describing: type)
//        container[key] = instance
//    }
//
//    func resolve<T>(_ type: T.Type) -> T? {
//        let key = String(describing: type)
//        return container[key] as? T
//    }
//
//    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T? {
//        // optionally handle argument-based resolution
//        return resolve(type)
//    }
//
//    func resolve<T>(id: String, type: T.Type, argument: Any?) -> T? {
//        return container[id] as? T
//    }
//    
//    
//    
//}

/*
 
 SceneConfiguration
 PackageLogger
 TextureResourceProvider
 ViewsProvider
 ViewManagerConfiguration
 DBLogger
 EngineConfiguration
 LayersConfiguration
 TimelineConfiguration
 
 */
