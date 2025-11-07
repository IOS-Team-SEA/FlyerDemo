//
//  AutoScrolling.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 21/10/24.
//
import SwiftUI

struct AutoScrollingTextView: View {
    var longText = "This is a long text that automatically scrolls when the space is smaller than the text."

    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var scrollTimer: Timer?

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                Text(longText)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .background(
                        GeometryReader { textGeometry in
                            Color.clear
                                .onAppear {
                                    // Set the width of the text once it appears
                                    textWidth = textGeometry.size.width
                                    startScrolling(in: geometry.size.width)
                                }
                        }
                    )
                   // .offset(x: offset)
                   // .animation(.linear(duration: 15).repeatForever(autoreverses: false), value: offset)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
//        .onDisappear {
//            scrollTimer?.invalidate() // Stop scrolling when view disappears
//        }
    }

    private func startScrolling(in containerWidth: CGFloat) {
        guard textWidth > containerWidth else { return } // No scrolling needed if text fits

        let width = containerWidth/2
        // Calculate the total distance to scroll (text width - container width)
        let totalDistance = textWidth - containerWidth
        
        // Reset the offset and start scrolling
        offset = width
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            offset -= 1
            if offset < -totalDistance {
                offset = width // Reset scroll to start from the right side again
            }
        }
    }
}

struct AutoWrappingTextView: View {
    var longText: String

    var body: some View {
        Text(longText)
            .font(.caption)
            .foregroundColor(.gray)
            .lineLimit(nil) // Allow unlimited lines
    }
}
