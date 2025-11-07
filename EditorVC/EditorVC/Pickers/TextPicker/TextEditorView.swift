//
//  TextEditorView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 18/03/24.
//
//
import SwiftUI

struct TextEditorView: View {
    @Binding var isTextPickerPresented: Bool
    @Binding var currentText: String
    @Binding var updatedText : String
    @State private var placeholder: String = "Enter_your_text_here".translate()
    @State private var showAlert = false
    @Binding var updateThumb : Bool
    @State var textUpdation : String = ""
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button("Cancel_") {
                        isTextPickerPresented = false
                        
                    }
                    Spacer()
                    Text("Text_Editor")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button("Done_") {
                        if !textUpdation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            updatedText = textUpdation
                            updateThumb = true
                            isTextPickerPresented = false
                        } else {
                            updatedText = textUpdation
                            showAlert = true
                        }
                    }
                    .foregroundColor(AppStyle.accentColor_SwiftUI)
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $textUpdation)
                    .padding(5)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0 ,maxHeight: .infinity)
                    .multilineTextAlignment(.center)
////                    .focused($isTextEditorFocused)
////                    .onChange(of: isTextEditorFocused) { isFocused in
//                        // If the TextEditor is focused, hide the placeholder
////                        isPlaceholderHidden = isFocused || !currentText.isEmpty
//                        printLog("TEXTEDITOR - IsFocus \(isFocused)")
////                        if currentText == "Enter Your Text Here." {
////                            currentText = ""
////                        }
////                    }
//                    .onTapGesture {
//                        //                        oldText = currentText
//                        //                        isPlaceholderHidden = true
////                        if currentText.isEmpty && !isPlaceholderHidden {
////                            isPlaceholderHidden = true
////                        }
//                        printLog("TEXTEDITOR - onTap")
//                        // Set currentText to empty to clear it on tap
//                        if currentText == "Enter Your Text Here." {
//                            currentText = ""
//                        }
//                    }
                
                if textUpdation.isEmpty  {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(10)
                        
                }
            }
            .padding(.horizontal, 10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: UIColor.secondarySystemBackground), lineWidth: 1))
            
            Spacer()
        }
        .onAppear {
            if currentText == "Enter Your Text Here." {
                textUpdation = ""
            }else{
                textUpdation = currentText
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Sorry_no_text_entered"),
                message: Text("Please_enter_some_text_to_continue"),
                dismissButton: .default(Text("OK_"))
            )
        }
        .environment(\.sizeCategory, .medium)
        
    }
}
