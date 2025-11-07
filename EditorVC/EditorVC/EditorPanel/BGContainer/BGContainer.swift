//
//  BGContainer.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 14/03/24.
//

import SwiftUI

//struct BGContainer: View {
//    /* View Model for Background */
//    
////    @StateObject var viewModel : BackgroundInfo  //TODO: - BackgroundInfo Model not exist.
//    @StateObject var currentModel: PageInfo
//    
//    @StateObject var actionStates: ActionStates
//    
//    /* State for managing Tab Bar */
//    @State var didColorTabClikced : Bool       = false
//    @State var didGradientTabClikced: Bool     = false
//    @State var didBackgroundTabClikced : Bool  = false
//    @State var didTextureTabClikced : Bool     = false
//    @State var didGalleryTabClikced : Bool     = false
//    @State var didBlurTabClikced : Bool        = false
//    @State var didOverlayTabClikced : Bool     = false
//    
//    /* State for managing Panel */
//    @State var showPanel : Bool = false
//    
//    /* Delegate for Managing Height */
//    weak var delegate : ContainerHeightProtocol?
//    
//    var body: some View {
//        VStack{
//            
//            if didColorTabClikced{
////                ColorPanel(templateColorArray: $actionStates.templateColorArray, startColor: $currentModel.startColor, endColor: $currentModel.endColor).frame(height: panelHeight)
//            }else if didGradientTabClikced{
////                GradientPanelView(gradientInfo: $currentModel.gradient, oldGradientInfo: $currentModel.oldGradientInfo, newGradientInfo: $currentModel.newGradientInfo, colorInfoType: $currentModel.colorInfoType, imageType: $currentModel.imageType, startColor: $currentModel.startColor, endColor: $currentModel.endColor).frame(height: panelHeight)
//            }else if didBackgroundTabClikced{
////                BGControlPanelView(resId: $currentModel.resID, imageType: $currentModel.imageType).frame(height: panelHeight)
//            }else if didTextureTabClikced{
////                TexturePanelView(tileSize: $currentModel.tileMultiple, resId: $currentModel.resID, imageType: $currentModel.imageType, beginTileMultiple: $currentModel.beginTileMultiple, endTileMultiple: $currentModel.endTileMultiple).frame(height: panelHeight)
//            }else if didBlurTabClikced{
////                BlurPanelView(blur: $currentModel.bgBlurProgress, beginBlur: $currentModel.beginBlur, endBlur: $currentModel.endBlur).frame(height: panelHeight)
//            }else if didOverlayTabClikced{
////                OverlayPanelView(opacity: $currentModel.overlayOpacity, beginOverlayOpacity: $currentModel.beginOverlayOpacity, endOverlayOpacity: $currentModel.endOverlayOpacity, resId: $currentModel.overlayResID, imageType: $currentModel.overlayType).frame(height: panelHeight)
//            }
//            
////            BGContainerTabbar(didColorTabClicked: $didColorTabClikced, didGradientTabClicked: $didGradientTabClikced, didBackgroundTabClicked: $didBackgroundTabClikced, didTextureTabClicked: $didTextureTabClikced, didGalleryTabClicked: $didGalleryTabClikced, didBlurTabClicked: $didBlurTabClikced, didOverlayTabClicked: $didOverlayTabClikced, lastSelectedTab: $actionStates.lastSelectedTextTab, delegate: delegate).frame(height: panelHeight)
////                .padding(.bottom, bottomPadding)
//        }
////        .halfSheet(showSheet: $didGalleryTabClikced) {
////            ZStack {
////                    Color.accentColor
////                    VStack {
////                        Text("Neeshu Kumar").font(.title.bold()).foregroundColor(.white)
////                        
////                        Button{
////                            didGalleryTabClikced.toggle()
////                        }label: {
////                            Text("Close the sheet").foregroundColor(.white)
////                        }
////                    }
////                }.ignoresSafeArea()
////            }
////        onEnd: {
////            print("Dismis")
////            didGalleryTabClikced.toggle()
////        }
//    }
//}

//#Preview {
//    BGContainer()
//}
