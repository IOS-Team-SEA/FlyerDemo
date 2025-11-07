//
//  NudgePanelView.swift
//  VideoInvitation
//
//  Created by SEA PRO2 on 03/04/24.
//

import SwiftUI
import IOS_CommonEditor

//struct NudgePanelView: View {
//    @State var nudgeAmount: CGFloat = 1.0
////    @Binding var posX: CGFloat
////    @Binding var posY: CGFloat
//    @State private var isNudging = false
//    @Binding var lockStatus:Bool
//    
////    @Binding var beginPosX: CGFloat
////    @Binding var endPosX: CGFloat
////    @Binding var beginPosY: CGFloat
////    @Binding var endPosY: CGFloat
//    @Binding var baseFrame: Frame
//    @Binding var beginFrame: Frame
//    @Binding var endFrame: Frame
//    
//    var body: some View {
//        VStack{
//            HStack(spacing: 40) {
//                
//                // Button to nudge the image left
//                Button(action: {
//                    // if lock is  on doesn't perform nudge
////                    if lockStatus{
//                        //                    self.posX -= nudgeAmount
//                        self.baseFrame.center.x -= nudgeAmount
//                        
////                    }
////                    endPosX = posX
//                }) {
//                    SwiftUI.Image(systemName: "arrow.left")
//                        .padding()
//                        .foregroundColor(.label)
//                        .frame(width: 60, height: 40)
//                        .background(Color.secondarySystemBackground)
//                        .cornerRadius(5)
//                }
//                .onLongPressGesture(perform: {
//                    //                self.startNudging(direction: .up)
//                }, onPressingChanged: { value in
//                    // if lock is  on doesn't perform nudge
////                    if lockStatus{
//                        if value{
//                            isNudging = true
//                            //                        beginPosX = posX
//                            beginFrame = baseFrame
//                            self.startNudging(direction: .left)
//                            print("on change")
//                        }else{
//                            isNudging = false
//                            nudgeAmount = 1
//                            //                        endPosX = posX
//                            endFrame = baseFrame
//                            print("on end")
//                        }
////                    }
//                })
//                
//                // Button to nudge the image right
//                Button(action: {
//                    // if lock is  on doesn't perform nudge
////                    if lockStatus{
//                        //                    self.posX += nudgeAmount
//                        self.baseFrame.center.x += nudgeAmount
////                    }
//                }) {
//                    SwiftUI.Image(systemName: "arrow.right")
//                        .padding()
//                        .foregroundColor(.label)
//                        .frame(width: 60, height: 40)
//                        .background(Color.secondarySystemBackground)
//                        .cornerRadius(5)
//                }
//                .onLongPressGesture(perform: {
//                    //                self.startNudging(direction: .up)
//                }, onPressingChanged: { value in
//                    if value{
//                        // if lock is  on doesn't perform nudge
////                        if lockStatus{
//                            isNudging = true
//                            //                        beginPosX = posX
//                            beginFrame = baseFrame
//                            self.startNudging(direction: .right)
//                            print("on change")
//                        }else{
//                            isNudging = false
//                            nudgeAmount = 1
//                            //                        endPosX = posX
//                            endFrame = baseFrame
//                            print("on end")
//                        }
////                    }
//                })
//                
//                // Button to nudge the image up
//                Button {
//                    // if lock is  on doesn't perform nudge
////                    if lockStatus{
//                        //                    self.posY -= nudgeAmount
//                        self.baseFrame.center.y -= nudgeAmount
////                    }
//                } label: {
//                    SwiftUI.Image(systemName: "arrow.up")
//                        .padding()
//                        .foregroundColor(.label)
//                        .frame(width: 60, height: 40)
//                        .background(Color.secondarySystemBackground)
//                        .cornerRadius(5)
//                }
//                .onLongPressGesture(perform: {
//                    //                self.startNudging(direction: .up)
//                }, onPressingChanged: { value in
//                    // if lock is  on doesn't perform nudge
////                    if lockStatus{
//                        if value{
//                            isNudging = true
//                            //                        beginPosY = posY
//                            beginFrame = baseFrame
//                            self.startNudging(direction: .up)
//                            print("on change")
//                        }else{
//                            isNudging = false
//                            nudgeAmount = 1
//                            //                        endPosY = posY
//                            endFrame = baseFrame
//                            print("on end")
//                        }
////                    }
//                })
//                
//                
//                // Button to nudge the image down
//                Button(action: {
//                    // if lock is  on doesn't perform nudge
////                    if lockStatus{
//                        //                    self.posY += nudgeAmount
//                        self.baseFrame.center.y += nudgeAmount
////                    }
//                }) {
//                    SwiftUI.Image(systemName: "arrow.down")
//                        .padding()
//                        .foregroundColor(.label)
//                        .frame(width: 60, height: 40)
//                        .background(Color.secondarySystemBackground)
//                        .cornerRadius(5)
//                }
//                .onLongPressGesture(perform: {
//                    //                self.startNudging(direction: .up)
//                }, onPressingChanged: { value in
//                    // if lock is  on doesn't perform nudge
////                    if lockStatus{
//                        if value{
//                            isNudging = true
//                            //                        beginPosY = posY
//                            beginFrame = baseFrame
//                            self.startNudging(direction: .down)
//                            print("on change")
//                        }else{
//                            isNudging = false
//                            nudgeAmount = 1
//                            //                        endPosY = posY
//                            endFrame = baseFrame
//                            print("on end")
//                        }
////                    }
//                })
//                
//            }
//        }.frame(height: 125)
//        
//    }
//    
//    private func startNudging(direction: Direction) {
//        guard isNudging && lockStatus else { return }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            if self.isNudging {
//                switch direction {
//                case .up:
////                    self.posY -= nudgeAmount
//                    self.baseFrame.center.y -= nudgeAmount
//                case .down:
////                    self.posY += nudgeAmount
//                    self.baseFrame.center.y += nudgeAmount
//                case .left:
////                    self.posX -= nudgeAmount
//                    self.baseFrame.center.x -= nudgeAmount
//                case .right:
////                    self.posX += nudgeAmount
//                    self.baseFrame.center.x += nudgeAmount
//                }
//                self.startNudging(direction: direction)
//                nudgeAmount += 1
//            }
//            
//        }
//    }
//    
//}

//#Preview {
//    NudgePanelView(posX: .constant(1), posY: .constant(1), beginPosX: .constant(1), endPosX: .constant(1), beginPosY: .constant(1), endPosY: .constant(1))
//}

enum Direction{
    case up
    case down
    case left
    case right
}
struct NudgePanelView: View {
    @State var nudgeAmount: CGFloat = 1.0
    @State private var isNudging = false
    @Binding var lockStatus: Bool
    @Binding var baseFrame: Frame
    @Binding var beginFrame: Frame
    @Binding var endFrame: Frame
    @Binding var isNudgeAllowed: Bool

    var body: some View {
        VStack {
            HStack(spacing: 40) {

                // Button to nudge the image left
                Button(action: {
                    if !lockStatus{
                        self.baseFrame.center.x -= nudgeAmount
                    }else{
                        isNudgeAllowed = true
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .padding()
                        .foregroundColor(.primary)
                        .frame(width: 60, height: 40)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(5)
                }
//                .disabled(lockStatus)
                .onLongPressGesture(pressing: { value in
                    if !lockStatus {
                        if value {
                            isNudging = true
                            beginFrame = baseFrame
                            self.startNudging(direction: .left)
                        } else {
                            isNudging = false
                            nudgeAmount = 1
                            endFrame = baseFrame
                        }
                    }else{
                        isNudgeAllowed = true
                    }
                }, perform: {})

                // Button to nudge the image right
                Button(action: {
                    if !lockStatus{
                        self.baseFrame.center.x += nudgeAmount
                    }else{
                        isNudgeAllowed = true
                    }
                }) {
                    Image(systemName: "arrow.right")
                        .padding()
                        .foregroundColor(.primary)
                        .frame(width: 60, height: 40)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(5)
                }
//                .disabled(lockStatus)
                .onLongPressGesture(pressing: { value in
                    if !lockStatus {
                        if value {
                            isNudging = true
                            beginFrame = baseFrame
                            self.startNudging(direction: .right)
                        } else {
                            isNudging = false
                            nudgeAmount = 1
                            endFrame = baseFrame
                        }
                    }else{
                        isNudgeAllowed = true
                    }
                }, perform: {})

                // Button to nudge the image up
                Button(action: {
                    if !lockStatus{
                        self.baseFrame.center.y -= nudgeAmount
                    }else{
                        isNudgeAllowed = true
                    }
                }) {
                    Image(systemName: "arrow.up")
                        .padding()
                        .foregroundColor(.primary)
                        .frame(width: 60, height: 40)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(5)
                }
//                .disabled(lockStatus)
                .onLongPressGesture(pressing: { value in
                    if !lockStatus {
                        if value {
                            isNudging = true
                            beginFrame = baseFrame
                            self.startNudging(direction: .up)
                        } else {
                            isNudging = false
                            nudgeAmount = 1
                            endFrame = baseFrame
                        }
                    }else{
                        isNudgeAllowed = true
                    }
                }, perform: {})

                // Button to nudge the image down
                Button(action: {
                    if !lockStatus{
                        self.baseFrame.center.y += nudgeAmount
                    }else{
                        isNudgeAllowed = true
                    }
                }) {
                    Image(systemName: "arrow.down")
                        .padding()
                        .foregroundColor(.primary)
                        .frame(width: 60, height: 40)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(5)
                }
//                .disabled(lockStatus)
                .onLongPressGesture(pressing: { value in
                    if !lockStatus {
                        if value {
                            isNudging = true
                            beginFrame = baseFrame
                            self.startNudging(direction: .down)
                        } else {
                            isNudging = false
                            nudgeAmount = 1
                            endFrame = baseFrame
                        }
                    }else{
                        isNudgeAllowed = true
                    }
                }, perform: {})
            }
        }
        .frame(height: 125)
    }

    private func startNudging(direction: Direction) {
        guard isNudging && !lockStatus else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.isNudging && !lockStatus {
                switch direction {
                case .up:
                    self.baseFrame.center.y -= nudgeAmount
                case .down:
                    self.baseFrame.center.y += nudgeAmount
                case .left:
                    self.baseFrame.center.x -= nudgeAmount
                case .right:
                    self.baseFrame.center.x += nudgeAmount
                }
                nudgeAmount += 1
                self.startNudging(direction: direction)
            }
        }
    }
}
