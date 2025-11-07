//
//  Folder.swift
//  FileManager
//
//  Created by HKBeast on 26/10/23.
//

import Foundation
import QuickLook
import IOS_CommonEditor

class Folder {
    let name: String
    var url: URL?
    var parent : Folder? = nil
    init(name: String) {
        self.name = name
        
       
    }
    
    
    init(url:URL){
        self.url = url
        let urlString = url.lastPathComponent
        
        name = urlString
//        if let parentUrl = self.url?.deletingLastPathComponent(){
//            if url.lastPathComponent == "Documents" || url.lastPathComponent == "tmp"{
//                self.parent = nil
//            }else{
//                self.parent = Folder(url: parentUrl)
//            }
//           
//        }
       
    }
    
    func createSubfolder(named subfolderName: String) throws -> Folder {
        let subfolder = Folder(name: subfolderName)
        subfolder.url = self.url?.appendingPathComponent(subfolderName)
        try FileManager.default.createDirectory(at: subfolder.url!, withIntermediateDirectories: true, attributes: nil)
        if let parentUrl = self.url?.deletingLastPathComponent(){
            self.parent = Folder(url: parentUrl)
        }
        return subfolder
    }
    
    
    //MARK: -


    // Function to add a subfolder to the current folder
    func addFolder(folder: Folder) throws {
        // Set the URL for the subfolder by appending its name to the current folder's URL
        folder.url = self.url?.appendingPathComponent(folder.name)
        
        if FileManager.default.fileExists(atPath: folder.url!.path){
            return
        }
        // Try to create the subfolder at the specified URL with intermediate directories if they don't exist
        do {
            try FileManager.default.createDirectory(at: folder.url!, withIntermediateDirectories: true, attributes: nil)
//            if let parentUrl = self.url?.deletingLastPathComponent(){
//                if self.url?.lastPathComponent == "Documents" {
//                    self.parent = RootFolder(type: .Document)
//                }else if  self.url?.lastPathComponent == "tmp"{
//                    self.parent = RootFolder(type: .Temp)
//                }
//                else{
//                      self.parent = Folder(url: parentUrl)
//               }
//   
//            }
            folder.parent = self
            print("Folder \(folder.name) has been added at Parent \(folder.parent)")
        } catch {
            // Handle any errors that may occur during folder creation
            print("Error adding the folder: \(error.localizedDescription)")
            throw error  // Re-throw the error to be handled at a higher level
        }
    }
  
    // Function to delete a subfolder within the current folder
    func deleteFolder(folder: Folder) throws {
        // Construct the URL for the subfolder using its name
        if let subfolderURL = self.url?.appendingPathComponent(folder.name) {
            // Try to remove the subfolder at the specified URL
            do {
                try FileManager.default.removeItem(at: subfolderURL)
                print("Folder \(folder.name) has been deleted.")
            } catch {
                // Handle any errors that may occur during folder removal
                print("Error deleting the folder: \(error.localizedDescription)")
                throw error  // Re-throw the error to be handled at a higher level
            }
        } else {
            // Handle the case where the subfolder URL is nil
            print("Subfolder URL is nil.")
        }
    }
    
    
    func addFile( file: inout File) throws {
        // Check if the folder URL is not nil
        guard let folderURL = self.url else {
            print("Folder URL is nil.")
            return
        }
        
        // Construct the file URL using the provided file name and extension
        file.url = folderURL.appendingPathComponent(file.name).appendingPathExtension(file.fileExtension)
        if FileManager.default.fileExists(atPath: file.url!.pathExtension){
            return
        }
        // Try to write the file's data to the specified file URL
        do {
            try file.data?.write(to: file.url!)
            print("File \(file.name).\(file.fileExtension) has been added.")
        } catch {
            // Handle any errors that occur during the file write operation
            print("Error adding the file: \(error.localizedDescription)")
        }
    }
       
    
    
    // Function to delete a file from the folder
    func deleteFile(file: File) throws {
        // Check if the folder URL is not nil
        if let folderUrl = self.url {
            // Construct the file URL using the provided file name and extension
            let fileUrl = folderUrl.appendingPathComponent(file.name).appendingPathExtension(file.fileExtension)
            
            // Check if the file exists at the specified file URL
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                // Try to remove the file at the specified file URL
                do {
                    try FileManager.default.removeItem(at: fileUrl)
                    print("File \(file.name).\(file.fileExtension) has been deleted.")
                } catch {
                    // Handle any errors that occur during file removal
                    print("Error deleting the file: \(error.localizedDescription)")
                }
            } else {
                // File does not exist
                print("File \(file.name).\(file.fileExtension) does not exist.")
            }
        } else {
            // Handle the case where the folder URL is nil
            print("Folder URL is nil.")
        }
    }


    // Function to list a file or subFolder from the folder
    func listContents() throws -> [String] {
        // Check if the folder URL is not nil
        guard let folderURL = self.url else {
            // If the folder URL is nil, return an empty array
            return []
        }
        
        // Use FileManager to get the list of contents (files and subfolders) at the specified folder URL
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: folderURL.path)
            return contents
        } catch {
            // Handle any errors that may occur while listing contents
            print("Error listing folder contents: \(error.localizedDescription)")
            throw error  // Re-throw the error to be handled at a higher level
        }
    }
    

 
    
    func readDataFromFileQL(fileName: String , maxSize:CGSize) async->CGImage?{
        if  let fileURL = self.url?.appendingPathComponent(fileName){
            if let image = await loadImageUsingQL(fileURL: fileURL, maxSize: maxSize) {
                return image
            }else if let fileData = readDataFromFile(fileName: fileName) , let image = UIImage(data: fileData) {
                        return resizeImage(image: image, targetSize: maxSize)?.cgImage
           }
                    
        }
        return nil
    }
    
    
    func readDataFromFile( fileName: String)->Data?{
        if  let fileURL = self.url?.appendingPathComponent(fileName){
            
            do {
                // Read the content of the file
                let fileData = try Data(contentsOf: fileURL)
                return fileData
//                // Assuming the file contains text data, you can convert it to a string
//                if let fileContent = String(data: fileData, encoding: .utf8) {
//                    printLog("Content of \(fileName):\n\(fileContent)\n")
//                } else {
//                    printLog("Unable to convert data to string.")
//                }
            } catch {
                print("Error reading file: \(error)")
            }
        }
        return nil
    }
    
    func replaceDataInFile(fileName: String, imageData: Data) throws {
        if  let fileURL = self.url?.appendingPathComponent(fileName){
            
            let fileManager = FileManager.default
            do{
                if fileManager.fileExists(atPath: fileURL.path){
                    try fileManager.removeItem(at: fileURL)
                }
                
                try imageData.write(to: fileURL)
                
                print("File replaced successfully in MyDesigns: \(fileName)")
                
            }catch{
                print("Error replacing file from my designs: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteFileFromLocalAssets(fileName: String) {
        guard let fileURL = self.url?.appendingPathComponent(fileName) else {
            print("Invalid file URL.")
            return
        }
        
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
                print("File deleted successfully from LocalAssets: \(fileName)")
            } else {
                print("File does not exist in LocalAssets: \(fileName)")
            }
        } catch {
            print("Error deleting file from LocalAssets: \(error.localizedDescription)")
        }
    }
    
}




 func loadImageUsingQL(fileURL:URL , maxSize:CGSize) async -> CGImage? {
    
    let generator = QLThumbnailGenerator.shared
    
    // Create a QLThumbnailRequest for the URL
    let request = QLThumbnailGenerator.Request(fileAt: fileURL, size: maxSize, scale: 1.0, representationTypes: .thumbnail)
    do {
        
        let representation = try await generator.generateBestRepresentation(for: request)
        return representation.cgImage
        // Read the content of the file
  
    } catch {
        printLog("Error reading file via \(error.localizedDescription)")
        return nil
    }
}
