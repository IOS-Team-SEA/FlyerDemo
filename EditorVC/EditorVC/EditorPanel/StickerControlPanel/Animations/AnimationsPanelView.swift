//
//  AnimationsPanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 22/03/24.
//

import SwiftUI
import IOS_CommonEditor
//import SwiftUIIntrospect

struct AnimationsPanelView: View {
    
    @State var animationTemplate: [DBAnimationTemplateModel] = []
    @State var animationCategories: [DBAnimationCategoriesModel] = []
    @State private var selectedAnimeType: String = "IN"
    @State private var selectedCategory: DBAnimationCategoriesModel?
    @Binding var durationIN: Float
    @Binding var durationOUT: Float
    @Binding var durationLOOP: Float
    
    
    @Binding var beginDurationIN: Float
    @Binding var endDurationIN: Float
    
    @Binding var beginDurationOUT: Float
    @Binding var endDurationOUT: Float
    
    @Binding var beginDurationLOOP: Float
    @Binding var endDurationLOOP: Float
    
    
    @Binding var inAnimTemplate : AnimTemplateInfo
    @Binding var outAnimTemplate : AnimTemplateInfo
    @Binding var loopAnimTemplate : AnimTemplateInfo

    @Binding var lastSelectedAnimType: String
    @Binding var lastSelectedCategoryId: Int

    
    @State private var dataLoaded: Bool = false
   
    
    let animationTypes: [(AnimeType, String)] = [
            (.In, "IN"),
            (.Out, "OUT"),
            (.Loop, "LOOP")
    ]
    
    
    
    var filteredCategories: [DBAnimationCategoriesModel] {
//        let selectedTypeCategories = animationTemplate
//            .filter { $0.type == selectedAnimeType }
//            .map { $0.category }
//        return animationCategories.filter { selectedTypeCategories.contains($0.animationCategoriesId) }
        if lastSelectedAnimType == "IN" || lastSelectedAnimType == "OUT"{
            return animationCategories.filter { $0.animationCategoriesId != 2}
        }else{
            return animationCategories.filter { $0.animationCategoriesId == 2}
        }
       
    }
    
//    var selectedCategoryNameIN: String {
//        filteredCategories.first(where: { $0.animationCategoriesId == inAnimTemplate.animationCategoriesId })?.animationName ?? "Back"
//    }
//    var selectedCategoryNameOUT: String {
//        filteredCategories.first(where: { $0.animationCategoriesId == outAnimTemplate.animationCategoriesId })?.animationName ?? "Back"
//    }
    
    var body: some View {
        let categoryIdForIn = bindingForCategoryId(animInfo: $inAnimTemplate)
        let categoryIdForOut = bindingForCategoryId(animInfo: $outAnimTemplate)
        let categoryIdForLoop = bindingForCategoryId(animInfo: $loopAnimTemplate)
        
        VStack(spacing: 0){
            if dataLoaded {
                HStack(spacing: 10){
                    
                    Picker(selection: $lastSelectedAnimType, label: Text("")) {
                        Text("IN_").tag("IN")
                        Text("OUT_").tag("OUT")
                        Text("LOOP_").tag("LOOP")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 160)
                    .onChange(of: lastSelectedAnimType) { newValue in
                        if newValue == "IN"{
                            lastSelectedCategoryId = categoryIdForIn.wrappedValue
                        }else if newValue == "OUT"{
                            lastSelectedCategoryId = categoryIdForOut.wrappedValue
                        }else{
                            lastSelectedCategoryId = categoryIdForLoop.wrappedValue
                        }
                    }

                    Spacer()
                    if lastSelectedAnimType == "IN"{
                        Picker(selection: $lastSelectedCategoryId, label: Text("")) {
                            ForEach(filteredCategories, id: \.animationCategoriesId) { category in
                                Text(category.animationName)
                                    .tag(category.animationCategoriesId)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(AppStyle.accentColor_SwiftUI)
                        .padding(.trailing, 10)
                    }else if lastSelectedAnimType == "OUT"{
                        Picker(selection: $lastSelectedCategoryId, label: Text("")) {
                            ForEach(filteredCategories, id: \.animationCategoriesId) { category in
                                Text(category.animationName)
                                    .tag(category.animationCategoriesId) // Bind tag to ID
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(AppStyle.accentColor_SwiftUI)
                        .padding(.trailing, 10)
                    }else if lastSelectedAnimType == "LOOP"{
                        Picker(selection: $lastSelectedCategoryId, label: Text("")) {
                            ForEach(filteredCategories, id: \.animationCategoriesId) { category in
                                Text(category.animationName)
                                    .tag(category.animationCategoriesId) // Bind tag to ID
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(AppStyle.accentColor_SwiftUI)
                        .padding(.trailing, 10)
                    }
                    
                    
//                    if selectedAnimeType == "IN"{
//                        Picker(selection: $inAnimTemplate.animationCategoriesId, label: Text("")) {
//                            ForEach(filteredCategories, id: \.animationCategoriesId) { category in
//                                Text(category.animationName)
//                                    .tag(category.animationCategoriesId)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                        .accentColor(AppStyle.accentColor_SwiftUI)
//                        .padding(.trailing, 10)
//                    }else if selectedAnimeType == "OUT"{
//                        Picker(selection: $outAnimTemplate.animationCategoriesId, label: Text("")) {
//                            ForEach(filteredCategories, id: \.animationCategoriesId) { category in
//                                Text(category.animationName)
//                                    .tag(category.animationCategoriesId) // Bind tag to ID
//                            }
//                        }
//                        .pickerStyle(.menu)
//                        .accentColor(AppStyle.accentColor_SwiftUI)
//                        .padding(.trailing, 10)
//                    }else if selectedAnimeType == "Loop"{
//                        Picker("Category", selection: $selectedCategoryIndexLOOP) {
//                            
//                            ForEach(0..<filteredCategories.count, id: \.self) { index in
//                                Text(filteredCategories[index].animationName)
//                                    .tag(index)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                        .accentColor(AppStyle.accentColor_SwiftUI)
//                        .padding(.trailing, 10)
//                    }
                    
                }
                .frame(height: 50)
                .padding(.leading, 20)

                VStack(spacing: 0){
                    
                    if lastSelectedAnimType == "LOOP"{
//                        let selectedCategory = animationCategories[selectedCategoryIndexLOOP]
                        
                        AnimationNameByType(animTemplate: $loopAnimTemplate, duration: $durationLOOP, beginDuration: $beginDurationLOOP, endDuration: $endDurationLOOP, lastSelectedCategoryId: $lastSelectedCategoryId, lastSelectedAnimType: $lastSelectedAnimType, animationTemplate: $animationTemplate).environmentObject(UIStateManager.shared)
                        
//                        AnimationNameByType(animTemplate: $loopAnimTemplate, duration: $durationLOOP, beginDuration: $beginDurationLOOP, endDuration: $endDurationLOOP, animationTemplate: $animationTemplate, category: selectedCategory, selectedAnimeType: $selectedAnimeType).environmentObject(UIStateManager.shared)
                    }else if lastSelectedAnimType == "IN"{
//                        let selectedCategory = animationCategories.first(where: { $0.animationCategoriesId == lastSelectedCategoryId })!
                        
                        AnimationNameByType(animTemplate: $inAnimTemplate, duration: $durationIN, beginDuration: $beginDurationIN, endDuration: $endDurationIN, lastSelectedCategoryId: $lastSelectedCategoryId, lastSelectedAnimType: $lastSelectedAnimType, animationTemplate: $animationTemplate).environmentObject(UIStateManager.shared)
                        
//                        AnimationNameByType(animTemplate: $inAnimTemplate, duration: $durationIN, beginDuration: $beginDurationIN, endDuration: $endDurationIN, animationTemplate: $animationTemplate, category: selectedCategory, selectedAnimeType: $selectedAnimeType ).environmentObject(UIStateManager.shared)

                    }else if lastSelectedAnimType == "OUT"{
//                        let selectedCategory = animationCategories.first(where: { $0.animationCategoriesId == lastSelectedCategoryId })!
                        
                        AnimationNameByType(animTemplate: $outAnimTemplate, duration: $durationOUT, beginDuration: $beginDurationOUT, endDuration: $endDurationOUT, lastSelectedCategoryId: $lastSelectedCategoryId, lastSelectedAnimType: $lastSelectedAnimType, animationTemplate: $animationTemplate).environmentObject(UIStateManager.shared)
                        
//                        AnimationNameByType(animTemplate: $outAnimTemplate, duration: $durationOUT, beginDuration: $beginDurationOUT, endDuration: $endDurationOUT, animationTemplate: $animationTemplate, category: selectedCategory, selectedAnimeType: $selectedAnimeType ).environmentObject(UIStateManager.shared)
                    }
                    
                }
                .frame(height: 120)
            }
            
        }
        .frame(height: 180)
        .onAppear(){
   
            animationTemplate = DataSourceRepository.shared.getAllAnimationTemplates()
            animationCategories = DataSourceRepository.shared.getAllAnimationCategories()
            
            if lastSelectedAnimType == "IN"{
                if inAnimTemplate.animationTemplateId == 1{
                    lastSelectedCategoryId = 3
                }else{
                    lastSelectedCategoryId = inAnimTemplate.animationCategoriesId
                }
            }else if lastSelectedAnimType == "OUT"{
                if outAnimTemplate.animationTemplateId == 1{
                    lastSelectedCategoryId = 3
                }else{
                    lastSelectedCategoryId = outAnimTemplate.animationCategoriesId
                }
            }else{
                if loopAnimTemplate.animationTemplateId == 1{
                    lastSelectedCategoryId = 2
                }else{
                    lastSelectedCategoryId = loopAnimTemplate.animationCategoriesId
                }
            }
            dataLoaded = true
        }
    }
    
    func bindingForCategoryId(animInfo: Binding<AnimTemplateInfo>) -> Binding<Int>{
        return Binding<Int>(
            get: {
                if animInfo.animationTemplateId.wrappedValue == 1{
                    if lastSelectedAnimType == "IN" || lastSelectedAnimType == "OUT"{
                        return 3
                    }else{
                        return 2
                    }
                }else {
                    return animInfo.animationCategoriesId.wrappedValue
                }
            },
            set: { newValue in
                lastSelectedCategoryId = newValue
            }
        )
    }
    
}

//struct AnimationNameByType: View {
//   // @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
//    @Binding var inAnimTemplate : AnimTemplateInfo
//    @Binding var outAnimTemplate : AnimTemplateInfo
//    @Binding var loopAnimTemplate : AnimTemplateInfo
//    @Binding var duration: Float
//    @State var selectedAnimation: AnimTemplateInfo?
//    @Binding var beginDuration: Float
//    @Binding var endDuration: Float
//    @State var isPremiumUser: Bool = false
//    @EnvironmentObject var uiStateManager : UIStateManager
//    
//    @Binding var animationTemplate: [DBAnimationTemplateModel]
////    @Binding var selectedType: String
//    var category: DBAnimationCategoriesModel
//    @Binding var selectedAnimeType: String
//    
//    var uniqueAnimationByType: [DBAnimationTemplateModel]{
//        if selectedAnimeType == "LOOP"{
//            animationTemplate.filter{ $0.category == category.animationCategoriesId }/*.filter{ $0.type == selectedAnimeType }*/
//        }else{
//            animationTemplate.filter{ $0.category == category.animationCategoriesId }.filter{ $0.type == selectedAnimeType }
//        }
//    }
//    
//    var customNamedAnimations: [DBAnimationTemplateModel] {
//        uniqueAnimationByType.map { template in
//            var updatedTemplate = template
//            // Apply custom name if available
//            if let customName = animationNameMapping[template.name] {
//                updatedTemplate.name = customName
//            }
//            return updatedTemplate
//        }
//    }
//    
//    var body: some View {
//        VStack(spacing: 0){
//                HStack(spacing: 10) {
//                    
//                    VStack(spacing: 0){
//                        Spacer()
//                        VStack{
//                            SwiftUI.Image("none")
//                                .resizable()
//                            //                        .renderingMode(selectedAnimation == "None" ? . template : .original)
//                            //                        .foregroundColor(AppStyle.accentColor_SwiftUI)
//                                .frame(width: 50, height: 50)
//                            //                        .padding(.leading, 20)
//                                .onTapGesture {
//                                    
////                                    lastSelectedAnimation = selectedAnimation
//                                    
//                                    let animationInfo = DataSourceRepository.shared.fetchAnimationInfo(for: 1)
//                                    
//                                    if selectedAnimeType == "IN" {
//                                        inAnimTemplate = animationInfo
//                                    }else if selectedAnimeType == "OUT" {
//                                        outAnimTemplate = animationInfo
//                                    }else if selectedAnimeType == "LOOP" {
//                                        loopAnimTemplate = animationInfo
//                                    }
//                                    
//                                    print("none tapped")
//                                }
//                        }
//                        .frame(width: 60, height: 60)
//                        .background(/*selectedAnimation == "NONE"*/highLightNoneCell() ? AppStyle.accentColor_SwiftUI : .gray)
//                        .cornerRadius(5)
//                        
//                        VStack{
//                            
//                        }
//                        .frame(height: 20)
//                        
//                    }.frame(height: 80)
//                                        
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        ScrollViewReader{ proxy in
//                            HStack{
//                                ForEach(customNamedAnimations, id: \.animationTemplateId) { template in
//                                    VStack(spacing: 0){
//                                        Spacer()
//                                        Button {
//                                            print("animation name: \(template.name) \(template.type)")
////                                            selectedAnimation = template.name
////                                            lastSelectedAnimation = selectedAnimation
//                                            
//                                            let animationInfo = DataSourceRepository.shared.fetchAnimationInfo(for: template.animationTemplateId)
//                                            
//                                            if AnimeType(rawValue: template.type) == .In {
//                                                inAnimTemplate = animationInfo
//                                            }else if AnimeType(rawValue: template.type) == .Out {
//                                                outAnimTemplate = animationInfo
//                                                
//                                            }else if AnimeType(rawValue: template.type) == .Loop {
//                                                loopAnimTemplate = animationInfo
//                                                
//                                            }
//                                        } label: {
//                                            VStack(spacing: 0){
//                                                if template.icon.hasSuffix(".png") {
//                                                    if let imageName = removePngExtension(from: template.icon) {
//                                                        SwiftUI.Image(imageName)
//                                                            .resizable()
//                                                            .frame(width: 60, height: 60)
//                                                    }
//                                                }else{
//                                                    if let imageName = removePngExtension(from: template.icon) {
//                                                        GIFImage(gifName: imageName)
//                                                            .frame(width: 60, height: 60)
//                                                    }
//                                                }
//                                            }
//                                            .id(template.name)
//                                            .frame(width: 60, height: 60)
//                                        }
//                                        .frame(width: 60, height: 60)
//                                        .background(/*lastSelectedAnimation == template.name*/highlightCell(id: template.animationTemplateId) ? AppStyle.accentColor_SwiftUI : .gray)
//                                        .cornerRadius(5)
//                                        //                                    .overlay(
//                                        //                                        RoundedRectangle(cornerRadius: 5)
//                                        //                                            .stroke(lastSelectedAnimation == template.name ? AppStyle.accentColor_SwiftUI : .gray, lineWidth: 2)
//                                        //                                            .frame(width: 40, height: 40)
//                                        //                                    )
//                                        
//                                        VStack(alignment: .center){
//                                            //                                            Spacer()
//                                            MarqueeTextAnimation(
//                                                text: template.name,
//                                                font: .system(size: 11),
//                                                width: 60,
//                                                templateName: template.name,
//                                                id: template.animationTemplateId,
//                                                inAnimTemplate: $inAnimTemplate,
//                                                outAnimTemplate: $outAnimTemplate,
//                                                loopAnimTemplate: $loopAnimTemplate
//                                                
//                                                
//                                            )
//                                        }
//                                        .frame(width: 60, height: 20)
//                                    }
//                                    .frame(height: 80)
//                                    
//                                }
//                            }
////                            .frame(height: 100)
//                            //                        .padding(.horizontal, 5)
//                            .onAppear(){
//                                if selectedAnimeType == "IN"{
//                                    
//                                    selectedAnimation = inAnimTemplate
//                                }else if selectedAnimeType == "OUT"{
//                                    
//                                    selectedAnimation = outAnimTemplate
//                                }else if selectedAnimeType == "LOOP"{
//                                    
//                                    selectedAnimation = loopAnimTemplate
//                                }
//                                
//                                scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: selectedAnimation?.animationTemplateId ?? 1)
//                            }
//                            .onChange(of: inAnimTemplate) { newValue in
//                                if inAnimTemplate.type == "ANY"{
//                                    selectedAnimeType = "IN"
//                                }else{
//                                    selectedAnimeType = inAnimTemplate.type
//                                }
//                                scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: inAnimTemplate.animationTemplateId)
//                            }
//                            .onChange(of: outAnimTemplate) { newValue in
//                                if outAnimTemplate.type == "ANY"{
//                                    selectedAnimeType = "OUT"
//                                }else{
//                                    selectedAnimeType = outAnimTemplate.type
//                                }
//                                scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: outAnimTemplate.animationTemplateId)
//                            }
//                            .onChange(of: loopAnimTemplate) { newValue in
//                                if loopAnimTemplate.type == "ANY"{
//                                    selectedAnimeType = "LOOP"
//                                }else{
//                                    selectedAnimeType = loopAnimTemplate.type
//                                }
//                                scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: loopAnimTemplate.animationTemplateId)
//                            }
//                            
//                        }
//                    }
//                    .frame(height: 80)
//                }.frame(height: 80)
//            
//            VStack{
//                HStack{
//                    HStack{
//                        Text("Duration_")
//                            .font(.system(size: 12))
//                        if !uiStateManager.isPremium {
//                            SwiftUI.Image("premiumIcon")
//                                .resizable()
//                                .frame(width: 20, height: 20)
//                        }
////                            .padding(.top, -20)
//                    }
//                        
//                    // Slider
//                    ZStack {
//                        Slider(
//                            value: $duration,
//                            in: 1...10,
//                            onEditingChanged: { isEditing in
//                                if uiStateManager.isPremium {
//                                    if isEditing {
//                                        beginDuration = duration
//                                    } else {
//                                        endDuration = duration
//                                    }
//                                } else {
//                                    isPremiumUser = true  // Ensure this runs when user is NOT subscribed
//                                    duration = 1.0
//                                }
//                            }
//                        )
//                        .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                            slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                        }
//                        .tint(AppStyle.accentColor_SwiftUI)
//                        
////                        // Tappable overlay for non-subscribed users
////                        if PersistentStorage.shared.isUserSubscribed {
////                            Rectangle()
////                                .fill(Color.white.opacity(0.01)) // Ensures tap is detected
////                                .frame(maxWidth: .infinity, maxHeight: .infinity)
////                                .onTapGesture {
////                                    //isPremiumUser = true
////                                    print("Premium page should open!") // Debugging
////                                }
////                        }
//                    }
//                    Text("\(String(format: "%.1f", duration)) secs")
//                        .font(.system(size: 12))
//                    //                        .padding()
//                }.frame(width: 350, height: 30)
//            }.frame(height: 40)
//        }
//        .frame(height: 120)
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 20)
//        .sheet(isPresented: $isPremiumUser) {
//            // ** Neeshu
////            let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .normal )
////            IAPView(iapViewModel: iapViewModel).environmentObject(UIStateManager.shared)
////            PremiumPage(checkForRestore: false)
//            IAPView().environmentObject(UIStateManager.shared).interactiveDismissDisabled()
//
//        }
//        
//    }
//    
//    func removePngExtension(from filename: String) -> String? {
//        return String(filename.dropLast(4))
//    }
//    
//    
//    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: Int) {
//        // Find the ID of the last selected button and scroll to
//        // Add more conditions for other tab states...
//        
//        // Scroll to the identified button
//        withAnimation(.spring()) {
//            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
//        }
//            
//    }
//    
//    func highlightCell(id: Int) -> Bool{
//        if inAnimTemplate.animationTemplateId == id {
//            return true
//        }else if outAnimTemplate.animationTemplateId == id{
//            return true
//        }else if loopAnimTemplate.animationTemplateId == id{
//            return true
//        }else{
//            return false
//        }
//    }
//    
//    func highLightNoneCell() -> Bool{
//        if inAnimTemplate.animationTemplateId == 1 && selectedAnimeType == "IN"{
//            return true
//        }else if outAnimTemplate.animationTemplateId == 1 && selectedAnimeType == "OUT"{
//            return true
//        }else if loopAnimTemplate.animationTemplateId == 1 && selectedAnimeType == "LOOP"{
//            return true
//        }else{
//            return false
//        }
//    }
//}

struct AnimationNameByType: View {
   // @EnvironmentObject var subscriptionEnvironmentObj : SubscriptionEnvironmentObj
    @Binding var animTemplate : AnimTemplateInfo
    @Binding var duration: Float
    @Binding var beginDuration: Float
    @Binding var endDuration: Float
    @State var isPremiumUser: Bool = false
    @Binding var lastSelectedCategoryId: Int
    @Binding var lastSelectedAnimType: String
    @Binding var animationTemplate: [DBAnimationTemplateModel]
    @EnvironmentObject var uiStateManager : UIStateManager
    
    
    var uniqueAnimationByType: [DBAnimationTemplateModel]{
//        if lastSelectedAnimType == "LOOP"{
//            animationTemplate.filter{ $0.category == lastSelectedCategoryId }.filter{ $0.type == lastSelectedAnimType }
//        }else{
        animationTemplate.filter{ $0.category == lastSelectedCategoryId }.filter{ $0.type == lastSelectedAnimType }
//        }
    }
    
//    var uniqueAnimationByType: [DBAnimationTemplateModel]{
//        if selectedAnimeType == "LOOP"{
//            animationTemplate.filter{ $0.category == last }/*.filter{ $0.type == selectedAnimeType }*/
//        }else{
//            animationTemplate.filter{ $0.category == category.animationCategoriesId }.filter{ $0.type == selectedAnimeType }
//        }
//    }
    
    var customNamedAnimations: [DBAnimationTemplateModel] {
        uniqueAnimationByType.map { template in
            var updatedTemplate = template
            // Apply custom name if available
            if let customName = animationNameMapping[template.name] {
                updatedTemplate.name = customName
            }
            return updatedTemplate
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
                HStack(spacing: 10) {
                    
                    VStack(spacing: 0){
                        Spacer()
                        VStack{
                            SwiftUI.Image("none")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                                 
                                    if animTemplate.animationTemplateId != 1{
                                        var animationInfo = DataSourceRepository.shared.fetchAnimationInfo(for: 1)
                                        animTemplate = animationInfo
                                    }
                                    
                                    print("none tapped")
                                }
                        }
                        .frame(width: 60, height: 60)
                        .background(/*selectedAnimation == "NONE"*/highLightNoneCell() ? AppStyle.accentColor_SwiftUI : .gray)
                        .cornerRadius(5)
                        
                        VStack{
                            
                        }
                        .frame(height: 20)
                        
                    }.frame(height: 80)
                                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader{ proxy in
                            HStack{
                                ForEach(customNamedAnimations, id: \.animationTemplateId) { template in
                                    VStack(spacing: 0){
                                        Spacer()
                                        Button {
                                            print("animation name: \(template.name) \(template.type)")
//                                            selectedAnimation = template.name
//                                            lastSelectedAnimation = selectedAnimation
                                            
                                            let animationInfo = DataSourceRepository.shared.fetchAnimationInfo(for: template.animationTemplateId)
                                            
                                            animTemplate = animationInfo
                                            
                                        } label: {
                                            VStack(spacing: 0){
                                                if template.icon.hasSuffix(".png") {
                                                    if let imageName = removePngExtension(from: template.icon) {
                                                        SwiftUI.Image(imageName)
                                                            .resizable()
                                                            .frame(width: 60, height: 60)
                                                    }
                                                }else{
                                                    if let imageName = removePngExtension(from: template.icon) {
                                                        GIFImage(gifName: imageName)
                                                            .frame(width: 60, height: 60)
                                                    }
                                                }
                                            }
                                            .id(template.name)
                                            .frame(width: 60, height: 60)
                                        }
                                        .frame(width: 60, height: 60)
                                        .background(/*lastSelectedAnimation == template.name*/highlightCell(id: template.animationTemplateId) ? AppStyle.accentColor_SwiftUI : .gray)
                                        .cornerRadius(5)
                                        
                                        VStack(alignment: .center){
                                            MarqueeTextAnimation(
                                                text: template.name,
                                                font: .system(size: 11),
                                                width: 60,
                                                templateName: template.name,
                                                id: template.animationTemplateId,
                                                animTemplate: $animTemplate
                                            )
                                        }
                                        .frame(width: 60, height: 20)
                                    }
                                    .frame(height: 80)
                                    
                                }
                            }
                            .onAppear(){
                                scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: animTemplate.animationTemplateId)
                            }
                            .onChange(of: animTemplate) { newValue in
                                if newValue.animationTemplateId != 1{
                                    lastSelectedCategoryId = newValue.animationCategoriesId
                                }
                                scrollToSelectedButton(scrollViewProxy: proxy, scrollToID: animTemplate.animationTemplateId)
                            }
                        }
                    }
                    .frame(height: 80)
                }.frame(height: 80)
            
            VStack{
                HStack{
                    HStack{
                        Text("Duration_")
                            .font(.system(size: 12))
                        if !uiStateManager.isPremium {
                            SwiftUI.Image("premiumIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
//                            .padding(.top, -20)
                    }
                        
                    // Slider
                    ZStack {
                        Slider(
                            value: $duration,
                            in: 1...10,
                            onEditingChanged: { isEditing in
                                if uiStateManager.isPremium {
                                    if isEditing {
                                        beginDuration = duration
                                    } else {
                                        endDuration = duration
                                    }
                                } else {
                                    isPremiumUser = true  // Ensure this runs when user is NOT subscribed
                                    duration = 1.0
                                }
                            }
                        )
//                        .introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { slider in
//                            slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//                        }
                        .tint(AppStyle.accentColor_SwiftUI)
                        
                    }
                    Text("\(String(format: "%.1f", duration)) secs")
                        .font(.system(size: 12))
                    //                        .padding()
                }.frame(width: 350, height: 30)
            }.frame(height: 40)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .sheet(isPresented: $isPremiumUser) {
            // ** Neeshu
//            let iapViewModel = IAPViewModel(isSingleTemplateSelectedOrNot: false, defaultProductType: .year, premiumPageLoadingState: .normal )
//            IAPView(iapViewModel: iapViewModel).environmentObject(UIStateManager.shared)
//            PremiumPage(checkForRestore: false)
//            IAPView().environmentObject(UIStateManager.shared).interactiveDismissDisabled()

        }
        
    }
    
    func bindingForAnimInfo(animInfo: Binding<AnimTemplateInfo>) -> Binding<AnimTemplateInfo>{
        return Binding<AnimTemplateInfo>(
            get: {
                return animInfo.wrappedValue
            },
            set: { newValue in
                lastSelectedCategoryId = newValue.category
                animTemplate = newValue
            }
        )
    }
    
    func removePngExtension(from filename: String) -> String? {
        return String(filename.dropLast(4))
    }
    
    
    func scrollToSelectedButton(scrollViewProxy: ScrollViewProxy, scrollToID: Int) {
        // Find the ID of the last selected button and scroll to
        // Add more conditions for other tab states...
        
        // Scroll to the identified button
        withAnimation(.spring()) {
            scrollViewProxy.scrollTo(scrollToID, anchor: .center)
        }
            
    }
    
    func highlightCell(id: Int) -> Bool{
        if animTemplate.animationTemplateId == id {
            return true
        }else{
            return false
        }
    }
    
    func highLightNoneCell() -> Bool{
        if animTemplate.animationTemplateId == 1{
            return true
        }else{
            return false
        }
    }
}

struct BorderButtonStyle: ButtonStyle {
    let borderColor: Color
    let borderWidth: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(width: 60, height: 25)
            )
            
    }
}


//struct AnimationTypeButton: View {
//    
//    var nameLocalized: String
//    var name: String
//    @Binding var selectedAnimeType: String
//    @Binding var lastSelectedAnimType: String
//    
//    var body: some View {
//        VStack{
////            Text(name)
////                .font(.caption)
////                .foregroundColor(selectedAnimeType == name ? AppStyle.accentColor_SwiftUI : Color.gray)
////                .overlay(
////                    RoundedRectangle(cornerRadius: 5) // Create a rounded rectangle overlay
////                        .stroke(selectedAnimeType == name ? AppStyle.accentColor_SwiftUI : Color.gray, lineWidth: 1) // Add border with specified color and width
////                        .frame(width: 50, height: 25)
////                )
////                .onTapGesture {
////                    selectedAnimeType = name
////                }
////            
//            Button {
//                selectedAnimeType = name
//                lastSelectedAnimType = selectedAnimeType
//            } label: {
//                Text(nameLocalized)
//                    .font(.caption2)
////                    .fontWeight(.bold)
//                    .foregroundColor(lastSelectedAnimType == name ? AppStyle.accentColor_SwiftUI : .gray)
//                    .frame(width: 50, height: 25)
//            }
//            .frame(width: 50, height: 25)
//            .overlay(
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(lastSelectedAnimType == name ? AppStyle.accentColor_SwiftUI : .gray, lineWidth: 2)
//            )
////            .border(.purple, width: 2)
//            
//
//                
//        }
//        .frame(width: 50, height: 25)
//        
//        
//        
//    }
//}

struct GIFImage: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
        ])
        
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let imageView = uiView.subviews.first as? UIImageView else { return }
        
        if let gifImage = UIImage.gifImageWithName(gifName) {
            imageView.image = gifImage
        } else {
            // Fallback to a default image if GIF not found
            imageView.image = UIImage(named: "b0")
        }
    }
}


struct MarqueeTextAnimation: View {
    var text: String
    var font: Font
    var width: CGFloat
    var templateName: String
    var id: Int
    @Binding var animTemplate : AnimTemplateInfo
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            let textSize = textSize(text: text, font: font, width: width)
            let animationOffset = textSize.width > geometry.size.width ? textSize.width - geometry.size.width : 0

            Text(text)
                .font(font)
                .fontWeight(.semibold)
                .foregroundColor(/*lastSelectedAnimation == templateName*/highlightCell(id: id) ? AppStyle.accentColor_SwiftUI : .label)
                .fixedSize(horizontal: true, vertical: false)
                .offset(x: animate ? -animationOffset : 0)
                .animation(
                    Animation.linear(duration: 3)
                        .repeatForever(autoreverses: false),
                    value: animate
                )
                .onAppear {
                    if animationOffset > 0 {
                        animate = textSize.width > width
                    }
                }
        }
        .frame(width: width)
        .clipped()
    }

    private func textSize(text: String, font: Font, width: CGFloat) -> CGSize {
        let label = UILabel()
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.sizeToFit()
        return label.frame.size
    }
    
    private func highlightCell(id: Int) -> Bool{
        if animTemplate.animationTemplateId == id{
            return true
        }else{
            return false
        }
    }
}


let animationNameMapping: [String: String] = [
    "none": "None",
    "bounce": "Bounce",
    "flash": "Flash",
    "pulse": "Pulse",
    "rubberBand": "Rubber Band",
    "shakeX": "ShakeX",
    "shakeY": "ShakeY",
    "headShake": "Head Shake",
    "swing": "Swing",
    "tada": "Tada",
    "wobble": "Wobble",
    "jello": "Jello",
    "heartBeat": "HeartBeat",
    "backInDown": "Down",
    "backInLeft": "Left",
    "backInRight": "Right",
    "backInUp": "Up",
    "backOutDown": "Down",
    "backOutLeft": "Left",
    "backOutRight": "Right",
    "backOutUp": "Up",
    "bounceIn": "Bounce",
    "bounceInDown": "Down",
    "bounceInLeft": "Left",
    "bounceInRight": "Right",
    "bounceInUp": "Up",
    "bounceOut": "Bounce",
    "bounceOutDown": "Down",
    "bounceOutLeft": "Left",
    "bounceOutRight": "Right",
    "bounceOutUp": "Up",
    "fadeIn": "Fade",
    "fadeInDown": "Down",
    "fadeInDownBig": "Down Big",
    "fadeInLeft": "Left",
    "fadeInLeftBig": "Left Big",
    "fadeInRight": "Right",
    "fadeInRightBig": "Right Big",
    "fadeInUp": "Up",
    "fadeInUpBig": "Up Big",
    "fadeInTopLeft": "Top Left",
    "fadeInTopRight": "Top Right",
    "fadeInBottomLeft": "Bottom Left",
    "fadeInBottomRight": "Bottom Right",
    "fadeOut": "Fade",
    "fadeOutDown": "Down",
    "fadeOutDownBig": "Down Big",
    "fadeOutLeft": "Left",
    "fadeOutLeftBig": "Left Big",
    "fadeOutRight": "Right",
    "fadeOutRightBig": "Right Big",
    "fadeOutUp": "Up",
    "fadeOutUpBig": "Up Big",
    "fadeOutTopLeft": "Top Left",
    "fadeOutTopRight": "Top Right",
    "fadeOutBottomLeft": "Bottom Left",
    "fadeOutBottomRight": "Bottom Right",
    "lightspeedInRight": "Right",
    "lightspeedInLeft": "Left",
    "lightspeedOutRight": "Right",
    "lightspeedOutLeft": "Left",
    "rotateIn": "Rotate",
    "rotateInDownLeft": "Down Left",
    "rotateInDownRight": "Down Right",
    "rotateInUpLeft": "Up Left",
    "rotateInUpRight": "Up Right",
    "rotateOut": "Rotate",
    "rotateOutDownLeft": "Down Left",
    "rotateOutDownRight": "Down Right",
    "rotateOutUpLeft": "Up Left",
    "rotateOutUpRight": "Up Right",
    "hinge": "Hinge",
    "jackInTheBox": "Jack In The Box",
    "rollIn": "Roll In",
    "rollOut": "Roll Out",
    "zoomIn": "Zoom In",
    "zoomInDown": "Down",
    "zoomInLeft": "Left",
    "zoomInRight": "Right",
    "zoomInUp": "Up",
    "zoomOut": "Zoom Out",
    "zoomOutDown": "Down",
    "zoomOutLeft": "Left",
    "zoomOutRight": "Right",
    "zoomOutUp": "Up",
    "slideInDown": "Down",
    "slideInLeft": "Left",
    "slideInRight": "Right",
    "slideInUp": "Up",
    "slideOutDown": "Down",
    "slideOutLeft": "Left",
    "slideOutRight": "Right",
    "slideOutUp": "Up",
    "flip": "Flip",
    "flipinx": "Flip In X",
    "flipiny": "Flip In Y",
    "flipoutx": "Flip Out X",
    "flipouty": "Flip Out Y",
    "rotate": "Rotate"
]
