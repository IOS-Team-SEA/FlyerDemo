//
//  FontsPicker.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 15/03/24.
//

import SwiftUI
import IOS_CommonEditor
import IOS_CommonUtilSPM

let fontMapping: [String: String] = [
    "ffont6": "Aachen BT",
    "ffontt2": "Jokerman",
    "ffontt22": "Midnight Regular",
    "ffont15": "Chiller",
    "ffontt9": "Vintage Notes",
    "ffont47": "Tendrils",
    "ffontt29": "Ocean Breeze",
    "ffont41": "Shorelines",
    "OPENSANS_SEMIBOLD": "OpenSans",
    "ffont46": "St Ryde",
    "ffont23": "HazelLet",
    "ffontt6": "Urban Regular",
    "ffont39": "Rosewood",
    "ffontt19": "Retro Sketch",
    "ffontt23": "Elegant Script",
    "ffont24": "HorndonD",
    "ffontt28": "Casual Marker",
    "ffontt5": "Neon Nights",
    "ffontt30": "Shadow Play",
    "ffontt7": "Galaxy Regular",
    "ffontt10": "Soft Touch",
    "ffontt35": "Paper Cut",
    "ffont33": "OriginalsisOut",
    "ffont3": "Academy Engraved",
    "ffontt15": "Sunrise Script",
    "ffontt18": "Pixel Dust",
    "ffont10": "Bauhaus ITC",
    "ffontt34": "Retro Frame",
    "Roboto-Regular": "Roboto Regular",
    "ffontt3": "Bluebird Regular",
    "ffont42": "Showcard Gothic",
    "ffont7": "Abril Fatface",
    "ffont11": "Beauty School",
    "ffont51": "Velvet Queen",
    "ffontt25": "Happy Hand",
    "ffontt31": "Smooth Brush",
    "ffont20": "French Script",
    "ffont19": "Frankenstein",
    "ffont27": "Justov",
    "ffont31": "Mexcellent 3D",
    "ffontt11": "Delicate Dream",
    "ffontt38": "Silver Sands",
    "ffontt26": "Royal Ink",
    "ffontt24": "Simple Joys",
    "ffont52": "Westminster",
    "ffontt37": "Bold Horizon",
    "ffont25": "Impact",
    "ffont9": "BinnerD",
    "ffontt14": "Neon Type",
    "ffont44": "SquareSlabserif711BT-Bold",
    "ffontt17": "Golden Edge",
    "ffontt33": "Midday Classic",
    "ffont29": "Life is Messy",
    "SANSATION_BOLD": "Sansation Bold",
    "ffontt36": "Sharp Cut",
    "ffont49": "Typist Condensed",
    "ffont38": "Rockwell",
    "ffont17": "Creepy",
    "ffont30": "Wake Me Up",
    "ffont50": "Typist Normal",
    "ffontt13": "Lovely Note",
    "ffontt1": "Dream Regular",
    "ffontt8": "Charming Hand",
    "ffont13": "Billie Kid",
    "ffont45": "Square Slabser",
    "ffont34": "Pico White",
    "ffontt27": "Magic Stone",
    "ffont37": "Chiseled",
    "ffontt20": "Night Glow",
    "ffontt32": "Morning Glory",
    "ffont14": "Elegant Regular",
    "ffont18": "Designio Bold",
    "ffont4": "Victorian",
    "ffont35": "Printed Circuit",
    "ffont1": "28 Days Later",
    "ffont5": "215000E",
    "ffont43": "Slipstream",
    "ffont48": "Trebuchet",
    "ffont22": "Harlow Solid",
    "ffont36": "Digital",
    "ffont12": "Bertram",
    "ffontt4": "Flow Script",
    "ffont32": "Old English Text",
    "ffont16": "Colonna",
    "ffontt39": "Cosmic Dust",
    "ffont21": "Futura Black",
    "ffontt16": "Silver Fox",
    "ffontt12": "Fresh Marker",
    "ffont40": "Sho Card Caps",
    "ffont8": "Adam Gorry",
    "ffont28": "Radio Wizard",
    "ffont2": "Jokerman",
    "ffontt21": "Ocean Ink",
    "SANSATION_REGULAR": "Sansation Regular",
    "ffont26": "Incised 901BT"
]
//[
//
//    "defaultfont": "font45",
//        "ffont": "Frankenstein",
//        "ffont1": "28 Days Later",
//        "ffont2": "Jokerman LET",
//        "ffont3": "Academy Engraved LET",
//        "ffont4": "Victorian LET",
//        "ffont5": "215000E",
//        "ffont6": "Aachen BT",
//        "ffont7": "Abril Fatface",
//        "ffont8": "AdamGorry-Inline",
//        "ffont9": "BinnerD",
//        "ffont10": "Bauhaus Md BT",
//        "ffont11": "BeautySchoolDropout||",
//        "ffont12": "Bertran LET",
//        "ffont13": "Billie Kid",
//        "ffont14": "",
//        "ffont15": "Chiller",
//        "ffont16": "Colonna MT",
//        "ffont17": "Creepy",
//        "ffont18": "Sans Serif",
//        "ffont19": "Sans Serif",
//        "ffont19_orig": "Frankenstein",
//        "ffont20": "French Script MT",
//        "ffont21": "FuturaBlack BT",
//        "ffont22": "Harlow Solid Italic",
//        "ffont23": "Hazel LET",
//        "ffont24": "HorndonD",
//        "ffont25": "Impact",
//        "ffont26": "Incised901 Ct BT",
//        "ffont27": "Justov",
//        "ffont28": "KBRadio Wizard",
//        "ffont29": "KG Life is Messy",
//        "ffont30": "KG Wake me Up",
//        "ffont31": "Mexcellent 3D",
//        "ffont32": "Old English Text MT",
//        "ffont33": "Originals is Out",
//        "ffont34": "Pico White AI",
//        "ffont35": "Printed Circuit Board",
//        "ffont36": "Digital SF",
//        "ffont37": "Brannt Plus Chiseled NCV",
//        "ffont38": "Rockwell",
//        "ffont39": "Rosewood Std Regualr",
//        "ffont40": "ShoCard Caps NF",
//        "ffont41": "Shorelines Script Bold",
//        "ffont42": "Showcard Gothic",
//        "ffont43": "Slipstream LET",
//        "ffont44": "SquareSlab711 Bd BT",
//        "ffont45": "SquareSlab711 Lt BT",
//        "ffont46": "St Ryde Regular",
//        "ffont47": "Tendrils",
//        "ffont48": "Trebuchet MS",
//        "ffont49": "Typist Condensed",
//        "ffont50": "Typist",
//        "ffont51": "Velvet Queen",
//        "ffont52": "Westminster",
//        "font1": "Segoe Script",
//        "font2": "Anaconda",
//        "font3": "Advertising Script",
//        "font4": "Angilla Tattoo Personal Use",
//        "font5": "Angsana New",
//        "font6": "Arial",
//        "font7": "Arial Italic",
//        "font8": "at most sphere",
//        "font9": "Bauhaus",
//        "font10": "Android Nation",
//        "font11": "Beyond Wonderland",
//        "font12": "Boomtown Deco",
//        "font13": "CalliGravity",
//        "font14": "CarnivalMF",
//        "font15": "Cosmic Love",
//        "font16": "Bunga Melati Putih",
//        "font17": "Elsie Swash Caps Black",
//        "font18": "Exquisite Corpse",
//        "font19": "Fine College",
//        "font20": "A Box For",
//        "font21": "Post Rock",
//        "font22": "Grand Hotel",
//        "font23": "Gravicon",
//        "font24": "Sweet Lollipop",
//        "font25": "KBAStitchlin Time",
//        "font26": "KB Birthday Letters",
//        "font27": "Lesser Concern Shadow",
//        "font28": "Lesser Concern",
//        "font29": "Lycanthrope",
//        "font30": "Android Insomnia",
//        "font31": "Majoram Sans",
//        "font32": "Painting the light",
//        "font33": "Ostrich Sans Inline",
//        "font34": "PicoBlackAI",
//        "font35": "PicoWhiteAI",
//        "font36": "Queen of Heaven",
//        "font37": "QuentinCaps",
//        "font38": "QuigleyWiggly",
//        "font39": "RowdyBubble",
//        "font40": "RowdyFunky",
//        "font41": "Segoe Print",
//        "font42": "Squealer Embossed",
//        "font43": "Still Time",
//        "font44": "Think Techno",
//        "font45": "Cabin Medium",
//        "font46": "Halloween Day",
//        "font47": "Midnight Minutes",
//        "font48": "Slime Trail",
//        "font49": "Great Vibes",
//        "font50": "Signatra DEMO",
//        "font51": "Hattinand",
//        "font52": "Dancing Script",
//        "font53": "Slabthing",
//        "font54": "Smoothy Bubble",
//        "font55": "Sporken",
//        "font56": "Altery One",
//        "font57": "whisholder",
//        "font58": "August Stories",
//        "font59": "Kalufonia",
//        "font60": "Sylfaen",
//        "font61": "James Stroker",
//        "font62": "Cantora One",
//        "font63": "Neufreit Extra Bold",
//        "font64": "Raintown",
//        "font65": "Ribeye Marrow",
//        "font66": "Milonga",
//        "font67": "Nickainley Normal",
//        "font68": "Wishingly",
//        "font69": "Arial Rounded MT Bold",
//        "font70": "Daughter of Fortune"
//]
struct FontsPicker: View {
    
    @State var fontInfo: [FontModel] = []
    @State var appFontArray: [String] = [
        "ffont1","ffont2","ffont3","ffont4","ffont5","ffont6","ffont7","ffont8","ffont9","ffont10","ffont11","ffont12","ffont13","ffont14","ffont15","ffont16","ffont17","ffont18","ffont19","ffont20","ffont21","ffont22","ffont23","ffont24","ffont25","ffont26","ffont27","ffont28","ffont29","ffont30","ffont31","ffont32","ffont33","ffont34","ffont35","ffont36","ffont37","ffont38","ffont39","ffont40","ffont41","ffont42","ffont43","ffont44","ffont45","ffont46","ffont47","ffont48","ffont49","ffont50","ffont51","ffont52",
        "ffontt1","ffontt2","ffontt3","ffontt4","ffontt5","ffontt6","ffontt7","ffontt8","ffontt9","ffontt10","ffontt11","ffontt12","ffontt13","ffontt14","ffontt15","ffontt16","ffontt17","ffontt18","ffontt19","ffontt20","ffontt21","ffontt22","ffontt23","ffontt24","ffontt25","ffontt26","ffontt27","ffontt28","ffontt29","ffontt30","ffontt31","ffontt32","ffontt33","ffontt34","ffontt35","ffontt36","ffontt37","ffontt38","ffontt39",
        
            "OPENSANS_SEMIBOLD","SANSATION_BOLD", "SANSATION_REGULAR","Roboto-Regular"


    ]
    
    @Binding var currentFont: UIFont
    @Binding var lastSelectedFont: String
    @Binding var fontName : String
    @State var newFonts: [String] = []
    @Binding var updateThumb: Bool
    
    var columnsCommon: CGFloat{
        if UIDevice.current.userInterfaceIdiom == .pad{
            return 250
        }else{
            return 100
        }
    }
    
    var columns: [GridItem]{
        if UIDevice.current.userInterfaceIdiom == .pad{
            return Array(repeating: .init(.flexible()), count: 3)
        }else{
            return Array(repeating: .init(.flexible()), count: 3)
        }
    
    }// = Array(repeating: .init(.flexible()), count: 2)
    
    let section1Title = "New_Fonts".translate()
    let section2Title = "Default_Fonts".translate()
    
    
    
    
    var body: some View {
        ScrollViewReader{proxy in
            ScrollView(.vertical, showsIndicators: true) {
//                    VStack{
                    
                LazyVGrid(columns: columns , pinnedViews: .sectionHeaders) {
                            if !newFonts.isEmpty{
                                
                                Section {
                                    ForEach(newFonts, id: \.self){ font in
                                        
                                        FontCell(font: font.components(separatedBy: ".").first?.trimmingCharacters(in: .whitespacesAndNewlines), fontName: $fontName, lastSelectedFont: $lastSelectedFont, columnsCommon: columnsCommon)

                                        .onTapGesture {
                                            
                                            fontName = font
                                            updateThumb = true
                                            //                                lastSelectedFontID = font
                                        }
                                        
                                    }.padding(.horizontal)
                                } header: {
                                    HStack{
                                        Text(section1Title)
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.secondaryLabel)
                                            .padding(.leading)
                                        Spacer()
                                    }.frame(height:44)
                                    .background {
                                        VisualEffectView2()
                                    }
                                }
                                
                                
                            }
                            Section {

                                ForEach(appFontArray, id: \.self){ font  in
                                    
                                    FontCell(font: font, fontName: $fontName, lastSelectedFont: $lastSelectedFont, columnsCommon: columnsCommon)
                                        .onTapGesture {
                                            if font == "Default"{
                                                fontName = "defaultfont.ttf"
                                            }else{
                                                fontName = "\(font)\(fontExtenstion(fontName: font))"//font.fontLocalPath
                                            }
                                            updateThumb = true
                                        }
                                }.padding(.horizontal)
                            } header: {
                                HStack{
                                    Text(section2Title)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.secondaryLabel)
                                        .padding(.leading)
                                    Spacer()
                                }.frame(height:44)
                                    .background {
                                    VisualEffectView2()
                                }
                            }
                        }
                        
                        
//                    }
//                    .padding()
                
//                VStack{
//                    HStack{
//                        Text(section1Title)
//                            .font(.body)
//                            .fontWeight(.semibold)
//                            .foregroundStyle(.secondary)
//                        Spacer()
//                    }
//                    LazyVGrid(columns: columns) {
//                        ForEach(appFontArray, id: \.self){ font in
//                            
//                            FontCell(font: font, fontName: $fontName, lastSelectedFont: $lastSelectedFont, columnsCommon: columnsCommon)
////                            HStack{
////                                Text(font.fontDisplayName)
////                                    .font(.custom(getRealFont(nameOfFont: font.fontLocalPath), size: 14))
////                                    .foregroundColor(lastSelectedFontID == font.ID ? AppStyle.accentColor_SwiftUI : .label)
////                                    .padding()
////                                    .fixedSize(horizontal: true, vertical: true)
////                                    .id(font.ID)
////                                
////                            }
////                            .frame(width: columnsCommon, height: 30)
////                            .background(Color.secondarySystemBackground)
////                            .cornerRadius(5)
////                            .overlay(
////                                RoundedRectangle(cornerRadius: 5)
////                                    .stroke(lastSelectedFontID == font.ID ? AppStyle.accentColor_SwiftUI : .clear, lineWidth: lastSelectedFontID == font.ID ? 2 : 0)
////                            )
////                            .onTapGesture {
////                                
////                                fontName = font.fontLocalPath
////                                lastSelectedFontID = font.ID
////                                print("\(currentFont)")
////                            }
//                            
//                        }
//                    }
//                   
//                }
//                .padding()
                
            }.background(Color.systemBackground)
//            .padding(.top, 20)
            .onChange(of: fontName){ newFont in
                if newFont == "defaultfont.ttf"{
                    scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: "Default")
                }else{
                    scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: newFont.components(separatedBy: ".").first!)
                }
            }
            .onAppear(){
//                fontInfo = DBManager.shared.fetchAllFontModel()
//                print("font info: \(fontInfo)")
//                if !fontInfo.isEmpty {
//                    DispatchQueue.main.async {
                if fontName == "defaultfont.ttf"{
                    scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: "Default")
                }else{
                    scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: fontName.components(separatedBy: ".").first!)
                }
//                    }
//                }
                
                loadFontsFromDocuments()
            }
        }
        
    }
    
    func loadFontsFromDocuments(){
        let fileManager = FileManager.default
        
        guard let documentDirectory = AppFileManager.shared.getDirectoryPath(for: "FontAssets") else {
            return
        }
        
        do {
            let allFonts = try fileManager.contentsOfDirectory(atPath: documentDirectory.path)
            
            for font in allFonts{
                if font.contains(".ttf") || font.contains(".TTF") || font.contains(".otf"){
                    newFonts.append(font)
                }
            }
        }catch{
            
        }
    }
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: String) {
        // Find the ID of the last selected button and scroll to
        // Add more conditions for other tab states...
        
        // Scroll to the identified button
        //        withAnimation(.spring()) {
        //            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
        //        }
        
//        if fontInfo.contains(where: { $0.ID == scrollToID }) {
            withAnimation(.spring()) {
                scrollViewProxy.scrollTo(scrollToID, anchor: .center)
            }
//        } else {
//            print("Invalid scrollToID: \(scrollToID)")
//        }
        
    }
    
  
    
}

//#Preview {
//    FontsPicker(fontInfo: .constant(DBManager.shared.fetchAllFontModel()), currentFont: .constant(.systemFont(ofSize: 14)), lastSelectedFontID: .constant(1))
//}
func fontExtenstion(fontName: String) -> String{
    if let _ = Bundle.main.path(forResource: "\(fontName).ttf", ofType: nil){
        return ".ttf"
    }else if let _ =  Bundle.main.path(forResource: "\(fontName).TTF", ofType: nil){
        return ".TTF"
    }else{
        return ".otf"
    }
}


struct FontCell: View {
    @EnvironmentObject var dsStore : DataSourceStore
    @State var font: String?
    @Binding var fontName: String
    @Binding var lastSelectedFont: String
    var columnsCommon: CGFloat
    
    var fontDisplayName : String {
        return fontMapping[font ?? ""] ?? font!
    }
    
    var body: some View {
        VStack{
            if let font = font{
//                GeometryReader { geometry in
                    
                    HStack{
                        if font == "Default"{
                            Text("Text")
                                .font(.custom(FontDM.getRealFont(nameOfFont: "defaultfont.ttf", engineConfig: AppEngineConfigure()), size: 20))
                                .minimumScaleFactor(0.3) // Allows it to shrink down to 50% of the original size
                                .foregroundColor(fontName == "defaultfont.ttf" ? AppStyle.accentColor_SwiftUI : .label)
                                .padding()
                                .fixedSize(horizontal: true, vertical: true)
                            
                        }else{
                            Text("Text")
                                .font(.custom(FontDM.getRealFont(nameOfFont: "\(font)\(fontExtenstion(fontName: font))", engineConfig: AppEngineConfigure()), size: 20))
                                .minimumScaleFactor(0.5) // Allows it to shrink down to 50% of the original size
                            
                                .foregroundColor(fontName.components(separatedBy: ".").first == font ? AppStyle.accentColor_SwiftUI : .label)
                                .padding()
                                .fixedSize(horizontal: true, vertical: true)
                            
                        }
                        
                    }
                    .frame(width: columnsCommon, height: 30)
                    .background(Color.secondarySystemBackground)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(checkForDefaultFont(font: font) ? AppStyle.accentColor_SwiftUI : .clear, lineWidth: checkForDefaultFont(font: font) ? 2 : 0)
                    )
                    
                    Text(fontDisplayName)
                        .font(.system(size: 8))
                        .frame(width: columnsCommon-10, height: 10)
                        .fixedSize(horizontal: true, vertical: true)
                        .lineLimit(1)
                        .padding(.top,0)
                        .offset(y:-5)
                    
//                }
                
            }else{
//                ShimmerEffectBox().frame(width: columnsCommon, height: 30).cornerRadius(10.0, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            
        }
        .task {
            do{
                font = try await dsStore.fetchFonts(name: font!)
            }catch is CancellationError{
                print("Task was canceled \(font!)")
            }catch{
                
            }
        }
    }
    
    
    func checkForDefaultFont(font: String) -> Bool{
        if fontName == "defaultfont.ttf" && font == "Default"{
            return true
        }else if fontName.components(separatedBy: ".").first == font{
            return true
        }else{
            return false
        }
    }
}
