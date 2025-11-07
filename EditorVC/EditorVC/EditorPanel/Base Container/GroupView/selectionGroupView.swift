//
//  selectionGroupView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 16/04/24.
//

import SwiftUI
import IOS_CommonEditor

struct selectionGroupView: View {
    
    @State private var selectedItems: [String] = []
    @Binding var selectedItemsArray: [BaseModel]
    @Binding var unSelectedItemsArray: [BaseModel]
    @Binding var addItem: Int
    @Binding var removeItem: Int
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
                Spacer()
                Text("Unselected_")
//                    .foregroundColor(.black)
//                    .padding(.leading, 50)
                
                Spacer(minLength: UIDevice.current.userInterfaceIdiom == .pad ? 500 : 100)
                Text("Selected_")
//                    .foregroundColor(.black)
//                    .padding(.trailing, 80)
                Spacer()
            }
            .frame(maxWidth: .infinity, idealHeight: 25)
            Divider().background(Color.secondaryLabel) // Vertical Divider
            
            HStack {
                Spacer()
                UnSelectedView(unSelectedItemsArray: $unSelectedItemsArray, removeItem: $removeItem, addItem: $addItem)
                    .frame(height: 250)
                Spacer()
                Divider().background(Color.secondaryLabel) // Horizontal Divider
                Spacer()
                SelectedView(selectedItemsArray: $selectedItemsArray, removeItem: $removeItem, addItem: $addItem)
                    .frame(height: 250)
                Spacer()
            }
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
        }
        .frame(height: 280)
    }
}

struct SelectedViewCell: View {
    
    @Binding var item: BaseModel
    //    @Binding var selectedItems: [String]
    @Binding var removeItem: Int
    @Binding var addItem: Int
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0){
            VStack{
                GeometryReader { geometry in
                    let maxWidth = geometry.size.width
                    let maxHeight = geometry.size.height
                    if let image = item.thumbImage{
                        let originalImageSize = image.mySize
                        let aspectRatio = originalImageSize.width / originalImageSize.height
                        
                        let (imageWidth, imageHeight) = calculateImageSize(originalSize: originalImageSize, maxWidth: maxWidth, maxHeight: maxHeight, aspectRatio: aspectRatio)
                        
                        SwiftUI.Image(uiImage: image)
                            .resizable()
                            .frame(width: imageWidth, height: imageHeight)
                            .clipped()
                            .aspectRatio(contentMode: .fit) // Ensures the image maintains its aspect ratio
                            .position(x: maxWidth / 2, y: maxHeight / 2)
                    }
                }
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 250 : 120, height: 40)
            
            VStack{
                SwiftUI.Image(systemName: "minus")
                    .foregroundColor(.white)
                //                    .onTapGesture {
                //                        addItem = item.id
                //                        removeItem = item.id
                //                    }
                
            }
            .frame(width: 30, height: 40)
            .background(AppStyle.accentColor_SwiftUI)
            .clipShape(CustomRoundedCorners(topRight: true, bottomRight: true))
            
        }
        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 280 : 150)
        .background(Color.systemGray5)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppStyle.accentColor_SwiftUI, lineWidth: 2)
        )
        .onTapGesture {
            addItem = item.modelId
            removeItem = item.modelId
        }
        
    }
    // Function to calculate the image size
    private func calculateImageSize(originalSize: CGSize, maxWidth: CGFloat, maxHeight: CGFloat, aspectRatio: CGFloat) -> (CGFloat, CGFloat) {
        var imageWidth: CGFloat = 0
        var imageHeight: CGFloat = 0
        
        if originalSize.width > originalSize.height {
            // Landscape
            imageWidth = maxWidth
            imageHeight = maxWidth / aspectRatio
            if imageHeight > maxHeight {
                imageHeight = maxHeight
                imageWidth = imageHeight * aspectRatio
            }
        } else {
            // Portrait or square
            imageHeight = maxHeight
            imageWidth = maxHeight * aspectRatio
            if imageWidth > maxWidth {
                imageWidth = maxWidth
                imageHeight = imageWidth / aspectRatio
            }
        }
        
        return (imageWidth, imageHeight)
    }
    
}



struct SelectedView: View {
    
//    @Binding var selectedItems: [String]
    @Binding var selectedItemsArray: [BaseModel]
    @Binding var removeItem: Int
    @Binding var addItem: Int

    var body: some View {
        
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
//                VStack{
                ForEach($selectedItemsArray, id: \.modelId) { item in
                        
                        SelectedViewCell(item: item, removeItem: $removeItem, addItem: $addItem)
                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                    }
//                }.frame(width: 150)
                
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 170)
//            Spacer()
            
        }
        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 280 : 150)
        .padding()
        
    }
}

struct UnselectedViewCell: View {
    
//    @Binding var selectedItems: [String]
    @Binding var item: BaseModel
    @Binding var removeItem: Int
    @Binding var addItem: Int
    
    var body: some View {
        
//        if !selectedItems.contains(item) {
//        if !item.parentEditState{
        if let model = item as? ParentModel, model.editState, model.modelType == .Parent{
            HStack(alignment: .center, spacing: 0){
                VStack{
                    GeometryReader { geometry in
                        
                        let maxWidth = geometry.size.width
                        let maxHeight = geometry.size.height
                        if let image = item.thumbImage{
                            let originalImageSize = image.mySize
                            let aspectRatio = originalImageSize.width / originalImageSize.height
                            
                            let (imageWidth, imageHeight) = calculateImageSize(originalSize: originalImageSize, maxWidth: maxWidth, maxHeight: maxHeight, aspectRatio: aspectRatio)
                            
                            SwiftUI.Image(uiImage: image)
                                .resizable()
                                .frame(width: imageWidth, height: imageHeight)
                                .clipped()
                                .aspectRatio(contentMode: .fit) // Ensures the image maintains its aspect ratio
                                .position(x: maxWidth / 2, y: maxHeight / 2)
                        }
                    }
                }
                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 250 : 150, height: 40)
                
                
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 280 : 150)
            .background(Color.systemGray5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.systemGray, lineWidth: 2)
            )
        }else{
            HStack(alignment: .center, spacing: 0){
                VStack{
                    GeometryReader { geometry in
                        
                        let maxWidth = geometry.size.width
                        let maxHeight = geometry.size.height
                        if let image = item.thumbImage{
                            let originalImageSize = image.mySize
                            let aspectRatio = originalImageSize.width / originalImageSize.height
                            
                            let (imageWidth, imageHeight) = calculateImageSize(originalSize: originalImageSize, maxWidth: maxWidth, maxHeight: maxHeight, aspectRatio: aspectRatio)
                            
                            SwiftUI.Image(uiImage: image)
                                .resizable()
                                .frame(width: imageWidth, height: imageHeight)
                                .clipped()
                                .aspectRatio(contentMode: .fit) // Ensures the image maintains its aspect ratio
                                .position(x: maxWidth / 2, y: maxHeight / 2)
                        }
                    }
                }
                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 250 : 120, height: 40)
                
                VStack{
                    SwiftUI.Image(systemName: "plus")
                        .foregroundColor(.white)
                    //                        .onTapGesture {
                    //                            removeItem = item.id
                    //                            addItem = item.id
                    //                        }
                    
                }
                .frame(width: 30, height: 40)
                .background(Color.systemGray)
                .clipShape(CustomRoundedCorners(topRight: true, bottomRight: true))
                
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 280 : 150)
            .background(Color.systemGray5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.systemGray, lineWidth: 2)
            )
            .onTapGesture {
                removeItem = item.modelId
                addItem = item.modelId
            }
        }
//        }else{
//            HStack(alignment: .center, spacing: 0){
//                VStack{
//                    GeometryReader { geometry in
//                        
//                        let maxWidth = geometry.size.width
//                        let maxHeight = geometry.size.height
//                        if let image = item.thumbImage{
//                            let originalImageSize = image.mySize
//                            let aspectRatio = originalImageSize.width / originalImageSize.height
//                            
//                            let (imageWidth, imageHeight) = calculateImageSize(originalSize: originalImageSize, maxWidth: maxWidth, maxHeight: maxHeight, aspectRatio: aspectRatio)
//                            
//                            SwiftUI.Image(uiImage: image)
//                                .resizable()
//                                .frame(width: imageWidth, height: imageHeight)
//                                .clipped()
//                                .aspectRatio(contentMode: .fit) // Ensures the image maintains its aspect ratio
//                                .position(x: maxWidth / 2, y: maxHeight / 2)
//                        }
//                    }
//                }
//                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 250 : 150, height: 40)
//                
//                
//            }
//            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 280 : 150)
//            .background(Color.systemGray5)
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color.systemGray, lineWidth: 2)
//            )
//            .onTapGesture {
//                removeItem = item.id
//                addItem = item.id
//            }
//        }
//        }
        
    }
    
    // Function to calculate the image size
    private func calculateImageSize(originalSize: CGSize, maxWidth: CGFloat, maxHeight: CGFloat, aspectRatio: CGFloat) -> (CGFloat, CGFloat) {
        var imageWidth: CGFloat = 0
        var imageHeight: CGFloat = 0
        
        if originalSize.width > originalSize.height {
            // Landscape
            imageWidth = maxWidth
            imageHeight = maxWidth / aspectRatio
            if imageHeight > maxHeight {
                imageHeight = maxHeight
                imageWidth = imageHeight * aspectRatio
            }
        } else {
            // Portrait or square
            imageHeight = maxHeight
            imageWidth = maxHeight * aspectRatio
            if imageWidth > maxWidth {
                imageWidth = maxWidth
                imageHeight = imageWidth / aspectRatio
            }
        }
        
        return (imageWidth, imageHeight)
    }
}

struct UnSelectedView: View {
    
//    @Binding var selectedItems: [String]
//    @State var unselectedItems = ["b0", "b1", "b2"]
    @Binding var unSelectedItemsArray: [BaseModel]
    @Binding var removeItem: Int
    @Binding var addItem: Int

    var body: some View {
        VStack{
        
            ScrollView(.horizontal, showsIndicators: false) {
                VStack{
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        //                VStack{
                        ForEach($unSelectedItemsArray, id: \.modelId) { item in
                            //                    if item.isParentsChild.wrappedValue{
                            //                        UnselectedViewCell(item: item, removeItem: $removeItem, addItem: $addItem)
                            //                            .padding(EdgeInsets(top: 5, leading: 70, bottom: 0, trailing: 5))
                            //                    }else{
                            UnselectedViewCell(item: item, removeItem: $removeItem, addItem: $addItem)
                                .padding(EdgeInsets(top: 5, leading: depthLevelPadding(depthLevel: item.depthLevel.wrappedValue), bottom: 0, trailing: 5))
                            //                    }
                        }
                        //                }.frame(width: 150)
                    }
//                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 170)
                    //            Spacer()
                }
//                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 280 : 150)
            }
            .padding(.horizontal, 5)
//            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 280 : 150)
        }
        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 170)
//        .padding(.horizontal, 5)
        
    }
    
    func depthLevelPadding(depthLevel: Int) -> CGFloat{
        return CGFloat(5 + (depthLevel * 40))
    }
}


//#Preview {
//    selectionGroupView()
//}


struct CustomRoundedCorners: Shape {
    var topRight: Bool
    var bottomRight: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topLeftRadius: CGFloat = 0
        let topRightRadius: CGFloat = topRight ? 8 : 0 // Adjust the radius value as needed
        let bottomLeftRadius: CGFloat = 0
        let bottomRightRadius: CGFloat = bottomRight ? 8 : 0 // Adjust the radius value as needed

        path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius),
                    radius: topRightRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius),
                    radius: bottomRightRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius),
                    radius: bottomLeftRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addArc(center: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius),
                    radius: topLeftRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)

        return path
    }
}
