//
//  EngineViewSwiftUI.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 24/04/25.
//
import SwiftUI
import UIKit


enum PreviewPoint {
    case ResponsePage
    case Others
}


struct MetalPreviewView : View {
    @StateObject var engine : MetalEngine
    
    let id: Int
//    @State var width: CGFloat
//    @State var height: CGFloat
    @State var canLoadMusic : Bool = false
    @State var loaderState = LoaderState()
    var thumbImage: UIImage
    var displayWidth: CGFloat // UIScreen.main.bounds.width
   @State var displayHeight: CGFloat // UIScreen.main.bounds.width
    @EnvironmentObject var uiStateManager: UIStateManager
    @State var autoPlay: Bool = false  // UIScreen.main.bounds.width
    
    @State var previewPoint : PreviewPoint = .Others
    
    init(templateId: Int, thumbImage: UIImage, displayWidth: CGFloat, displayHeight: CGFloat , previewPoint : PreviewPoint = .Others){
        self.previewPoint = previewPoint
        self.id = templateId
        self.thumbImage = thumbImage
        self.displayWidth = displayWidth
        _displayHeight = State(wrappedValue: displayHeight)
        _engine = StateObject(wrappedValue: Injection.shared.inject(id: "MetalPreviewView_\(templateId)", type: MetalEngine.self)!)
        
    }
    
    func toggle() {
        printLog("Tapped:-")
        if let templateHandler = engine.templateHandler {
            templateHandler.playerControls?.renderState = engine.templateHandler.playerControls?.renderState == .Playing ? .Paused : .Playing
        }
    }
    
    var body: some View {
        
        ZStack{
            //            if engine.fetchStatus == .InProgress || engine.fetchStatus == .Idle {
            //                ProgressView(value: engine.progressUnit, total: 1.0)
            //                    .progressViewStyle(.circular)
            //                .frame(width:displayWidth,height:displayHeight)
            //            }
            
            
            ZStack(alignment: .topLeading) {
                    
                    //            switch engine.fetchStatus {
                    //
                    //            case .InProgress , .Idle:
                    //
                    //                ProgressView("Loading...", value: engine.progressUnit, total: 1.0)
                    //                    .frame(width:displayWidth,height:displayHeight+60)
                    //
                    //            case .Success:
                    EditorUIView(engine: engine, size: CGSize(width: displayWidth, height: displayHeight))
                        .frame(width: displayWidth,height: displayHeight)
                        .opacity(canLoadMusic ? 1.0 : 0.0)
                        .background(Color.clear)
                        .contentShape(Rectangle()) // << makes the area tappable

                        .overlay(
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        toggle()
                                    }
                            )
                        
                    if canLoadMusic {
                        VStack{
                            Spacer()
                            MusicControlView(templateHandler: engine.templateHandler, playerVm: engine.templateHandler.playerControls!, actionStates: engine.templateHandler.currentActionState)
                                .frame(width:displayWidth,height:60)
                        }
                        MuteControl(isMute: $engine.templateHandler.currentActionState.isMute)

                    }
                    
                    //            case .Failed:
                    //                Text("Failed To Load")
                    //                    .frame(width:displayWidth,height:displayHeight+60)
                    //            case .NoInternet:
                    //                Text("No Internet")
                    //                    .frame(width:displayWidth,height:displayHeight+60)
                    //            }
                    //
                }
                .overlay {
                    if engine.fetchStatus == .InProgress || engine.fetchStatus == .Idle{
                        TemplateLoader(loaderState: loaderState , maxDimensions: CGSize(width: displayWidth, height: displayHeight))
                            .frame(width: displayWidth,height: displayHeight)
                            .cornerRadius(10)
//                            .environmentObject(uiStateManager)
                    }
                }
            
           
        }
        
        .onChange(of: engine.fetchStatus, perform: { newValue in
            if newValue == .Success {
                engine.sceneManager.setTemplateHandler(templateHandler: engine.templateHandler)
                canLoadMusic = true
                printLog("DidSuccess")
                if autoPlay {
                    engine.templateHandler.playerControls?.renderState = .Playing
                }
            }
        })
     
        .task {
            if engine.fetchStatus != .Success {
                await engine.prepareScene4(templateID: id, refSize: CGSize(width: displayWidth, height: displayHeight), loadThumbnails: false , shouldCheckTempalteWaterrmark: previewPoint == .ResponsePage)
            } else {
//                engine.editorView?.frame.size = CGSize(width: displayWidth, height: displayHeight)
//                engine.changeSize(newBaseSize: CGSize(width: displayWidth, height: displayHeight))
//                canLoadMusic = true

            }
        }
        .onAppear(){
            loaderState.image = thumbImage
            engine.isDBDisabled = true
        }
    }
}

struct EditorUIView: UIViewRepresentable {
    
    let engine: MetalEngine
    let size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        // Create and setup EditorView
        return engine.getLazyEditorView(frame: CGRect(origin: .zero, size: size))
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Optional: adjust frame if size changes dynamically
//        engine.editorView?.superview?.frame = CGRect(origin: .zero, size: size)
        engine.editorView?.frame = CGRect(origin: .zero, size: size)
        engine.editorView?.updateCenter()
    }
}
