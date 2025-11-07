//
//  AppFileManager.swift
//  VideoInvitation
//
//  Created by HKBeast on 06/03/24.
//
import Foundation
import IOS_CommonEditor

class AppFileManager : ExportFileHandler {
   
    
  
    var exportVideoFile: File?
    var exportImageFile : File?
    
    deinit{
        printLog("deinit app file manager")
    }
    // static object of AppFileManager
    static let shared = AppFileManager()
    
    
    let documentFolder: Folder
    let tempFolder: Folder
    
    // Documents Folder
    var dataBase: Folder?
    var assets: Folder?
    var stickerAssets: Folder?
    var music: Folder?
    var fontAssets: Folder?
    var myDesigns: Folder?
    var localAssets: Folder?
    var localMusic: Folder?
    
    var promotionalThumbnails: Folder?
    
    //temp
    // Template folders
    var templateCategoryThumbnails: Folder?
    var templateThumbnails: Folder?
    
    // Sticker folders
    var stickersCategoryThumbnails: Folder?
    var stickersThumbnails: Folder?
    
    // Music folders
    var musicsCategoryThumbnails: Folder?
    var musicsThumbnails: Folder?
    
    // image folders
    var imageCategoryThumbnails: Folder?
    var imageThumbnails: Folder?
    
    init(){
        documentFolder = RootFolder(type: .Document)
        tempFolder = RootFolder(type: .Temp)
    }
    //MARK: - *******Public Methods***********
    
    //MARK: - Documents folder configuration
    
    func configurePromotionalFolder(){
        createPromotionalThumbnailsFolder()
    }
    
    func configureDatabaseFolder(){
        createDatabaseFolder()
    }
    
    func configureBGAssetsFolder(){
        createBGAssetsFolder()
    }
    
    func configureLocalBGAssetsFolder(){
        createLocalBGAssetsFolder()
    }
    
    func configureStickerAssetsFolder(){
        createStickerAssetsFolder()
    }
    
    func configureMusicAssetsFolder(){
        createMusicAssetsFolder()
    }
    
    func configureLocalMusicAssetsFolder(){
        createLocalMusicAssetsFolder()
    }
    
    func configureFontAssetsFolder(){
        createFontAssetsFolder()
    }
    
    func configureMyDesignsFolder(){
        createMyDesignsFolder()
    }
    
    //MARK: - Temp file folder configuration
    
    func configureTemplatesFolder(){
        createTemplateCategoryThumbnailsFolder()
        createTemplateThumbnailsFolder()
        
    }
    func configureStickersFolder(){
        createStickerCategoryThumbnailsFolder()
        createStickerThumbnailsFolder()
        
    }
    func configureMusicsFolder(){
        createMusicCategoryThumbnailsFolder()
        createMusicThumbnailsFolder()
        
    }
    func configureImagesFolder(){
        createImageCategoryThumbnailsFolder()
        createImageThumbnailsFolder()
        
    }
    
    
    //MARK: - **********Private methods******
    
    //MARK: - create documents folder
    
    private func createDatabaseFolder(){
        do {
            let databaseFolder = Folder(name: "Database")
            try documentFolder.addFolder(folder: databaseFolder)
            print("Database folder created successfully.")
            dataBase = databaseFolder
        } catch {
            print("Error creating database folder: \(error.localizedDescription)")
        }
    }
    
    private func createBGAssetsFolder() {
        do {
            let bgAssetsFolder = Folder(name: "Assets")
            try documentFolder.addFolder(folder: bgAssetsFolder)
            print("BGAssets folder created successfully.")
            assets = bgAssetsFolder
        } catch {
            print("Error creating BGAssets folder: \(error.localizedDescription)")
        }
    }
    
    private func createLocalBGAssetsFolder() {
        do {
            let bgAssetsFolder = Folder(name: "Local Assets")
            try documentFolder.addFolder(folder: bgAssetsFolder)
            print("local BGAssets folder created successfully.")
            localAssets = bgAssetsFolder
        } catch {
            print("Error creating local BGAssets folder: \(error.localizedDescription)")
        }
    }
    
    private func createStickerAssetsFolder() {
        do {
            let stickerAssetsFolder = Folder(name: "StickerAssets")
            try documentFolder.addFolder(folder: stickerAssetsFolder)
            print("StickerAssets folder created successfully.")
            stickerAssets = stickerAssetsFolder
        } catch {
            print("Error creating StickerAssets folder: \(error.localizedDescription)")
        }
    }
    
    private func createMusicAssetsFolder() {
        do {
            let musicAssetsFolder = Folder(name: "Musics")
            try documentFolder.addFolder(folder: musicAssetsFolder)
            print("MusicAssets folder created successfully.")
            music = musicAssetsFolder
        } catch {
            print("Error creating MusicAssets folder: \(error.localizedDescription)")
        }
    }
    
    private func createLocalMusicAssetsFolder() {
        do {
            let musicAssetsFolder = Folder(name: "LocalMusics")
            try documentFolder.addFolder(folder: musicAssetsFolder)
            print("MusicAssets folder created successfully.")
            localMusic = musicAssetsFolder
        } catch {
            print("Error creating MusicAssets folder: \(error.localizedDescription)")
        }
    }
    
    private func createFontAssetsFolder() {
        do {
            let fontAssetsFolder = Folder(name: "FontAssets")
            try documentFolder.addFolder(folder: fontAssetsFolder)
            print("FontAssets folder created successfully.")
            fontAssets = fontAssetsFolder
        } catch {
            print("Error creating FontAssets folder: \(error.localizedDescription)")
        }
    }
    
    private func createMyDesignsFolder() {
        do {
            let myDesignsFolder = Folder(name: "MyDesigns")
            try documentFolder.addFolder(folder: myDesignsFolder)
            print("my designs folder created successfully.")
            myDesigns = myDesignsFolder
        } catch {
            print("Error creating my designs folder: \(error.localizedDescription)")
        }
    }
    
    //MARK: - create Temp file folder
    private func createPromotionalThumbnailsFolder() {
        do {
            let promotionalThumbnailsFolder = Folder(name: "PromotionalThumbnails")
            try tempFolder.addFolder(folder: promotionalThumbnailsFolder)
            print("TemplateCategoryThumbnails folder created successfully.")
            promotionalThumbnails = promotionalThumbnailsFolder
        } catch {
            print("Error creating TemplateCategoryThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    
    private func createTemplateCategoryThumbnailsFolder() {
        do {
            let templateCategoryThumbnailsFolder = Folder(name: "TemplateCategoryThumbnails")
            try tempFolder.addFolder(folder: templateCategoryThumbnailsFolder)
            print("TemplateCategoryThumbnails folder created successfully.")
            templateCategoryThumbnails = templateCategoryThumbnailsFolder
        } catch {
            print("Error creating TemplateCategoryThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    private func createTemplateThumbnailsFolder() {
        do {
            let templateThumbnailsFolder = Folder(name: "TemplateThumbnails")
            try tempFolder.addFolder(folder: templateThumbnailsFolder)
            print("TemplateThumbnails folder created successfully.")
            templateThumbnails = templateThumbnailsFolder
        } catch {
            print("Error creating TemplateThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    private func createStickerCategoryThumbnailsFolder() {
        do {
            let stickersCategoryThumbnailsFolder = Folder(name: "StickersCategoryThumbnails")
            try tempFolder.addFolder(folder: stickersCategoryThumbnailsFolder)
            print("StickersCategoryThumbnails folder created successfully.")
            stickersCategoryThumbnails = stickersCategoryThumbnailsFolder
        } catch {
            print("Error creating StickersCategoryThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    private func createStickerThumbnailsFolder() {
        do {
            let stickersThumbnailsFolder = Folder(name: "StickersThumbnails")
            try tempFolder.addFolder(folder: stickersThumbnailsFolder)
            print("StickersThumbnails folder created successfully.")
            stickersThumbnails = stickersThumbnailsFolder
        } catch {
            print("Error creating StickersThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    private func createMusicCategoryThumbnailsFolder() {
        do {
            let musicsCategoryThumbnailsFolder = Folder(name: "MusicsCategoryThumbnails")
            try tempFolder.addFolder(folder: musicsCategoryThumbnailsFolder)
            print("MusicsCategoryThumbnails folder created successfully.")
            musicsCategoryThumbnails = musicsCategoryThumbnailsFolder
        } catch {
            print("Error creating MusicsCategoryThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    private func createMusicThumbnailsFolder() {
        do {
            let musicsThumbnailsFolder = Folder(name: "MusicsThumbnails")
            try tempFolder.addFolder(folder: musicsThumbnailsFolder)
            print("MusicsThumbnails folder created successfully.")
            musicsThumbnails = musicsThumbnailsFolder
        } catch {
            print("Error creating MusicsThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    private func createImageCategoryThumbnailsFolder() {
        do {
            let imagesCategoryThumbnailsFolder = Folder(name: "ImagesCategoryThumbnails")
            try tempFolder.addFolder(folder: imagesCategoryThumbnailsFolder)
            print("ImagesCategoryThumbnails folder created successfully.")
            imageCategoryThumbnails = imagesCategoryThumbnailsFolder
        } catch {
            print("Error creating ImagesCategoryThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    private func createImageThumbnailsFolder() {
        do {
            let imagesThumbnailsFolder = Folder(name: "ImagesThumbnails")
            try tempFolder.addFolder(folder: imagesThumbnailsFolder)
            print("ImagesThumbnails folder created successfully.")
            imageThumbnails = imagesThumbnailsFolder
        } catch {
            print("Error creating ImagesThumbnails folder: \(error.localizedDescription)")
        }
    }
    
    
    func loadImageDataFromCache(_ imageName: String) ->Data? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        
        if let path = paths.first {
            let imageURL = URL(fileURLWithPath: path).appendingPathComponent(imageName)
            let data = try? Data(contentsOf: imageURL)
            return data
        }
        
        
        return nil
    }
    
}



extension AppFileManager {
    
    func createNewURL(name:String , ext : String) -> URL? {
        
                let date :NSDate = NSDate()
        
                let dateFormatter = DateFormatter()
        
                dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ssa"
        
                dateFormatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        
                let videoName = "\(name)\(dateFormatter.string(from: date as Date))"
            
        if let exportVideoFile = exportVideoFile {
            try? tempFolder.deleteFile(file: exportVideoFile)
        }
        var file = File(name: videoName, fileExtension: ext)
        try? tempFolder.addFile(file: &file)
        exportVideoFile = file
        return file.url
    }
    
    func deleteVideoURL() {
        if let exportVideoFile = exportVideoFile {
            try? tempFolder.deleteFile(file: exportVideoFile)
        }
    }
    
    func createImageURL(name: String, ext: String) -> URL? {
        let date :NSDate = NSDate()

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ssa"

        dateFormatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone

        let videoName = "\(name)\(dateFormatter.string(from: date as Date))"
    
if let exportImageFile = exportImageFile {
    try? tempFolder.deleteFile(file: exportImageFile)
}
var file = File(name: videoName, fileExtension: ext)
try? tempFolder.addFile(file: &file)
exportImageFile = file
return file.url
    }
    
    func deleteImageURL() {
        if let exportImageFile = exportImageFile {
            try? tempFolder.deleteFile(file: exportImageFile)
        }
    }
    
    
    func getDirectoryPath(for folderName: String) -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let folderPath = documentsDirectory.appendingPathComponent(folderName)
        
        // Create folder if it doesn't exist
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            do {
                try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory \(folderName): \(error)")
                return nil
            }
        }
        return folderPath
    }
    
}
