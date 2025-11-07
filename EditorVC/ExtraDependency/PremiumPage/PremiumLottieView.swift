//
//  LottieView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 18/09/24.
//


import SwiftUI
import Lottie

struct PremiumLottieView: UIViewRepresentable {
    var animationName: String
    var loopMode: LottieLoopMode = .playOnce
    @Binding var isCompleted : Bool 

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(name: "congratsBlast")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        animationView.play { completed in
            isCompleted = true
        }
        
        // Add animationView as a subview
        view.addSubview(animationView)
        
        // Set up constraints for animationView
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Update the view as necessary
    }
}


