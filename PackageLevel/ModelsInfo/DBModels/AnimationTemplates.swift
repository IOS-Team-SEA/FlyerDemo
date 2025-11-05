//
//  AnimationTemplates.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

struct DBAnimationTemplateModel : AnimationTemplateProtocol {
    var animationTemplateId: Int = 0
    var name: String = "none"
    var type: String = "ANY"
    var category: Int = 1
    var duration: Float = 1.0
    var isLoopEnabled: Int = 0
    var isAutoReverse: Int = 0
    var icon: String = "None.png"
}




enum AnimeType : String {
    case In = "IN"
    case Out = "OUT"
    case Loop = "LOOP"
}
