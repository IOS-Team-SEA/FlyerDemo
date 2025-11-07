//
//  BlastEffectOverlay.swift
//  VideoInvitation
//
//  Created by J D on 28/10/25.
//


import SwiftUI

struct BlastEffectOverlay: ViewModifier {
    @Binding var hideBlast: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if !hideBlast {
                    PremiumLottieView(
                        animationName: "blastEffect",
                        loopMode: .playOnce,
                        isCompleted: $hideBlast
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        vibrate()
                    }
                }
            }
    }

   
}
extension View {
    func blastEffectOverlay(hideBlast: Binding<Bool>) -> some View {
        self.modifier(BlastEffectOverlay(hideBlast: hideBlast))
    }
}
