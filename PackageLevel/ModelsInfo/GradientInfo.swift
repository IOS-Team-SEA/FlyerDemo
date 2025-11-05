//
//  GradientInfo.swift
//  FlyerDemo
//
//  Created by HKBeast on 03/11/25.
//

import Foundation

struct GradientInfo :AnyBGContent,Codable{
    var GradientType: Int
    var StartColor: Int
    var EndColor: Int
    var Radius: Float
    var AngleInDegrees:Float
}
