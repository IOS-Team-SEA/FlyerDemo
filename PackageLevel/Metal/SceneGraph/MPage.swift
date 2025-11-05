//
//  MPage.swift
//  VideoInvitation
//
//  Created by HKBeast on 23/08/23.
//

import Foundation
import MetalKit

class MPage:MParent {
//    var backgroundChild:BGChild?
 
    init(pageInfo : PageInfo) {
        super.init(model: pageInfo)
        switchTo(type: .SceneRender)
    }
    
//    override func setmOpacity(opacity: Float) {
////        mOpacity = 1.0
////        self.opacity = Double(1.0)
//        backgroundChild?.setmOpacity(opacity: opacity)
//    }
}
