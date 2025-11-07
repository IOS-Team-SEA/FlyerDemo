//
//  RatingAPI.swift
//  VideoInvitation
//
//  Created by J D on 11/09/25.
//

import UIKit

enum AppInfo {
    static var bundleId: String { Bundle.main.bundleIdentifier ?? "unknown.bundle" }
    static var appVersion: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0"
    }
    static var iosVersion: String { UIDevice.current.systemVersion }
    static var deviceModel: String { UIDevice.current.model } // e.g., "iPhone"
    static var country: String { Locale.current.region?.identifier ?? "IN" }
    static var language: String { Locale.current.language.languageCode?.identifier ?? "en" }
}

enum APIStoreV2 {
    static var baseURL: String {
        (Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String) ?? ""
    }
    static var storeFeedbackPath: String {
        (Bundle.main.object(forInfoDictionaryKey: "API_STORE_FEEDBACK_PATH") as? String) ?? ""
    }
    static var storeFeedbackURL: URL {
        URL(string: baseURL + storeFeedbackPath)!
    }
}

struct StoreFeedbackRequest: Encodable {
    let key: String
    let country: String
    let language: String
    let device: String
    let appVersion: String
    let iosVersion: String   // if server insists on 'android_version', rename property + CodingKeys
    let comment: String
    let appName: String
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case key, country, language, device, comment, rating
        case appVersion = "app_version"
        case iosVersion = "ios_version"     // change to "android_version" if API requires
        case appName = "app_name"
    }
}

struct StoreFeedbackResponse: Decodable {
    let status: String?      // e.g., "success"/"error"
    let message: String?
    let code: Int?
}


protocol RatingServiceProtocol {
    func submitFeedback(rating: Double, note: String?) async throws
}

enum RatingServiceError: Error, LocalizedError {
    case invalidURL, badStatus(Int), emptyData, decodingFailed, transport(Error)
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .badStatus(let s): return "Server error (\(s))"
        case .emptyData: return "Empty response"
        case .decodingFailed: return "Failed to parse response"
        case .transport(let e): return e.localizedDescription
        }
    }
}

final class MockRatingService: RatingServiceProtocol {
    func submitFeedback(rating: Double, note: String?) async throws {
        try await Task.sleep(nanoseconds: 900_000_000) // 0.9s mock
        // Simulate success; throw to test error path
        // if Bool.random() { throw URLError(.badServerResponse) }
    }
}

final class APIRatingService: RatingServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func submitFeedback(rating: Double, note: String?) async throws {
        var request = URLRequest(url: APIStoreV2.storeFeedbackURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = StoreFeedbackRequest(
            key: "Review",
            country: AppInfo.country,
            language: AppInfo.language,
            device: AppInfo.deviceModel,
            appVersion: AppInfo.appVersion,
            iosVersion: AppInfo.iosVersion,   // if API expects android_version, change DTO CodingKeys
            comment: note?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? note! : "—",
            appName: AppInfo.bundleId,
            rating: rating
        )

        request.httpBody = try JSONEncoder().encode(body)

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw RatingServiceError.emptyData }
            guard (200...299).contains(http.statusCode) else { throw RatingServiceError.badStatus(http.statusCode) }
            // Optional: parse server JSON for status/message
            if !data.isEmpty {
                if let model = try? JSONDecoder().decode(StoreFeedbackResponse.self, from: data) {
                    logInfo(model.message)
                }
            }
        } catch {
            throw RatingServiceError.transport(error)
        }
    }
}
