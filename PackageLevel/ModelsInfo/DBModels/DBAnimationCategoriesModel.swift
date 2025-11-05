//
//  AnimationCategories.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

struct DBAnimationCategoriesModel:AnimationCategoriesModelProtocol {
 
    var animationCategoriesId: Int = 0
    var animationName: String = ""
    var animationIcon: String = ""
    var order: Int = 0
    var enabled: Int = 0
}



