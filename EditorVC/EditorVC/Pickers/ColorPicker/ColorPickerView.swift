//
//  ColorPicker.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 18/03/24.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var color: Color
    
    var body: some View {
        ColorPicker("Pick a color", selection: $color, supportsOpacity: false)
            
    }
}

//#Preview {
//    ColorPicker()
//}

