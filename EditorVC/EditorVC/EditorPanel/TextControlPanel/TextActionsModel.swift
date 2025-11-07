//
//  TextActionsModel.swift
//  VideoInvitation
//
//  Created by Neeshu Kumar on 13/03/24.
//

import Foundation

class TextActionsModel : ObservableObject{
    @Published var duplicate : Bool = false
    @Published var copy : Bool = false
    @Published var paste : Bool = false
    @Published var group : Bool = false
    @Published var ungroup : Bool = false
    @Published var isOpacityEnded : Bool = false
    
    
    
}
