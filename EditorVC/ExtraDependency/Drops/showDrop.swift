//
//  showDrop.swift
//  HomeScreen
//
//  Created by Neeshu Kumar on 24/01/24.
//

import SwiftUI

struct showDrop: View {
    let drop = Drop(
        title: "Title",
        subtitle: "Subtitle",
        icon: UIImage(systemName: "star.fill"),
        action: .init {
            print("Drop tapped")
            Drops.hideCurrent()
        },
        position: .bottom,
        duration: 5.0,
        accessibility: "Alert: Title, Subtitle"
    )
    var body: some View {
        Button("Show Drop") {
            Drops.show(drop)
        }
    }
}

//#Preview {
//    showDrop()
//}
