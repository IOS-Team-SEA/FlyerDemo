//
//  GifStickerPicker.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 07/01/25.
//

import SwiftUI
import WebKit

struct GifStickerPicker: View {
        
    var body: some View {
        GifStickerCategoriesRow().background(Color.systemBackground)
    }
    
    
}

//#Preview {
//    GifStickerPicker()
//}

struct GifStickerCategoriesRow: View {
    
    var gifsArray: [String] = ["love1","love2","love3","love4","love5","love6","love7","love8","love9","love10","love11","love12","love13","love14","love15","love16","love17","love18","love19","love20","love21","love22","love23","love24","love25","love26","love27","love28","love29","love30","food1","food2","food3","food4","food5","food6","food7","food8","food9","food10","food11","food12","food13","food14","food15","food16","food17","food18","food19","food20"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var selectedGif: String? = nil
    @State private var numberOfFrames: Int? = nil
    @State private var showAlert: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(gifsArray, id: \.self) { gif in
//                    VStack {
                        GifImageView(gif)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .onTapGesture {
                                extractGifData(for: gif)
                            }
//                    }
//                    .frame(width: 100, height: 100)
//                    
//                    .allowsHitTesting(true)
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("GIF Info"),
                message: Text("Number of frames: \(numberOfFrames ?? 0)"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func extractGifData(for gifName: String) {
        guard let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let gifData = try? Data(contentsOf: gifURL) else {
            print("GIF not found: \(gifName)")
            return
        }
        
        let gifFrames = getGifFrameCount(from: gifData)
        selectedGif = gifName
        numberOfFrames = gifFrames
        showAlert = true
    }
    
    func getGifFrameCount(from data: Data) -> Int {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return 0
        }
        
        let frameCount = CGImageSourceGetCount(source)
        return frameCount
    }
}

struct GifImageView: UIViewRepresentable {
    private let name: String
        init(_ name: String) {
            self.name = name
        }

        func makeUIView(context: Context) -> UIView {
            let container = UIView()
            container.isUserInteractionEnabled = true
            
            let webview = WKWebView()
            webview.isUserInteractionEnabled = false // Prevent webview from blocking touches
            
            let url = Bundle.main.url(forResource: name, withExtension: "gif")!
            let data = try! Data(contentsOf: url)
            webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
            
            container.addSubview(webview)
            webview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webview.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                webview.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                webview.topAnchor.constraint(equalTo: container.topAnchor),
                webview.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            ])
            
            return container
        }

        func updateUIView(_ uiView: UIView, context: Context) {
            guard let webview = uiView.subviews.first as? WKWebView else { return }
            webview.reload()
        }
}
