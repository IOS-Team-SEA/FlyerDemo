//
//  RootFolder.swift
//  FileManager
//
//  Created by HKBeast on 27/10/23.
//

import Foundation

enum RootDirectory:String{
    case Document = "Document"
    case Temp = "tmp"
}

class RootFolder : Folder {
    
    
    init(type: RootDirectory) {
    
        if type == .Document{
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//            if let path = paths.first {
                let documentPathUrl = URL(fileURLWithPath: paths.first!)
                let documentDirectoryURL = documentPathUrl
                print(documentDirectoryURL)
                super.init(url: documentDirectoryURL)
//            }
    
         
        }
        else{
            let documentDirectoryURL = FileManager.default.temporaryDirectory
            print(documentDirectoryURL)
            super.init(url: documentDirectoryURL)
        }
    }
    
    
}
//
//class RootFolder{
//  
//    func getParentFolder(parentFolder:RootDirectory)->Folder{
//        if parentFolder == .Document{
//           return getDocumentFolder()
//        }else{
//            return getTempFolder()
//        }
//        
//    }
//   private func getDocumentFolder()->Folder{
//        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let folder = Folder(url: documentDirectoryURL)
//        return folder
//    }
//  private  func getTempFolder()->Folder{
//        let documentDirectoryURL = FileManager.default.temporaryDirectory
//        let folder = Folder(url: documentDirectoryURL)
//        return folder
//      
//     
//    }
//    
//}
