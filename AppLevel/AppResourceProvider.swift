//
//  AppResourceProvider.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import Foundation
import UIKit
import IOS_CommonEditor
import SwiftUICore
import IOS_CommonUtilSPM

final class AppResourceProvider: TextureResourceProvider {
    func getDefaultImage() -> UIImage? {
        AppStyle.defaultImage
    }
    
    func loadImageUsingQL(fileURL: URL, maxSize: CGSize) async -> CGImage? {
        await FlyerDemo.loadImageUsingQL(fileURL: fileURL, maxSize: maxSize)
    }
    
    func readDataFromFileQLFromDocument(fileName: String, maxSize: CGSize) async -> CGImage? {
        await AppFileManager.shared.documentFolder.readDataFromFileQL(fileName: fileName, maxSize: maxSize)
    }
    
    func readDataFromFileQLFromAssets(fileName: String, maxSize: CGSize) async -> CGImage? {
        await AppFileManager.shared.assets?.readDataFromFileQL(fileName: fileName, maxSize: maxSize)
    }
    
    func readDataFromFileQLFromLocalAssets(fileName: String, maxSize: CGSize) async -> CGImage? {
        await AppFileManager.shared.localAssets?.readDataFromFileQL(fileName: fileName, maxSize: maxSize )
    }
    
    func fetchImage(imageURL: String) async throws -> UIImage? {
        try await NetworkManager.shared.fetchImage(imageURL: imageURL)
    }
    
    func saveImageToDocumentsDirectory(imageData: Data, filename: String, directory: URL) throws {
        try ImageDownloadManager.saveImageToDocumentsDirectory(imageData: imageData, filename: filename, directory: AppFileManager.shared.assets!)
    }
    
    func getAssetsPath() -> URL? {
        return AppFileManager.shared.assets?.url
    }

}

final class AppPackageLogger: PackageLogger{
    func logInfo(_ message: String) {
        FlyerDemo.logInfo(message)
    }
    
    func logError(_ message: String) {
        FlyerDemo.logError(message)
    }
    
    func logVerbose(_ message: String) {
        FlyerDemo.logVerbose(message)
    }
    
    func printLog(_ message: String) {
        FlyerDemo.printLog(message)
    }
    
    func getBaseSize() -> CGSize {
        return BASE_SIZE
    }
    
    func logErrorJD(tag: IOS_CommonEditor.ErrorTags, _ message: String) {
        FlyerDemo.logErrorJD(tag: tag, message)
    }
    
    func logWarning(_ message: String) {
        FlyerDemo.logWarning(message)
    }
    
}

final class AppSceneConfigure: SceneConfiguration{
    var accentColor: UIColor = AppStyle.accentColorUIKit
    
    var contentScaleFactor: CGFloat = UIStateManager.shared.contentscaleFactor
    
    
}

final class AppViewManagerConfigure: ViewManagerConfiguration{
    var isPremium: Bool = UIStateManager.shared.isPremium
    
    var accentColorSwiftUI: Color = AppStyle.accentColor_SwiftUI
    
    var accentColorUIKit: UIColor = AppStyle.accentColorUIKit
    
    var TextDragHandlefillColor: UIColor = AppStyle.accentColorUIKit
    
    var TextDragHandleStrokeColor: UIColor = AppStyle.accentColorUIKit
    
}

final class AppDBLogger: DBLogger{
    func printLog(_ message: String) {
        FlyerDemo.printLog(message)
    }
    
    func logInfo(_ message: String) {
        FlyerDemo.logInfo(message)
    }
    
    func logError(_ message: String) {
        FlyerDemo.logError(message)
    }
    
    func getDBPath() -> URL? {
        return AppFileManager.shared.dataBase?.url
    }
    
    func getDBName() -> String {
        return "DESIGN_DB.db"
    }
    
    func getBaseSize() -> CGSize {
        return BASE_SIZE
    }
    
    func getThumnailPath() -> URL? {
        AppFileManager.shared.templateThumbnails?.url
    }
    
    func getMyDesignsPath() -> URL? {
        AppFileManager.shared.myDesigns?.url
    }
    
    func documentsDirectoryNotFound() -> any Error {
        SaveImageError.documentsDirectoryNotFound
    }
    
    func fetchImage(imageURL: String) async throws -> UIImage? {
        try await NetworkManager.shared.fetchImage(imageURL: imageURL)
    }
    
    func saveImageToDocumentsDirectory(imageData: Data, filename: String, directory: URL) throws {
        try ImageDownloadManager.saveImageToDocumentsDirectory(imageData: imageData, filename: filename, directory: AppFileManager.shared.assets!)
    }
    
    func getAssetPath() -> URL? {
        return AppFileManager.shared.assets?.url
    }
    
    
}

final class AppEngineConfigure: EngineConfiguration {
    var progress: Float {
        get { UIStateManager.shared.progress }
        set { UIStateManager.shared.progress = newValue }
    }
    
    var isPremium: Bool = UIStateManager.shared.isPremium
        
    var contentScaleFactor: CGFloat = UIStateManager.shared.contentscaleFactor
    
    var getSnappingMode: Int = PersistentStorage.snappingMode
    
    func fetchImage(imageURL: String) async throws -> UIImage? {
        try await NetworkManager.shared.fetchImage(imageURL: imageURL)
    }
    
    func downloadFontFromServer(fontName: String) async throws -> URL {
        try await NetworkManager.shared.downloadFontFromServer(fontName: fontName)
    }
    
    func downloadMusicFromServer(musicPath: String) async throws -> URL {
        try await NetworkManager.shared.downloadMusicFromServer(musicPath: musicPath)
    }
    
    func readDataFromFileFromFontAssets(fileName: String) -> Data? {
        AppFileManager.shared.fontAssets?.readDataFromFile(fileName: fileName)
    }
    
    func readDataFromFileFromMusic(fileName: String) -> Data? {
        AppFileManager.shared.music?.readDataFromFile(fileName: fileName)
    }
    
    func readDataFromFileLocalMusic(fileName: String) -> Data? {
        AppFileManager.shared.localMusic?.readDataFromFile(fileName: fileName)
    }
    
    func readDataFromFileLocalAssets(fileName: String) -> Data? {
        AppFileManager.shared.localAssets?.readDataFromFile(fileName: fileName)
    }
    
    func readDataFromFileFromAssets(fileName: String) -> Data? {
        AppFileManager.shared.assets?.readDataFromFile(fileName: fileName)
    }
    
    func loadImageFromDocumentsDirectory(filename: String, directory: URL) throws -> UIImage? {
        try ImageDownloadManager.loadImageFromDocumentsDirectory(filename: filename, directory: AppFileManager.shared.assets!)
    }
    
    func saveImageToDocumentsDirectory(imageData: Data, filename: String, directory: URL) throws {
        try ImageDownloadManager.saveImageToDocumentsDirectory(imageData: imageData, filename: filename, directory: AppFileManager.shared.assets!)
    }
    
    func loadFontFromDocumentsDirectory(fontName: String) -> String? {
        ImageDownloadManager.loadFontFromDocumentsDirectory(fontName: fontName)
    }
    
    func getAssetsPath() -> URL? {
        AppFileManager.shared.assets?.url
    }
    
    func getFontAssetsPath() -> URL? {
        AppFileManager.shared.fontAssets?.url
    }
    
    func getMuicPath() -> URL? {
        AppFileManager.shared.music?.url
    }
    
    func getLocalMusicPath() -> URL? {
        AppFileManager.shared.localMusic?.url
    }
    
    func getBaseSize() -> CGSize{
        return BASE_SIZE
    }
    
    func logReplaceSticker() {
//        analyticsLogger.logEditorInteraction(action: .replaceSticker)
    }
    
    func logAddText() {
//        analyticsLogger.logEditorInteraction(action: .addText)
    }
    
    func logAddSticker() {
//        analyticsLogger.logEditorInteraction(action: .addSticker)
    }
    
    func logGroup() {
//        analyticsLogger.logEditorInteraction(action: .group)
    }
    
    func logResizeTapped() {
//        analyticsLogger.logEditorInteraction(action: .resizeTapped)
    }
    
    func logAddMusic() {
//        analyticsLogger.logEditorInteraction(action: .addMusic)
    }
    
    func logAddAnimation() {
//        analyticsLogger.logEditorInteraction(action: .addAnimation)
    }
    
    func logAddBackground() {
//        analyticsLogger.logEditorInteraction(action: .addBackground)
    }
    
    func logUpdateText() {
//        analyticsLogger.logEditorInteraction(action: .updateText)
    }
    
    
}

final class AppLayersConfigure: LayersConfiguration{
    var accentColorSwiftUI: Color = AppStyle.accentColor_SwiftUI
    
    var accentColorUIKit: UIColor = AppStyle.accentColorUIKit
    
    func removeOrDismissViewController(_ childViewController: UIViewController) {
        guard let topVC = UIApplication.shared.keyWindowPresentedController else {
            print("⚠️ No top view controller found.")
            return
        }
        topVC.removeOrDismissViewController(childViewController)
    }
    
    
}

final class AppTimelineConfigure: TimelineConfiguration{
    var collectionViewBGColor: UIColor = .white
    
    var rulerViewBGColor: UIColor = .gray
    
    var rulerColor: UIColor = .black
    
    var rulerColor2: UIColor = UIColor.secondaryLabel
    
    var rulerColor3: UIColor = UIColor.tertiaryLabel
    
    var timelineBackgroundColor: UIColor = .white
    
    var rulingParentBGColor: UIColor = .orange
    
    var parentModelColor: UIColor = .orange
    
    var stickerModelColor: UIColor = .cyan
    
    var textModelColor: UIColor = .green
    
    var accentColorMiddleLine: UIColor = .systemPink
    
    var accentColorToggleButton: UIColor = .systemPink
    
    var accentColor: UIColor = .systemPink
    
    func logTimelineScrolled() {
//        analyticsLogger.logEditorInteraction(action: .timelineScrolled)
    }
    
    
}
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
//
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
