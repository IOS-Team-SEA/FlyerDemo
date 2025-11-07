//
//  FontsGridView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 15/03/24.
//

import SwiftUI
import IOS_CommonEditor

struct FontsGridView: View {
    
    @Binding var fontInfo: [FontModel]
    @Binding var currentFont: UIFont
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(fontInfo, id: \.self){ font in
                    Text(font.fontName)
                        .font(SwiftUI.Font.custom(font.fontName, size: 16))
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            currentFont = UIFont(name: font.fontFamily, size: 14)!
//                            currentFont = font
                            print("\(currentFont)")
                        }
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    FontsGridView()
//}
