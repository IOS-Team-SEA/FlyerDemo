//
//  SelectThumbnailView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 04/06/24.
//

import SwiftUI
import IOS_CommonEditor

struct SelectThumbnailView : View {
    @State private var isVisible = true
    @Binding var thumbnailImage: UIImage?
    @State var isSavingOptionsPresented = false
    @State private var showAlert = false
    @Binding var watchAdsTapped: Bool
    @Binding var goPremiumTapped: Bool
    @Binding var isLastSelectedModel: Bool
    @ObservedObject var exportSettings = ExportSettings()
    @EnvironmentObject var uiStateManager : UIStateManager
    @State private var shakeOffset: CGFloat = 0
    @State private var isShaking = false
   
    @State private var isWatermarkRemoved = false
    @State var isPremium: Bool = false

    var body: some View {
//        ZStack{
//            VStack{
//                HStack{
//                    VStack{
//                        Button {
//                            isLastSelectedModel = false
//                            
//                        } label: {
//                            VStack{
//                                Image("ic_Close")
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .foregroundColor(.label)
//                                    .frame(width: 20, height: 20)
//                                    
//                            }
//                            .frame(width: 30, height: 30)
//                            .background(Color.gray)
//                            .clipShape(Circle())
//                        }
//                        
//
//                    }
//                    Spacer()
//                }
//                Spacer()
//            }
//            .padding()
//        ZStack(alignment: .topTrailing, content: {
           
               
            
        VStack(spacing: DS.Spacing.sixteen){
                
//                HStack {
//                    Spacer()
//                    Button {
//                                        isLastSelectedModel = false
//            
//                                    } label: {
//                                        VStack{
//                                            Image(systemName: "xmark")
//                                                .resizable()
//                                                .frame(width: 15, height: 15)
//                                          
//                                        }
//                                        .frame(width: 44, height: 44)
//                                        .background(Color.clear)
//                                        .clipShape(Circle())
//                                    }.tint(.accent)
//                }
    
//                Spacer(minLength: 44)
                if !uiStateManager.isPremium{
                    HStack{
                        Button {
                            
                            goPremiumTapped = true
                            
                        } label: {
                            HStack{
                                Text("Remove_Watermark")
                                    .font(.body)
                                    .foregroundColor(Color.accentColor)
                                    .padding(.leading)
                                if !uiStateManager.isPremium{
                                    SwiftUI.Image("premiumIcon")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.bottom, 10)
                                }
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $isWatermarkRemoved)
                                .frame(width: 50)
                                .padding(.trailing)
                                .disabled(!uiStateManager.isPremium)
                            
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
           
            PrimaryButton(title: "Save_in_PNG_".translate(), icon: nil, isFullWidth: true, action: {
                exportSettings.exportImageFormat = ExportPhotoFormat.PNG
                        if uiStateManager.isPremium {
                            watchAdsTapped = true
                        } else {
                            showAlert.toggle()
                        }
                    } ) //.padding(.horizontal)
                    
            PrimaryButton(title: "Save_in_JPG_".translate(), icon: nil,isFullWidth: true, action: {
                        exportSettings.exportImageFormat = .JPEG
                        if uiStateManager.isPremium {
                            watchAdsTapped = true
                        } else {
                            showAlert.toggle()
                        }
                    } ) //.padding(.horizontal)
            
                Spacer()
                }
                
            .padding(.horizontal, DS.Spacing.sixteen)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Continue_Saving"),
                        message: Text("Saving_Message"),
                        primaryButton: .default(Text("Watch_Ads"), action: {
                            // Action for Watch Ads
                            watchAdsTapped = true
                        }),
                        secondaryButton: .cancel(Text("Go_Premium"), action: {
                            // Action for Go Premium
                            goPremiumTapped = true
                        })
                    )
                }

            
//        })
    }
    
    func startShaking() {
          isShaking = true
          withAnimation(Animation.linear(duration: 0.1).repeatForever(autoreverses: true)) {
              shakeOffset = 5
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              withAnimation(Animation.linear(duration: 0.1).repeatForever(autoreverses: true)) {
                  shakeOffset = -5
              }
          }
      }
    
    private func startBlinking() {
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.6)) {
                isVisible.toggle()
            }
        }
     }
}

//#Preview {
//    SelectThumbnailView(watchAdsTapped: .constant(false), goPremiumTapped: .constant(false))
//}
