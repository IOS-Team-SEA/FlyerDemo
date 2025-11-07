//
//  UnsplashRow.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 18/03/24.
//

import SwiftUI
import UIKit

struct UnsplashRow: View {
    var photo: Photo
    @Binding var isImagePickerPresented : Bool

    var body: some View {
        VStack{
            Text("")
            if let fullURLString = photo.urls["regular"], let fullURL = URL(string: fullURLString) {
                    VStack {
                        AsyncImage(url: fullURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 180)
                                    .cornerRadius(8.0)
                                    .shadow(radius: 4.0)
                            case .failure(_):
                                // Placeholder or error image
                                SwiftUI.Image("img")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 180)
                            case .empty:
                                // Placeholder or loading indicator
                                ProgressView()
                                    .frame(width: 180, height: 180)
                            @unknown default:
                                // Placeholder or error image
                                SwiftUI.Image("img")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 180)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
            } else {
                // Handle case where "full" URL is not present
                EmptyView()
            }
        }
    }
}

//#Preview {
//    UnsplashRow()
//}
