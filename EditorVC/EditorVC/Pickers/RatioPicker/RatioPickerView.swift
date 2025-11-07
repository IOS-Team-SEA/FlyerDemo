//
//  RatioPickerView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 13/03/24.
//

import SwiftUI

//struct RatioPickerView: View {
//    
////    @ObservedObject var viewModel: TemplateViewModel
//    @Binding var isRatioPickerPresented: Bool
//    @Binding var isStickerPickerPresented: Bool
//    @Binding var isMusicPickerPresented: Bool
//    @Binding var isFontsPickerPresented: Bool
//    @Binding var isColorPickerPresented: Bool
//    @Binding var isImagePickerPresented: Bool
//    @Binding var isTextPickerPresented: Bool
//    @Binding var isAnimPickerPresented: Bool
//    @State var cropView: Bool = false
//    
//    @State var stickerInfo: [String:String] = [:]
//    @State var uniqueCategories: [String] = []
//    @State var animTempalate: [DBAnimationTemplateModel] = []
//    @State var animCategory: [DBAnimationCategoriesModel] = []
//    
//    @State var musicInfo: [MusicModel] = []
//    @State var fontInfo: [FontModel] = []
//    @State var color: Color = .red
//    @State var selectColor: UIColor = .red
//    
//    var body: some View {
//        VStack{
//            HStack{
//                Button("Ratio") {
//                    isRatioPickerPresented = true
//                }.sheet(isPresented: $isRatioPickerPresented) {
//                    NavigationView{
////                        RatioGridView(viewModel: viewModel)
////                            .navigationTitle("Ratio")
//                    }
//                }
//                
//                Button("Sticker"){
//                    isStickerPickerPresented = true
//                }.sheet(isPresented: $isStickerPickerPresented){
//                    
//                    NavigationView {
////                        StickerPicker(stickerInfo: $stickerInfo, isStickerPickerPresented: $isStickerPickerPresented, uniqueCategories: $uniqueCategories)
////                            .navigationTitle("Stickers")
//                    }
//                }
//                
//                Button("Music"){
//                    isMusicPickerPresented = true
//                }.sheet(isPresented: $isMusicPickerPresented){
//                    //                    MusicPicker(MusicInfo: $musicIn, newMusicAdded: fo)
//                }
//                
//                Button("Color"){
//                    isColorPickerPresented = true
//                }.sheet(isPresented: $isColorPickerPresented) {
//                    ColorPickerView(color: $color)
//                }
//                
//                Button("Image"){
//                    isImagePickerPresented = true
//                }.sheet(isPresented: $isImagePickerPresented) {
////                    ImagePickerView()
////                    TexturePanelView(tileSize: 1, resId: "", imageType: .TEXTURE)
////                    CustomColorPicker(selectedColor: $selectColor, isPresented: $isImagePickerPresented)
//                    //MusicControlView(playerVm: <#PlayerControls#>)
//                }
//                
////                Button("Text"){
////                    isTextPickerPresented = true
////                }.sheet(isPresented: $isTextPickerPresented) {
////                    TextEditorView(isTextPickerPresented: $isTextPickerPresented)
////                }
//                
////                Button("Fonts"){
////                    isFontsPickerPresented = true
////                }
////                .sheet(isPresented: $isFontsPickerPresented){
////                    NavigationView{
////                        FontsPicker(fontInfo: $fontInfo)
////                            .navigationTitle("Fonts")
////                    }
////                }
//                Button {
//                    cropView = true
//                } label: {
//                    Text("Crop")
//                        .foregroundColor(.blue)
//                }
//                .sheet(isPresented: $cropView) {
////                    CropperView()
//                }
//                Button("Anim"){
//                    isAnimPickerPresented = true
//                }
//            }
//            
//            Spacer()
//            VStack{
//                if isAnimPickerPresented{
////                    AnimationsPanelView(animationTemplate: $animTempalate, animationCategories: $animCategory)
//                }
//            }
//            .frame(width: 500, height: 200)
//            .background(.white)
//        }.padding(.bottom, 75)
//        
//            .onAppear(){
//                
//                // Jay?
//                print("\(animCategory)")
//            }
//        
//        
//        
//
//    }
//}

//#Preview {
//    RatioPickerView()
//}
