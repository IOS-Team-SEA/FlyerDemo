//
//  File.swift
//  FileManager
//
//  Created by HKBeast on 26/10/23.
//

import Foundation

enum FileType{
    case Audio
    case Video
    case DB
    case Image
    case None
}



class File {
    let name: String
    var data: Data?
    var fileExtension: String
    var fileType: FileType?
    var url: URL?
    init(name: String, data: Data, fileExtension: String) {
        self.name = name
        self.data = data
        self.fileExtension = fileExtension
        self.fileType = determineFileType(from: fileExtension)
    }
    
    init(name: String, fileExtension: String) {
        self.name = name
        self.fileExtension = fileExtension
        self.data = nil
        self.fileType = determineFileType(from: fileExtension)
    }
    
    // Determine the file type based on the file extension
    private func determineFileType(from fileExtension: String) -> FileType {
        switch fileExtension {
        case "nil":
            return .None
        case "db":
            return .DB
        case "mp3":
            return .Audio
        case "mp4":
            return .Video
        
        default:
            return .Image
        }
    }

    // Method to read data from the file
    func readData() -> Data? {
        return self.data
    }
    
    // Method to write data to the file
    func writeData(data: Data) {
        self.data = data
    }
}

