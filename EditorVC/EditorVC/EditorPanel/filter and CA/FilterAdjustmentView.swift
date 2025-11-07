//
//  FilterAdjustmentView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 04/01/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import IOS_CommonEditor

struct FilterAdjustmentView: View {
    
    @Binding var selectedFilter: FiltersEnum
    @Binding var lastSelectedFilter: FiltersEnum
//    @State var staticImage: UIImage = UIImage(named: "filterStaticImage")!
    let filterTypes: [(FiltersEnum, String)] = [
        (.none, "None_".translate()),
            (.sepia, "Sepia"),
            (.blackNWhite, "Noir"),
            (.monoChrome, "UniShade"),
            (.falseColor, "Spectral"),
            (.sketch, "Sketch"),
            (.softElegance, "Dreamy Glow"),
            (.massEtikate, "Harmoniq"),
            (.poolkadot, "Pebble")
        ]
    @Binding var updateThumb: Bool
    let rows = [
            GridItem(.fixed(100)), // Fixed height for each row
           
        ]
    
    var body: some View {
        VStack{
            
            ScrollView(.horizontal, showsIndicators: false){
                ScrollViewReader { proxy in
                    LazyHGrid(rows: rows, spacing: 10){
                        ForEach(filterTypes, id: \.0) { (filter, name) in
                            
                            Spacer()
                            VStack{
//                                VStack{
//                                    if let filterPreviewImage = staticImage /*applyFilter(to: staticImage, filter: filter)*/ {
                                        Image(name)
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .background(.gray)
                                            .onTapGesture {
                                                selectedFilter = filter
                                                updateThumb = true
                                            }
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 0)
                                                    .stroke(selectedFilter == filter ? AppStyle.accentColor_SwiftUI : .clear, lineWidth: 2)
                                                    .frame(width: 75, height: 75)
                                            )
//                                    }
//                                }
                                
//                                Circle()
//                                    .fill(selectedFilter == filter ? AppStyle.accentColor_SwiftUI : .clear)
//                                    .frame(width: 8, height: 8)
//                                    .padding(.top, 4)
//                                    .padding(.bottom, 2)
                                
                                
                                Text(name)
                                    .font(.subheadline)
                                    .foregroundColor(selectedFilter == filter ? AppStyle.accentColor_SwiftUI :  .primary)
                            }
                            .frame(height: 130)
                            .padding(.vertical, 5)
                        }
                        
                    }
                    .frame(height: 150)
                    .padding(.horizontal)
                    .onChange(of: selectedFilter) { newValue in
                        scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: newValue)
                    }
                    
                }
                .frame(height: 150)
            }
            .frame(height: 150)
        }
        .frame(height: 180)
        .onAppear(){
            //selectedFilter = lastSelectedFilter
        }
    }
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: FiltersEnum) {
            // Find the ID of the last selected button and scroll to
            // Add more conditions for other tab states...
            
            // Scroll to the identified button
            withAnimation(.spring()) {
                scrollViewProxy.scrollTo(scrollToID, anchor: .center)
            }
                
        }
    
//    func applyFilter(to image: UIImage, filter: FiltersEnum) -> UIImage? {
//            let ciImage = CIImage(image: image)
//            let context = CIContext()
//            
//            let ciFilter: CIFilter?
//            switch filter {
//            case .none:
//                return image
//            case .blackNWhite:
//                ciFilter = CIFilter.colorControls()
//                ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//                ciFilter?.setValue(0.0, forKey: kCIInputSaturationKey)
//            case .sepia:
//                ciFilter = CIFilter.sepiaTone()
//                ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//                ciFilter?.setValue(0.8, forKey: kCIInputIntensityKey)
//            case .falseColor:
//                ciFilter = CIFilter.falseColor()
//                ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//            case .gray:
//                ciFilter = CIFilter.colorMonochrome()
//                ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//                ciFilter?.setValue(CIColor.white, forKey: kCIInputColorKey)
//                ciFilter?.setValue(1.0, forKey: kCIInputIntensityKey)
//            case .sketch:
//                ciFilter = CIFilter.lineOverlay()
//                ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//            case .oilPainting:
//                ciFilter = CIFilter.bloom()
//                ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//                ciFilter?.setValue(5.0, forKey: kCIInputRadiusKey)
//                ciFilter?.setValue(0.8, forKey: kCIInputIntensityKey)
//            case .abao:
//                ciFilter = CIFilter.colorInvert()
//                ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//            case .poolkadot:
//                ciFilter = CIFilter.pointillize()
//                ciFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//                ciFilter?.setValue(10.0, forKey: kCIInputRadiusKey)
//                ciFilter?.setValue(CIVector(x: 25, y: 25), forKey: kCIInputCenterKey)
//            }
//
//            guard let filter = ciFilter, let outputImage = filter.outputImage else {
//                return nil
//            }
//
//            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
//                return UIImage(cgImage: cgImage)
//            }
//
//            return nil
//        }
}

//#Preview {
//    FilterAdjustmentView()
//}

