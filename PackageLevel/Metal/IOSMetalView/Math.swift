//
//  Math.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 07/02/23.
//

import MetalKit


public var X_AXIS: float3{
    return float3(1,0,0)
}

public var Y_AXIS: float3{
    return float3(0,1,0)
}

public var Z_AXIS: float3{
    return float3(0,0,1)
}

extension matrix_float4x4 {
    
    mutating func multiplyBy(parentMatrix: matrix_float4x4) {
        self = matrix_multiply(parentMatrix, self)
    }
    
    mutating func translate(direction:float3) {
        var result = matrix_identity_float4x4
        
        let x: Float = direction.x
        let y: Float = direction.y
        let z: Float = direction.z
        
        result.columns = (
            float4(1,0,0,0),
            float4(0,1,0,0),
            float4(0,0,1,0),
            float4(x,y,z,1)
        )
        
        self = matrix_multiply(self, result)
    }
    mutating func scale(axis: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        result.columns = (
            float4(x,0,0,0),
            float4(0,y,0,0),
            float4(0,0,z,0),
            float4(0,0,0,1)
        )
        
        self = matrix_multiply(self, result)
    }
    mutating func rotate(angle: Float, axis: float3){
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        
        let mc: Float = (1 - c)
        
        let r1c1: Float = x * x * mc + c
        let r2c1: Float = x * y * mc + z * s
        let r3c1: Float = x * z * mc - y * s
        let r4c1: Float = 0.0
        
        let r1c2: Float = y * x * mc - z * s
        let r2c2: Float = y * y * mc + c
        let r3c2: Float = y * z * mc + x * s
        let r4c2: Float = 0.0
        
        let r1c3: Float = z * x * mc + y * s
        let r2c3: Float = z * y * mc - x * s
        let r3c3: Float = z * z * mc + c
        let r4c3: Float = 0.0
        
        let r1c4: Float = 0.0
        let r2c4: Float = 0.0
        let r3c4: Float = 0.0
        let r4c4: Float = 1.0
        
        result.columns = (
            float4(r1c1, r2c1, r3c1, r4c1),
            float4(r1c2, r2c2, r3c2, r4c2),
            float4(r1c3, r2c3, r3c3, r4c3),
            float4(r1c4, r2c4, r3c4, r4c4)
        )
        
        self = matrix_multiply(self, result)
    }
   
    mutating func skewTransform(angleInDegX: Float, angleInDegY: Float, pivotX: Float, pivotY: Float) {
        var baseSkew = matrix_float3x3(1.0) // Initialized to identity
        
        let fi =    deg2rad(Double(angleInDegX))  //radians(fromDegrees: angleInDegX)
        let theta = deg2rad(Double(angleInDegY))  //radians(fromDegrees: angleInDegY)
        
        // Initialize Skew values
        baseSkew[1][0] = Float(tan(fi))
        baseSkew[1][2] = -pivotX * tan(Float(fi))
        
        baseSkew[0][1] = Float(tan(theta))
        baseSkew[0][2] = -pivotY * Float(tan(theta))
        
        var base = matrix_float4x4(1.0)
        base[0][0] = baseSkew[0][0]
        base[0][1] = baseSkew[0][1]
        base[0][2] = 0.0
        base[0][3] = 0.0
        
        base[1][0] = baseSkew[1][0]
        base[1][1] = baseSkew[1][1]
        base[1][2] = 0.0
        base[1][3] = 0.0
        
        base[2][0] = 0.0
        base[2][1] = 0.0
        base[2][2] = 1.0
        base[2][3] = 0.0
        
        base[3][0] = baseSkew[2][0]
        base[3][1] = baseSkew[2][1]
        base[3][2] = 0.0
        base[3][3] = 1.0
        
       
        
        self = matrix_multiply(self, base)

    }
}
