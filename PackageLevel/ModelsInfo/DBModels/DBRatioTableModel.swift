//
//  RatioTable.swift
//  InvitationMakerHelperDB
//
//  Created by HKBeast on 17/07/23.
//

import Foundation

struct DBRatioTableModel: Identifiable {
    var id: Int = 0
    var category: String = ""
    var categoryDescription: String = ""
    var imageResId: String = ""
    var ratioWidth: Double = 0.0
    var ratioHeight: Double = 0.0
    var outputWidth: Double = 0.0
    var outputHeight: Double = 0.0
    var isPremium: Int = 0
}


