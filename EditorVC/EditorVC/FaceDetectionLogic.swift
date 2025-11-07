//
//  FaceDetectionLogic.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 26/03/25.
//

import SwiftUI
import UIKit
import Mantis
import Vision
import CoreGraphics

func detectFace(image: UIImage, completion: @escaping (CGRect?) -> Void) {
    guard let ciImage = CIImage(image: image) else { return }
    let request = VNDetectFaceRectanglesRequest { request, error in
        DispatchQueue.main.async {
            guard let results = request.results as? [VNFaceObservation], let face = results.first, error == nil else {
                completion(nil)
                return
            }
            
            let imageSize = image.mySize
            let faceBoundingBox = CGRect(
                x: face.boundingBox.origin.x * imageSize.width,
                y: (1 - face.boundingBox.origin.y - face.boundingBox.height) * imageSize.height,
                width: face.boundingBox.width * imageSize.width,
                height: face.boundingBox.height * imageSize.height
            )
            
            completion(faceBoundingBox)
        }
    }
    let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
        try? requestHandler.perform([request])
    }
}


func getUserImageCropRect(previousFaceRect: CGRect, previousImageWidth: CGFloat, previousImageHeight: CGFloat,
                          userFaceRect: CGRect, userImageWidth: CGFloat, userImageHeight: CGFloat) -> CGRect? {
    
    var iterationCount = 0
    let maxIterations = 500  // Adjust this value based on your needs

    // Step 1: Determine the minimum dimension (width or height) of the face rectangles for scaling
    let previousFaceMin = min(previousFaceRect.width, previousFaceRect.height)
    let userFaceMin = min(userFaceRect.width, userFaceRect.height)

    // Step 2: Calculate the scaling ratio between the user's face and the previous face
    let ratio = userFaceMin / previousFaceMin

    // Step 3: Compute the expected crop dimensions based on the scaling ratio
    let expectedCropWidth = ratio * previousImageWidth
    let expectedCropHeight = ratio * previousImageHeight

    // Step 4: Calculate the initial crop rectangle coordinates
    var expectedLeft = userFaceRect.midX - (previousFaceRect.midX * ratio)
    var expectedTop = userFaceRect.midY - (previousFaceRect.midY * ratio)
    let expectedRight = expectedLeft + expectedCropWidth
    let expectedBottom = expectedTop + expectedCropHeight

    let userImageRect = CGRect(x: 0, y: 0, width: userImageWidth, height: userImageHeight)
    var userImageExpectedCropRect = CGRect(x: expectedLeft, y: expectedTop, width: expectedCropWidth, height: expectedCropHeight)

    // Step 5: Check if the crop rectangle fits entirely within the user's image bounds
    if userImageRect.contains(userImageExpectedCropRect) {
        return userImageExpectedCropRect
    }

    // Step 6: Calculate the amount of overflow outside the image bounds
    var leftSpace = userFaceRect.minX - userImageExpectedCropRect.minX
    var topSpace = userFaceRect.minY - userImageExpectedCropRect.minY
    let horizontalSpace = userImageExpectedCropRect.width - userFaceRect.width
    let verticalSpace = userImageExpectedCropRect.height - userFaceRect.height

    let leftSpacePercent = leftSpace / horizontalSpace
    let topSpacePercent = topSpace / verticalSpace

    var width: CGFloat
    var height: CGFloat
    var rightSpace: CGFloat
    var bottomSpace: CGFloat

    while iterationCount < maxIterations {
        iterationCount += 1
        print("Repeat in while loop.")
        // Step 7: Adjust crop dimensions iteratively based on the orientation of the previous image
        if previousImageWidth < previousImageHeight {
            // Portrait orientation: Adjust width and derive height proportionally
            width = expectedRight - expectedLeft - 2
            height = (width * previousImageHeight) / previousImageWidth
        } else {
            // Landscape orientation: Adjust height and derive width proportionally
            height = expectedBottom - expectedTop - 2
            width = (height * previousImageWidth) / previousImageHeight
        }

        // Calculate new spaces based on the adjusted dimensions
        leftSpace = round(leftSpacePercent * (width - userFaceRect.width))
        topSpace = round(topSpacePercent * (height - userFaceRect.height))
        rightSpace = width - userFaceRect.width - leftSpace
        bottomSpace = height - userFaceRect.height - topSpace

        if leftSpace > 0, topSpace > 0, rightSpace > 0, bottomSpace > 0 {
            // Update the crop rectangle based on the adjusted spaces
            expectedLeft = userFaceRect.minX - leftSpace
            expectedTop = userFaceRect.minY - topSpace

            let adjustedCropRect = CGRect(x: expectedLeft, y: expectedTop, width: width, height: height)

            // Step 8: Check if the adjusted crop rectangle fits within the bounds of the user's image
            if userImageRect.contains(adjustedCropRect) {
                return adjustedCropRect
            }
        } else {
            // Step 9: No space left to adjust further; attempt to calculate a best-fit crop rectangle
            let fallbackLeft = max(userImageRect.minX, expectedLeft)
            let fallbackTop = max(userImageRect.minY, expectedTop)
            let fallbackRight = min(userImageRect.maxX, expectedLeft + width)
            let fallbackBottom = min(userImageRect.maxY, expectedTop + height)

            let fallbackWidth = fallbackRight - fallbackLeft
            let fallbackHeight = fallbackBottom - fallbackTop

            // Resize dimensions proportionally while maintaining aspect ratio
            let (resizedWidth, resizedHeight) = getResizeDimensions(originalWidth: previousImageWidth,
                                                                    originalHeight: previousImageHeight,
                                                                    maxWidth: fallbackWidth,
                                                                    maxHeight: fallbackHeight)

            expectedLeft = fallbackLeft + (fallbackWidth - resizedWidth) / 2
            expectedTop = fallbackTop + (fallbackHeight - resizedHeight) / 2

            let adjustedRect = CGRect(x: expectedLeft, y: expectedTop, width: resizedWidth, height: resizedHeight)

            if userImageRect.contains(adjustedRect), adjustedRect.contains(CGPoint(x: userFaceRect.midX, y: userFaceRect.midY)) {
                return adjustedRect
            }

            return nil
        }
    }
    return nil
}

// Helper function to maintain aspect ratio while resizing
func getResizeDimensions(originalWidth: CGFloat, originalHeight: CGFloat, maxWidth: CGFloat, maxHeight: CGFloat) -> (CGFloat, CGFloat) {
    let widthRatio = maxWidth / originalWidth
    let heightRatio = maxHeight / originalHeight
    let scaleFactor = min(widthRatio, heightRatio)

    let newWidth = originalWidth * scaleFactor
    let newHeight = originalHeight * scaleFactor

    return (newWidth, newHeight)
}
