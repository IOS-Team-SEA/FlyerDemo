//
//  RSVPNetworkHandler.swift
//  VideoInvitation
//
//  Created by HKBeast on 22/04/25.
//

import Foundation
import UIKit
import IOS_CommonEditor
//import FirebaseAuth

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case noInternet
    case noData
    case decodingError
    case downloadError
    
    // TODO: JM IF THIS IS WHAT USED AlL OVER RSVP PUT CODE( COMMON COD ) AND LOG MESSAGE HERE INSTEAD OF EVERYWHERE
}

class RSVPNetworkHandler{
    
    private let baseURL = "https://prod-api.backendcore.com/webservices/ZMA_LogoMaker"
//    var BASE_URL = "https://dev-cdn.backendcore.com/PartyzaRsvp/"
    var BASE_URL = "https://prod-cdn.backendcore.com/"
//    var userProfileVM: UserProfileVM!
//    @Injected var userProfileVM: UserProfileVM
    
    func encodableToFormFields<T: Encodable>(_ model: T) throws -> [String: String] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(model)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        
        var formFields: [String: String] = [:]
        for (key, value) in json {
            formFields[key] = "\(value)"
        }
        return formFields
    }
    
    func encodableToFormFieldsForEvents<T: Encodable>(_ model: T) throws -> [String: String] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // optional, for easier debugging
        let data = try encoder.encode(model)
        
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return [:]
        }

        var formFields: [String: String] = [:]

        for (key, value) in jsonObject {
            if JSONSerialization.isValidJSONObject(value) {
                let nestedData = try JSONSerialization.data(withJSONObject: value, options: [])
                if let jsonString = String(data: nestedData, encoding: .utf8) {
                    formFields[key] = jsonString
                }
            } else {
                formFields[key] = "\(value)"
            }
        }
      //  formFields["allowEdit"] = "1"

        return formFields
    }
    
//    func createMultipartBody(user: UserData,
//                             profileImage: UIImage?, boundary: String) -> Data {
//        var body = Data()
//
//        do{
//            let fields = try encodableToFormFields(user)
//            
//            for (key, value) in fields {
//                body.append("--\(boundary)\r\n".data(using: .utf8)!)
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//                body.append("\(value)\r\n".data(using: .utf8)!)
//            }
//            
//            // Optional: Add image if provided
//            if let image = profileImage,
//               let imageData = image.jpegData(compressionQuality: 0.8) {
//                
//                body.append("--\(boundary)\r\n".data(using: .utf8)!)
//                body.append("Content-Disposition: form-data; name=\"profileImage\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
//                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//                body.append(imageData)
//                body.append("\r\n".data(using: .utf8)!)
//            }
//            
//            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//            
//        }catch {
//            printLog("🚫 Error: \(error.localizedDescription)")
//        }
//        return body
//    }
    
 
//    func submitUserData(endpoint: APIEndpoint,
//                        profileImage: UIImage?, authToken: String, user: UserData) async throws -> UserResponse{
//        let path = endpoint.path
//        let method = endpoint.method
//        guard let url = URL(string: baseURL + path) else {
//            throw NSError(domain: "Invalid URL", code: -1)
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        request.setValue("ios", forHTTPHeaderField: "x-service-account")
//
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        let body = createMultipartBody(user: user,
//                                       profileImage: profileImage, boundary: boundary)
//        request.httpBody = body
//
//        do{
//            let (data, response) = try await URLSession.shared.data(for: request)
//                
//            // Log the status code for debugging purposes
//            if let httpResponse = response as? HTTPURLResponse {
//                printLog("Status Code: \(httpResponse.statusCode)")
//                
//                switch httpResponse.statusCode {
//                case 200:
//                    // Success, proceed to decode data
//                    break
//                case 201:
//                    break
//                case 401:
//                    // Re-authenticate user and regenerate token
//                    let userProfileVM: UserProfileVM = Injection.shared.inject(id: "UserProfileVM", type: UserProfileVM.self)!
//                    let token = try await regenerateToken()
//                    await userProfileVM.updateAuthToken(authToken: token)
//                    // Retry the request with the new token
//                    return try await submitUserData(endpoint: endpoint, profileImage: profileImage, authToken: token, user: user)
////                    break
//                case 404:
//                    // Handle resource not found (404)
//                    printLog("Error: Resource not found")
//                    break
//                case 500...599:
//                    // Handle server errors
//                    printLog("Error: Server error with status code \(httpResponse.statusCode)")
//                    throw NetworkError.downloadError
//                default:
//                    // Handle other non-success status codes
//                    printLog("Error: Unexpected status code \(httpResponse.statusCode)")
//                    throw NetworkError.invalidResponse
//                }
//            }
//            
//                // Check if data is not empty
//                guard !data.isEmpty else {
//                    throw NetworkError.noData
//                }
//                
//            let decoder = JSONDecoder()
//            let decodedModel = try decoder.decode(UserResponse.self, from: data)
//            return decodedModel
//        }catch let urlError as URLError{
//            printLog("URL Error: \(urlError.code)")
//            if urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
//                throw NetworkError.noInternet
//            } else {
//                throw NetworkError.downloadError
//            }
//        }catch{
//            throw NetworkError.decodingError
//        }
//
//    }
    
//    func verifyEmail(from urlString: String, email: String) async throws -> VerifyEmailResponse {
//        // Construct the full URL
//        guard let url = URL(string: urlString) else {
//            throw NetworkError.invalidURL
//        }
//        
//        // Prepare the request
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer abc", forHTTPHeaderField: "Authorization")
//        request.setValue("ios", forHTTPHeaderField: "x-service-account")
//        
//        // Create the request body with the mobile number
//        let requestBody = VerifyEmailRequest(email: email)
//        let encoder = JSONEncoder()
//        
//        do {
//            // Encode the request body to JSON
//            let jsonData = try encoder.encode(requestBody)
//            request.httpBody = jsonData
//        } catch {
//            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
//                printLog("No internet connection.")
//                throw NetworkError.noInternet
//            }else{
//                throw NetworkError.invalidData
//            }
//        }
//        
//        // Perform the request
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        // Check if data is not empty
//        guard !data.isEmpty else {
//            throw NetworkError.noData
//        }
//        
//        // Check the response status code
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw NetworkError.invalidResponse
//        }
//        
//        do{
//            // Decode the response data
//            let decoder = JSONDecoder()
//            let verifyResponse = try decoder.decode(VerifyEmailResponse.self, from: data)
//            
//            // Print the response
//            printLog("Response: \(verifyResponse)")
//            
//            // Store the role in the emp_role variable
//            return verifyResponse
//        }catch{
//            throw NetworkError.decodingError
//        }
//        
//    }
    
//    func verifyCode(from urlString: String, email: String, otpCode: String) async throws -> VerifyEmailCodeResponse {
//        // Construct the full URL
//        guard let url = URL(string: urlString) else {
//            throw NetworkError.invalidURL
//        }
//        
//        // Prepare the request
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer abc", forHTTPHeaderField: "Authorization")
//        request.setValue("ios", forHTTPHeaderField: "x-service-account")
//        
//        // Create the request body with the mobile number
//        let requestBody = VerifyEmailCodeRequest(email: email, otp: otpCode)
//        let encoder = JSONEncoder()
//        
//        do {
//            // Encode the request body to JSON
//            let jsonData = try encoder.encode(requestBody)
//            request.httpBody = jsonData
//        } catch {
//            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
//                printLog("No internet connection.")
//                throw NetworkError.noInternet
//            }else{
//                throw NetworkError.invalidData
//            }
//        }
//        
//        // Perform the request
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        // Check if data is not empty
//        guard !data.isEmpty else {
//            throw NetworkError.noData
//        }
//        
//        // Check the response status code
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw NetworkError.invalidResponse
//        }
//        
//        do{
//            // Decode the response data
//            let decoder = JSONDecoder()
//            let verifyResponse = try decoder.decode(VerifyEmailCodeResponse.self, from: data)
//            
//            // Print the response
//            printLog("Response: \(verifyResponse)")
//            
//            // Store the role in the emp_role variable
//            return verifyResponse
//        }catch{
//            throw NetworkError.decodingError
//        }
//        
//    }
    
//    func getRequest<T: Decodable>(endpoint: APIEndpoint, parameters: [String: String?] = [:], authToken: String, body: Data? = nil, type: T.Type)async throws -> T{
//        let path = endpoint.path
//        let method = endpoint.method
//        let query = QueryBuilder.build(parameters)
//        guard let url = URL(string: baseURL + path + query) else {
//            throw NSError(domain: "Invalid URL", code: -1)
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        request.setValue("ios", forHTTPHeaderField: "x-service-account")
//
//        logVerbose("API CAll", url)
//        do{
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            // Log the status code for debugging purposes
//            if let httpResponse = response as? HTTPURLResponse {
//                printLog("Status Code: \(httpResponse.statusCode)")
//                
//                switch httpResponse.statusCode {
//                case 200:
//                    // Success, proceed to decode data
//                    break
//                case 201:
//                    break
//                case 401:
//                    // Re-authenticate user and regenerate token
//                    let userProfileVM: UserProfileVM = Injection.shared.inject(id: "UserProfileVM", type: UserProfileVM.self)!
//                    let token = try await regenerateToken()
//                    await userProfileVM.updateAuthToken(authToken: token)
//                    // Retry the request with the new token
//                    return try await getRequest(endpoint: endpoint, parameters: parameters, authToken: token, type: type)
////                    break
//                case 404:
//                    // Handle resource not found (404)
//                    printLog("Error: Resource not found")
//                    break
//                case 500...599:
//                    // Handle server errors
//                    printLog("Error: Server error with status code \(httpResponse.statusCode)")
//                    throw NetworkError.downloadError
//                default:
//                    // Handle other non-success status codes
//                    printLog("Error: Unexpected status code \(httpResponse.statusCode)")
//                    throw NetworkError.invalidResponse
//                }
//            }
//            //               decoder.dateDecodingStrategy = .formatted(DateFormatter())
//            
//            // Check if data is not empty
//            guard !data.isEmpty else {
//                throw NetworkError.noData
//            }
//            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                printLog("Raw JSON response: \(jsonString)")
//            }
//            
//            // Decode the data into the specified model
//            let decoder = JSONDecoder()
//            let decodedModel = try decoder.decode(T.self, from: data)
//            return decodedModel
//            
//        }catch let urlError as URLError{
//            printLog("URL Error: \(urlError.code)")
//            if urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
//                throw NetworkError.noInternet
//            } else {
//                throw NetworkError.downloadError
//            }
//        }catch{
//            throw NetworkError.decodingError
//        }
//    }
//    func addOrUpdateRequest<Body: Encodable, Response: Decodable>(endpoint: APIEndpoint, parameters: [String: String?] = [:], authToken: String, body: Body)async throws -> Response{
//        let path = endpoint.path
//        let method = endpoint.method
//        let query = QueryBuilder.build(parameters)
//        guard let url = URL(string: baseURL + path + query) else {
//            throw NSError(domain: "Invalid URL", code: -1)
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        request.setValue("ios", forHTTPHeaderField: "x-service-account")
//        
//        do{
//            // Encode the model to JSON data
//            let encoder = JSONEncoder()
//            let jsonData = try encoder.encode(body)
//            request.httpBody = jsonData
//            
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
////            // Check if data is not empty
////            guard !data.isEmpty else {
////                throw NetworkError.noData
////            }
//            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                printLog("Raw JSON response: \(jsonString)")
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                printLog("Status Code: \(httpResponse.statusCode)")
//                
//                switch httpResponse.statusCode {
//                case 200:
//                    // Success, proceed to decode data
//                    let decoded = try JSONDecoder().decode(Response.self, from: data)
//                    return decoded
//                case 201:
//                    break
//                case 401:
//                    // Re-authenticate user and regenerate token
//                    let userProfileVM: UserProfileVM = Injection.shared.inject(id: "UserProfileVM", type: UserProfileVM.self)!
//                    let token = try await regenerateToken()
//                    await userProfileVM.updateAuthToken(authToken: token)
//                    // Retry the request with the new token
//                    return try await addOrUpdateRequest(endpoint: endpoint, parameters: parameters, authToken: token, body: body)
////                    break
//                case 404:
//                    // Handle resource not found (404)
//                    printLog("Error: Resource not found")
//                    break
//                case 500...599:
//                    // Handle server errors
//                    printLog("Error: Server error with status code \(httpResponse.statusCode)")
//                    throw NetworkError.downloadError
//                default:
//                    // Handle other non-success status codes
//                    printLog("Error: Unexpected status code \(httpResponse.statusCode)")
//                    throw NetworkError.invalidResponse
//                }
//            }
//            let decoded = try JSONDecoder().decode(Response.self, from: data)
//            return decoded
//        }catch let urlError as URLError{
//            printLog("URL Error: \(urlError.code)")
//            if urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
//                throw NetworkError.noInternet
//            } else {
//                throw NetworkError.downloadError
//            }
//        }catch{
//            throw NetworkError.decodingError
//        }
//    }
    
  

    
    func fetchImage(imageURL: String) async throws -> UIImage? {
        do {
            guard let url = URL(string: "\(BASE_URL)\(imageURL)") else {
                throw URLError(.badURL)
            }
            
            printLog("Starting network request...\(imageURL)")
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
            }
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.decodingError
            }
            
            return image
            
        } catch {
            throw NetworkError.noInternet
        }
    }
    
    func fetchProfileImage(imageURL: String) async throws -> UIImage? {
        do {
            guard let url = URL(string: "\(BASE_URL)\(imageURL)") else {
                throw URLError(.badURL)
            }
            
            printLog("Starting network request...\(imageURL)")
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
            }
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.decodingError
            }
            
            return image
            
        } catch {
            throw NetworkError.noInternet
        }
    }
    
    
    func fetchGoogleImage(imageURL: String) async throws -> UIImage? {
        do {
            guard let url = URL(string: "\(imageURL)") else {
                throw URLError(.badURL)
            }
            
            printLog("Starting network request...\(imageURL)")
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
            }
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.decodingError
            }
            
            return image
            
        } catch {
            throw NetworkError.noInternet
        }
    }
    
    func fetchTemplateData(endPoint: String) async throws -> ServerDBTemplate {
        guard let url = URL(string: "\(BASE_URL)\(endPoint)") else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check for response errors
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            // Check if data exists
            guard !data.isEmpty else {
                throw NetworkError.noData
            }

            let decoder = JSONDecoder()
            let templates = try decoder.decode(ServerDBTemplate.self, from: data)

            return templates
        } catch let decodingError as DecodingError {
            printLog("Decoding error: \(decodingError)")
            throw NetworkError.decodingError
        } catch {
            printLog("Unexpected error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
//    func deleteUserAccount(from urlString: String, userId: Int, authToken: String) async throws -> DeleteAccountResponse{
//        guard let url = URL(string: urlString) else {
//            throw NetworkError.invalidURL
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        request.setValue("ios", forHTTPHeaderField: "x-service-account")
//        
//        let requestBody = DeleteAccountRequest(userId: userId)
//        let encoder = JSONEncoder()
//        
//        do {
//            // Encode the request body to JSON
//            let jsonData = try encoder.encode(requestBody)
//            request.httpBody = jsonData
//            
//            
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                printLog("Status Code: \(httpResponse.statusCode)")
//                
//                switch httpResponse.statusCode {
//                case 200:
//                    // Success, proceed to decode data
//                    let decoder = JSONDecoder()
//                    let verifyResponse = try decoder.decode(DeleteAccountResponse.self, from: data)
//                    
//                    // Print the response
//                    printLog("Response: \(verifyResponse)")
//                    
//                    // Store the role in the emp_role variable
//                    return verifyResponse
//                case 201:
//                    break
//                case 401:
//                    // Re-authenticate user and regenerate token
//                    let userProfileVM: UserProfileVM = Injection.shared.inject(id: "UserProfileVM", type: UserProfileVM.self)!
//                    let token = try await regenerateToken()
//                    await userProfileVM.updateAuthToken(authToken: token)
//                    // Retry the request with the new token
//                    return try await deleteUserAccount(from: urlString, userId: userId, authToken: token)
//                    //                    break
//                case 404:
//                    // Handle resource not found (404)
//                    printLog("Error: Resource not found")
//                    break
//                case 500...599:
//                    // Handle server errors
//                    printLog("Error: Server error with status code \(httpResponse.statusCode)")
//                    throw NetworkError.downloadError
//                default:
//                    // Handle other non-success status codes
//                    printLog("Error: Unexpected status code \(httpResponse.statusCode)")
//                    throw NetworkError.invalidResponse
//                }
//            }
//            // Check if data is not empty
//            guard !data.isEmpty else {
//                throw NetworkError.noData
//            }
//            
//            
//            // Decode the response data
//            let decoder = JSONDecoder()
//            let verifyResponse = try decoder.decode(DeleteAccountResponse.self, from: data)
//            
//            // Print the response
//            printLog("Response: \(verifyResponse)")
//            
//            // Store the role in the emp_role variable
//            return verifyResponse
//            
//        }catch let urlError as URLError{
//            printLog("URL Error: \(urlError.code)")
//            if urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
//                throw NetworkError.noInternet
//            } else {
//                throw NetworkError.downloadError
//            }
//        }catch{
//            throw NetworkError.decodingError
//        }
//    }
    
//    func logoutUserAccount(from urlString: String, userId: Int, authToken: String) async throws -> LogoutResponse{
//        guard let url = URL(string: urlString) else {
//            throw NetworkError.invalidURL
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        request.setValue("ios", forHTTPHeaderField: "x-service-account")
//        
//        let requestBody = DeleteAccountRequest(userId: userId)
//        let encoder = JSONEncoder()
//        
//        do {
//            // Encode the request body to JSON
//            let jsonData = try encoder.encode(requestBody)
//            request.httpBody = jsonData
//            
//            
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                printLog("Status Code: \(httpResponse.statusCode)")
//                
//                switch httpResponse.statusCode {
//                case 200:
//                    // Success, proceed to decode data
//                    let decoder = JSONDecoder()
//                    let verifyResponse = try decoder.decode(LogoutResponse.self, from: data)
//                    
//                    // Print the response
//                    printLog("Response: \(verifyResponse)")
//                    
//                    // Store the role in the emp_role variable
//                    return verifyResponse
//                case 201:
//                    break
//                case 401:
//                    // Re-authenticate user and regenerate token
//                    let userProfileVM: UserProfileVM = Injection.shared.inject(id: "UserProfileVM", type: UserProfileVM.self)!
//                    let token = try await regenerateToken()
//                    await userProfileVM.updateAuthToken(authToken: token)
//                    // Retry the request with the new token
//                    return try await logoutUserAccount(from: urlString, userId: userId, authToken: token)
//                    //                    break
//                case 404:
//                    // Handle resource not found (404)
//                    printLog("Error: Resource not found")
//                    break
//                case 500...599:
//                    // Handle server errors
//                    printLog("Error: Server error with status code \(httpResponse.statusCode)")
//                    throw NetworkError.downloadError
//                default:
//                    // Handle other non-success status codes
//                    printLog("Error: Unexpected status code \(httpResponse.statusCode)")
//                    throw NetworkError.invalidResponse
//                }
//            }
//            
//            // Check if data is not empty
//            guard !data.isEmpty else {
//                throw NetworkError.noData
//            }
//            
//            
//            let decoder = JSONDecoder()
//            let verifyResponse = try decoder.decode(LogoutResponse.self, from: data)
//            
//            // Print the response
//            printLog("Response: \(verifyResponse)")
//            
//            // Store the role in the emp_role variable
//            return verifyResponse
//        }catch let urlError as URLError{
//            printLog("URL Error: \(urlError.code)")
//            if urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
//                throw NetworkError.noInternet
//            } else {
//                throw NetworkError.downloadError
//            }
//        }catch{
//            throw NetworkError.decodingError
//        }
//    }
    
//    func regenerateToken() async throws -> String{
//        return try await withCheckedThrowingContinuation { continuation in
//            if let user = Auth.auth().currentUser {
//                user.getIDToken { token, error in
//                    if let error = error {
//                        printLog("Error fetching ID token: \(error)")
//                        continuation.resume(throwing: error)
//                    } else if let token = token {
////                        var updatedData = UserData.loadUserData()
////                        updatedData.authToken = token
////                        UserDefaults.standard.saveUserData(updatedData)
//                        continuation.resume(returning: token)
//                    } else {
//                        continuation.resume(throwing: NetworkError.unableToComplete)
//                    }
//                }
//            } else {
//                printLog("User is not signed in.")
//                continuation.resume(throwing: NSError(domain: "FirebaseAuth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not signed in"]))
//            }
//        }
//    }
}

struct VerifyEmailCodeRequest: Encodable {
    let email: String
    let otp: String
}

struct DeleteAccountRequest: Encodable {
    let userId: Int
}

struct DeleteAccountResponse: Decodable {
    let status: Bool
    let message: String
    let messageCode: String
    let data: DeleteAccountData?
}

//struct LogoutResponse: Decodable {
//    let status: Bool
//    let message: String
//    let messageCode: String
//    let data: UserData?
//}

struct DeleteAccountData: Decodable{
    let displayName: String
    let userId: Int
    let email: String
}

struct VerifyEmailCodeResponse: Decodable {
    let status: Bool
    let message: String
    let messageCode: String
    let data: Bool?
}

struct VerifyEmailRequest: Encodable {
    let email: String
}

struct VerifyEmailResponse: Decodable {
    let status: Bool
    let message: String
    let messageCode: String
    let data: Bool?
}

