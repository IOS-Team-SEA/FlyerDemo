//
//  RSVPRepository.swift
//  VideoInvitation
//
//  Created by HKBeast on 28/04/25.
//

import Foundation
import UIKit

//protocol LoginRepositoryProtocol{
//    func verifyEmail(email: String) async throws -> VerifyEmailResponse
//    func verifyEmailCode(email: String, otp: String) async throws -> VerifyEmailCodeResponse
//    func updateUserData(userData: UserData, profileImage: UIImage?, authToken: String) async throws -> UserResponse
//    func deleteAccount(userId: Int, authToken: String) async throws -> DeleteAccountResponse
//    func logoutUser(userId: Int, authToken: String) async throws -> LogoutResponse
//}



//protocol UserProfileRespositoryProtocol{
//    func updateUserProfile(userData: UserData, profileImage: UIImage?, authToken: String) async throws -> UserResponse
//}

class RSVPRepository{
    
    @Injected var networkManager: RSVPNetworkManager
//    @Injected var rsvpAPIStore: RSVPAPIStrore
    
    init(){}
}


//extension RSVPRepository: LoginRepositoryProtocol{
//    func deleteAccount(userId: Int, authToken: String) async throws -> DeleteAccountResponse {
//        return try await networkManager.deleteAccount(urlString: rsvpAPIStore.deleteAccountAPI, userId: userId, authToken: authToken)
//    }
//    
//    func logoutUser(userId: Int, authToken: String) async throws -> LogoutResponse {
//        return try await networkManager.logoutUser(urlString: rsvpAPIStore.logoutUserAPI, userId: userId, authToken: authToken)
//    }
//    
//    func updateUserData(userData: UserData, profileImage: UIImage?, authToken: String) async throws -> UserResponse {
//        return try await networkManager.submitUserData(endpoint: .registerOrUpdateUser, profileImage: profileImage, authToken: authToken, user: userData)
//    }
//    
//    func verifyEmailCode(email: String, otp: String) async throws -> VerifyEmailCodeResponse {
//        return try await networkManager.verifyEmailCode(urlString: rsvpAPIStore.emailCodeVerifyAPI, email: email, otp: otp)
//    }
//    
//    func verifyEmail(email: String) async throws -> VerifyEmailResponse{
//        return try await networkManager.verifyEmail(urlString: rsvpAPIStore.emailVerifyAPI, email: email)
//    }
//}
//
//
//
//extension RSVPRepository: UserProfileRespositoryProtocol{
//    func updateUserProfile(userData: UserData, profileImage: UIImage?, authToken: String) async throws -> UserResponse{
//        return try await networkManager.updateUserProfile(endPoint: .registerOrUpdateUser, profileImage: profileImage, user: userData, authToken: authToken)
//    }
//}
