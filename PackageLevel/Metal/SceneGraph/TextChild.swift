//
//  TextChild.swift
//  VideoInvitation
//
//  Created by HKBeast on 23/08/23.
//

import Foundation
import MetalKit

class TextChild:TexturableChild{
    
    init(model:TextInfo){
        super.init(model: model)
        print("textID",identification)
    }
    
}

class TestChild : StickerChild {
    override init(model: StickerInfo) {
        
        super.init(model: model)
       
//        let translationX = Float(BASE_SIZE.width)/3
//        let translationY = Float(BASE_SIZE.height)/2
//
//        setmCenter(position: float3(model.posX, model.posY, 0.0))
//        setSize(widthScale: 100, heightScale: 200)
//        setColor(color: float3(1.0, 0.0, 0.0))
        
        
    }
    
//   override var model_matrix : matrix_float4x4 {
//        if _use_cached_matrix {
//            return cached_model_matrix
//        }
//        var modelMatrix = matrix_identity_float4x4
//        modelMatrix.translate(direction: _position)
//        modelMatrix.rotate(angle: rotation.x, axis: X_AXIS)
//        modelMatrix.rotate(angle: rotation.y, axis: Y_AXIS)
//        modelMatrix.rotate(angle: rotation.z, axis: Z_AXIS)
//        modelMatrix.scale(axis: _scale)
//        cached_model_matrix = modelMatrix
//        _use_cached_matrix = true
//        return modelMatrix
//    }
//
//
// 393 , 524
    // 1179 , 1572
    
//    var _position : float3 {
//        let parentSize = BASE_SIZE
//        let position = Conversion.setPositionForMetal(centerX: position.x/393, centerY: position.y/524)
//        return position
//    }
//
//    var _scale : float3 {
//        var w = scale.x/Float(BASE_SIZE.width)
//        var h = scale.y/Float(BASE_SIZE.height)
//
//        return float3(w, h, 1.0)
//    }
    
//   override func setVertexData(parentEncoder:MTLRenderCommandEncoder,currentTime:Float, drawableSize:CGSize) {
//       var mvp : Float = 0.0
//       parentEncoder.bindMVPEnable(&mvp)
//        parentEncoder.bind(geometry: geometry)
//        parentEncoder.bind(modalConstants: &modalConstant)
//        var cTime = currentTime
//        parentEncoder.bind(timeForVertex: &cTime)
//        parentEncoder.bind(flipType: &mFlipType)
//    }
    
}
