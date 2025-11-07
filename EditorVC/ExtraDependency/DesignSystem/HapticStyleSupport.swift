//
//  HapticStyle.swift
//  VideoInvitation
//
//  Created by J D on 07/09/25.
//

import UIKit


enum HapticStyle { case light, rigid, success, warning, error }

@MainActor
protocol AddHapticSupport {
  var hapticsAllowed : Bool { get set }
    func haptic(_ style: HapticStyle) async
}
@MainActor
extension AddHapticSupport {
     func haptic(_ style: HapticStyle) {
        guard hapticsAllowed else { return }
        switch style {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .rigid:
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}
