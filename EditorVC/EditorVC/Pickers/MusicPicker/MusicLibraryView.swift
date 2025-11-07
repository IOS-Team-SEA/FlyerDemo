//
//  MusicLibraryView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 14/03/24.
//

import SwiftUI
import MediaPlayer
import MobileCoreServices
import IOS_CommonEditor

struct MusicLibraryView: View {
    
    @StateObject private var audioPlayer = AudioPlayer.shared
    @StateObject var mediaPickerDelegate: MediaPickerDelegate
//    @State private var selectedAudioFiles: URL
    @State private var isFilePickerPresented = false
    @Binding var newMusicAdded: MusicModel
    @State var showAlertMessage: String = ""
    @State var showFilesAlert: Bool = false
//    @State private var showAlert = false
//    @State private var showSuccessAlert = false
    
    init(newMusicAdded: Binding<MusicModel>) {
        self._newMusicAdded = newMusicAdded
        self._mediaPickerDelegate = StateObject(wrappedValue: MediaPickerDelegate(newMusicAdded: newMusicAdded, isLoading: .constant(false)))
    }
    
    var body: some View {
        
        VStack{
            if mediaPickerDelegate.isLoading.wrappedValue {
                ProgressView("Loading_") // Display loader while loading
                    .padding()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            } else {
                SwiftUI.Image("ic_ImportAudio")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                Text("Import_audio_from")
                    .foregroundColor(.gray)
                    .bold()
                    .padding(.top, 10)
                
                HStack(spacing: 10){
                    
                    Button {
                        addMusicFromiTunes()
                    } label: {
                        Text("Itunes_")
                            .frame(width: 150, height: 40)
                    }
                    .foregroundColor(.white)
                    .frame(width: 150, height: 40)
                    .background(AppStyle.accentColor_SwiftUI)
                    .cornerRadius(8.0)
                    
                    
                    //                Button("Itunes_"){
                    //                    addMusicFromiTunes()
                    //
                    //                }
                    //                .foregroundColor(.white)
                    //                .frame(width: 150, height: 40)
                    //                .background(AppStyle.accentColor_SwiftUI)
                    //                .cornerRadius(8.0)
                    
                    Button {
                        isFilePickerPresented.toggle()
                    } label: {
                        Text("Files_")
                            .frame(width: 150, height: 40)
                    }
                    .foregroundColor(.white)
                    .frame(width: 150, height: 40)
                    .background(AppStyle.accentColor_SwiftUI)
                    .cornerRadius(8.0)
                    //
                    //                Button("Files_"){
                    //                    isFilePickerPresented.toggle()
                    //                }
                    //                .foregroundColor(.white)
                    //                .frame(width: 150, height: 40)
                    //                .background(AppStyle.accentColor_SwiftUI)
                    //                .cornerRadius(8.0)
                    .sheet(isPresented: $mediaPickerDelegate.isPresented) {
                        mediaPickerDelegate.mediaPicker
                    }
                    .alert(isPresented: $mediaPickerDelegate.showItunesAlert) {
                        Alert(
                            title: Text("Music_Added"),
                            message: Text(mediaPickerDelegate.showAlertMessage),
                            dismissButton: .default(Text("OK_"))
                        )
                    }
                    .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.audio]) { result in
                        switch result {
                        case .success(let url):
                            // Handle the selected file URL
                            print("Selected file URL: \(url)")
                            
//                            do {
//                                
//                                // Audio playher test
//                                let uuid = UUID()
//                                let data = try Data(contentsOf: url)
//                                var musicData = File(name: "\(uuid)", data: data, fileExtension: "mp3")
//                                try AppFileManager.shared.music?.addFile(file: &musicData)
//                                
//                                var musicModel = MusicModel()
//                                musicModel.localPath = musicData.url?.absoluteString ?? ""
//                                //                                musicModel.musicName = mi.title ?? "Unknown Title"
//                                //                                musicModel.duration = Float(song.playbackDuration)
//                                newMusicAdded = musicModel
//                                //                                playAudio(from: url)
//                                successMessage = "Music successfully added"
//                                print("Music added to file \(musicModel)")
//                            } catch {
//                                errorMessage = "\(error.localizedDescription)"
//                                print("Failed to save file with error: \(error.localizedDescription)")
//                            }
//                            //                            print("\(mediaPickerDelegate.selectedAudioFiles)")
//                            //                        }
                            
                            if url.startAccessingSecurityScopedResource() {
                                defer { url.stopAccessingSecurityScopedResource() } // Ensure we stop accessing the resource when done
                                
                                do {
                                    let uuid = UUID()
                                    let data = try Data(contentsOf: url) // Read data from the file
                                    
                                    let fileName = url.deletingPathExtension().lastPathComponent
                                    
                                    // Save file using your file management logic
                                    var musicData = File(name: "\(uuid)", data: data, fileExtension: "mp3")
                                    try AppFileManager.shared.localMusic?.addFile(file: &musicData)
                                    
                                    let musicPath = "\(uuid).mp3"
                                    var musicModel = MusicModel()
                                    musicModel.localPath = musicPath
                                    musicModel.musicName = "\(fileName).mp3"
                                    musicModel.musicType = "USER"
                                    newMusicAdded = musicModel
                                    
//                                    mediaPickerDelegate.successMessage = "Music successfully added"
                                    showAlertMessage = "Music_successfully_added".translate()
                                    showFilesAlert = true
                                    print("Music added to file \(musicModel)")
                                    
                                } catch {
//                                    mediaPickerDelegate.errorMessage = "\(error.localizedDescription)"
                                    showAlertMessage = "\(error.localizedDescription)"
                                    showFilesAlert = true
                                    print("Failed to save file with error: \(error.localizedDescription)")
                                }
                            } else {
                                // If the security-scoped resource could not be accessed, handle the error
//                                mediaPickerDelegate.errorMessage = "Unable to access file"
                                showAlertMessage = "Unable_to_access_file".translate()
                                showFilesAlert = true
                                print("Failed to access the file")
                            }
                        case .failure(let error):
                            // Handle error
//                            mediaPickerDelegate.errorMessage = "\(error.localizedDescription)"
                            showAlertMessage = "\(error.localizedDescription)"
                            showFilesAlert = true
                            print("File picking failed with error: \(error.localizedDescription)")
                        }
                    }
                    
                }
                .padding(.top, 10)
            }
        }
        .alert(isPresented: $showFilesAlert){
            Alert(title: Text(""), message: Text(showAlertMessage), dismissButton: .default(Text("OK_".translate())))
        }
        .padding(.horizontal)
        .padding(.vertical, 50)
        .onDisappear(){
            audioPlayer.audioPlayer?.stop()
        }
        
    }
        
    
    func addMusicFromiTunes() {
        MPMediaLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    mediaPickerDelegate.isPresented = true
                } else {
                    // Handle authorization denied
                    showAlertMessage = "Access_to_the_music_library_was_denied".translate()
                    showFilesAlert = true
                    print("denied access")
                }
            }
        }
    }
    
}

//#Preview {
//    MusicLibraryView()
//}

class MediaPickerDelegate: NSObject, MPMediaPickerControllerDelegate, ObservableObject {
    @Published var isPresented = false
    @Published var selectedAudioFiles: URL?
//    @Published var errorMessage: String? = nil
//    @Published var successMessage: String? = nil
    var newMusicAdded: Binding<MusicModel>
    var isLoading: Binding<Bool>
    @Published var showAlertMessage: String = ""
    @Published var showItunesAlert: Bool = false
    
    init(newMusicAdded: Binding<MusicModel>, isLoading: Binding<Bool>){
        self.newMusicAdded = newMusicAdded
        self.isLoading = isLoading
    }
    
    var mediaPicker: UIViewControllerRepresentableWrapper {
        let picker = MPMediaPickerController(mediaTypes: .music)
        picker.allowsPickingMultipleItems = true
        picker.showsCloudItems = false
        picker.delegate = self
        return UIViewControllerRepresentableWrapper(controller: picker)
    }
    
    func exportMediaItem(_ mediaItem: MPMediaItem, completion: @escaping (URL?, Error?) -> Void) {
        guard let assetURL = mediaItem.assetURL else {
            showAlertMessage = "Error \n No asset URL found for media item."
            completion(nil, NSError(domain: "com.yourapp.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No asset URL found for media item"]))
            return
        }
        
        isLoading.wrappedValue = true
        
        let outputFileName = "\(mediaItem.persistentID).m4a"
            let outputURL = getDocumentsDirectory().appendingPathComponent(outputFileName)

            // Check if the file already exists
            if FileManager.default.fileExists(atPath: outputURL.path) {
                completion(outputURL, nil)
                return
            }
        
        let asset = AVURLAsset(url: assetURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
//        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(mediaItem.persistentID).m4a")
        
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .m4a
        
        exportSession?.exportAsynchronously {
            switch exportSession?.status {
            case .completed:
                completion(outputURL, nil)
            case .failed:
                self.showAlertMessage = exportSession?.error?.localizedDescription ?? "Unknown error occurred."
                completion(nil, exportSession?.error)
            case .cancelled:
                self.showAlertMessage = "Export_session_was_cancelled".translate()
                completion(nil, NSError(domain: "com.yourapp.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Export session was cancelled"]))
            default:
                self.showAlertMessage = "Unknown_error_occurred".translate()
                completion(nil, NSError(domain: "com.yourapp.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
            }
        }
    }

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        guard let song = mediaItemCollection.items.first else { return }
        
        let outputFileName = "\(song.persistentID).mp3"
            let outputURL = getDocumentsDirectory().appendingPathComponent(outputFileName)

            // Check if the file already exists in the documents directory
        if FileManager.default.fileExists(atPath: outputURL.path) {
            // Use the existing file
            var musicModel = MusicModel()
            musicModel.localPath = outputURL.absoluteString
            musicModel.musicName = song.title ?? "Unknown Title"
            musicModel.duration = Float(song.playbackDuration)
            musicModel.musicType = "USER"
            self.newMusicAdded.wrappedValue = musicModel
            self.showAlertMessage = "Music_successfully_added".translate()
            self.showItunesAlert = true
            print("Music already exists at \(musicModel.localPath)")
        } else {
            exportMediaItem(song) { [weak self] url, error in
                guard let self = self else { return }
                
                if let url = url {
                    do {
                        let data = try Data(contentsOf: url)
                        var musicData = File(name: "\(song.persistentID)", data: data, fileExtension: "mp3")
                        try AppFileManager.shared.localMusic?.addFile(file: &musicData)
                        let musicPath = "\(song.persistentID).mp3"
                        
                        var musicModel = MusicModel()
                        musicModel.localPath = musicPath
                        musicModel.musicType = "USER"
                        musicModel.musicName = song.title ?? "Unknown Title"
                        musicModel.duration = Float(song.playbackDuration)
                        DispatchQueue.main.async {
                            self.showAlertMessage = "Music_successfully_added".translate()
                            self.showItunesAlert = true
                            self.newMusicAdded.wrappedValue = musicModel
                            self.isLoading.wrappedValue = true
                        }
                        
                        
                        print("Music added to file \(musicModel)")
                    } catch {
                        self.showAlertMessage = "Failed to save file: \(error.localizedDescription)"
                        self.showItunesAlert = true
                        print("Failed to save file with error: \(error.localizedDescription)")
                    }
                } else if let error = error {
                    self.showAlertMessage = "Failed to export media item: \(error.localizedDescription)"
                    self.showItunesAlert = true
                    print("Failed to export media item with error: \(error.localizedDescription)")
                }
            }
        }
        
//        mediaPicker.dismiss(animated: true, completion: nil)
        isPresented = false
    }
    
//    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
////        for item in mediaItemCollection.items {
////            // Handle each selected music item from iTunes
////            let title = item.title ?? "Unknown Title"
////            let artist = item.artist ?? "Unknown Artist"
////            let musicPath = item.assetURL?.absoluteString ?? ""
////            print("Title: \(title), Artist: \(artist), Path: \(musicPath), id2: \(item.persistentID)")
////            
////            
////            
////            if let assetURL = item.assetURL {
////                selectedAudioFiles = assetURL
////                exportMediaItem(item: item, assetURL: assetURL)
////                
////                //                print("\(selectedAudioFiles)")
////            }
////            
////        }
//        
//        guard let song = mediaItemCollection.items.first else { return }
//        
//        guard let url = song.value(forProperty: MPMediaItemPropertyAssetURL) as? URL else {
//            return
//        }
//        do {
//            let data = try Data(contentsOf: url)
//            var musicData = File(name: "\(song.persistentID)", data: data, fileExtension: "mp3")
//            try AppFileManager.shared.musicAssets?.addFile(file: &musicData)
//            
//            var musicModel = MusicModel()
//            musicModel.localPath = musicData.url?.absoluteString ?? ""
//            musicModel.musicName = song.title ?? "Unknown Title"
//            musicModel.duration = Float(song.playbackDuration)
//            self.newMusicAdded.wrappedValue = musicModel
//            
//            print("Music added to file \(musicModel)")
//        } catch {
//            print("Failed to save file with error: \(error.localizedDescription)")
//        }
//        
//        
//        print("url music : \(url)")
//        
//        mediaPicker.dismiss(animated: true, completion: nil)
//        isPresented = false
//    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
//    private func exportMediaItem(item: MPMediaItem, assetURL: URL) {
//        let asset = AVURLAsset(url: assetURL)
//        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
//            print("Failed to create export session")
//            return
//        }
//        
//        let fileName = "\(item.persistentID)"
//        let exportURL = getDocumentsDirectory().appendingPathComponent(fileName)
//        
//        
//        
//        exportSession.outputURL = exportURL
//        exportSession.outputFileType = .m4a
//        
//        exportSession.exportAsynchronously {
//            switch exportSession.status {
//            case .completed:
//                print("Export completed: \(exportURL)")
//                DispatchQueue.main.async {
//                    do {
//                        let data = try Data(contentsOf: exportURL)
//                        var musicData = File(name: fileName, data: data, fileExtension: "m4a")
//                        try AppFileManager.shared.music?.addFile(file: &musicData)
//                        
//                        var musicModel = MusicModel()
//                        musicModel.localPath = musicData.url?.absoluteString ?? ""
//                        musicModel.musicName = item.title ?? "Unknown Title"
//                        musicModel.duration = Float(item.playbackDuration)
//                        self.newMusicAdded.wrappedValue = musicModel
//                    } catch {
//                        print("Failed to save file with error: \(error.localizedDescription)")
//                    }
//                }
//            case .failed:
//                print("Export failed: \(exportSession.error?.localizedDescription ?? "Unknown error")")
//            case .cancelled:
//                print("Export cancelled")
//            default:
//                break
//            }
//        }
//    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = AppFileManager.shared.music?.url//FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths!
    }
}

struct UIViewControllerRepresentableWrapper: UIViewControllerRepresentable {
    let controller: UIViewController
   
    
    func makeUIViewController(context: Context) -> UIViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No update needed
    }
}
