//
//  BGContainerDatasource.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 04/04/24.
//

import Foundation
import SwiftUI

struct BGContainerDatasource{
    
    static func bgArray() -> [String]?{
        var bgArray: [String] = [String]()
        
        for i in 0 ... 100{
            bgArray.append("b\(i)")
        }
        
        return bgArray
    }
    
    static func textureArray() -> [String]?{
        var textureArray: [String] = [String]()
        
        for i in 0 ... 105{
            textureArray.append("t\(i)")
        }
        
        return textureArray
    }
    
    static func overlayArray() -> [String]?{
        var overlayArray: [String] = [String]()
        
        for i in 1 ... 31{
            overlayArray.append("o\(i)")
        }
        
        return overlayArray
    }
    
    static func maskArray() -> [String]?{
        var overlayArray: [String] = [String]()
        
        for i in 0 ... 23{
            overlayArray.append("shape_\(i)")
        }
        
        return overlayArray
    }
}
