//
//  APIHandler.swift
//  HomeScreenPartyza
//
//  Created by HKBeast on 10/09/24.
//

import Foundation
import IOS_CommonEditor


struct TemplateResponseAI: Codable {
    // Define your model properties here
}

struct CategoriesApiResponse: Codable {
    let categories:[CategoryModel]
}

struct TrendingTemplateResponseAI: Codable {
    // Define your model properties here
}


enum ServerError: Error, LocalizedError {
    case invalidURL
    case noData
    case parsingError
    case networkError
    case slowInternet
    case internetNotAvailable
    case httpError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was returned from the server."
        case .parsingError:
            return "Failed to parse the data."
        case .networkError:
            return "There was a network error."
        case .slowInternet:
            return "The network is too slow."
        case .internetNotAvailable:
            return "Internet connection is not available."
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        }
    }
    static func ==(lhs: ServerError, rhs: ServerError) -> Bool {
           switch (lhs, rhs) {
           case (.internetNotAvailable, .internetNotAvailable):
               return true
           case (.noData, .noData):
               return true
           default:
               return false
           }
       }
}





import Foundation
import Network

struct APIStore {
    
    static var baseURL : String {
        #if DEBUG
        return "https://prod-api.backendcore.com/webservices/ZMA_LogoMaker/"
        #endif
        return "https://prod-api.backendcore.com/webservices/ZMA_LogoMaker/"
    }
    
    static var baseURL2 : String {
        return "https://prod-cdn.backendcore.com/"
    }
    
    static var getArticleURL : String {
//        "https://gopartyza.com/wp-json/wp/v2/posts?_fields=id,title,link,featured_media" page=1&limit=10
        "https://prod-api.backendcore.com/webservices/Psma_PartyZa_Prod/getArticles.php?"
    }
    
    
    
    
}

class ApiService {
    private func makeRequest<T: Codable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            printLog("invalid URL: \(urlString)")
            throw ServerError.invalidURL
        }
        
        // Check for internet availability first
        guard await isInternetAvailable() else {
            printLog("internet not available")
            throw ServerError.internetNotAvailable
        }
        
        // Simulate checking for slow internet (Optional)
        let startTime = Date()
        let (data, response) = try await URLSession.shared.data(from: url)
        let timeElapsed = Date().timeIntervalSince(startTime)
        
        // If the request takes longer than a threshold, consider it as slow internet
        if timeElapsed > 30 { // Adjust the threshold as needed
            printLog("slow Internet")
            throw ServerError.slowInternet
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServerError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        guard !data.isEmpty else {
            printLog("No data for request: \(urlString)")
            throw ServerError.noData
        }
        
        do {
            logInfo("API CALL ATTEMPTED AND RESPONSE \(urlString)")
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            printLog("Error parsing JSON: \(error)")
            throw ServerError.parsingError
        }
    }

    // 1. Get Filters
//    func getFilters() async throws -> FilterResponse {
//        
//        let url = "\(APIStore.baseURL)getFilters.php"
//        return try await makeRequest(urlString: url)
//    }
//    


//    func getTemplatesFromServer(page: Int, filters: [String: String]?, search: String) async throws -> TemplatesResponse? {
//        var urlComponents = URLComponents(string: "\(APIStore.baseURL)getTemplatesV1.php")!
//        
//        // Prepare query items for page and search
//        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
//        
//        // Add filters if available
//         if let filters = filters, !filters.isEmpty {
//             for (key, value) in filters {
//                 // Add each key-value pair directly to the queryItems
//                 queryItems.append(URLQueryItem(name: key, value: value))
//             }
//         }
//         
//        
//        // Add search parameter
//        queryItems.append(URLQueryItem(name: "search", value: search))
//        
//        urlComponents.queryItems = queryItems
//        
//        guard let urlString = urlComponents.url?.absoluteString else {
//            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
//        }
//        
//        return try await makeRequest(urlString: urlString)
//    }
//    
//    
//    // 3. Get Templates without Search
//    func getTemplatesFromServer(page: Int, filters: [String: String]?) async throws -> TemplatesResponse? {
//        var urlComponents = URLComponents(string: "\(APIStore.baseURL)getTemplatesV1.php")!
//        
//        // Prepare query items for page and search
//        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
//        
//        // Add filters if available
//         if let filters = filters, !filters.isEmpty {
//             for (key, value) in filters {
//                 // Add each key-value pair directly to the queryItems
//                 queryItems.append(URLQueryItem(name: key, value: value))
//             }
//         }
//         
//        urlComponents.queryItems = queryItems
//        
//        guard let urlString = urlComponents.url?.absoluteString else {
//            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
//        }
//
//       
//
//
//        return try await makeRequest(urlString: urlString)
//
//    }
    
    func logAccess(urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            printLog("invalid URL: \(urlString)")
            throw ServerError.invalidURL
        }
        
        guard await isInternetAvailable() else {
            printLog("internet not available")
            throw ServerError.internetNotAvailable
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"


        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("Access logged successully")
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ServerError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        
        // If the API returns a meaningful response, decode it here.
        // For this example, assuming the response is empty:
        // let result = try JSONDecoder().decode(LogAccessResponse.self, from: data)
        // Handle the response or result as needed
    }
    
    func increaseTemplateScore(templateId: Int, country: String) async throws{
        let url = "\(APIStore.baseURL)log_access.php?template_id=\(templateId)&country=\(country)"
        
        try await logAccess(urlString: url)
    }

    // 4. Get All Categories
    func getAllCategories() async throws -> [CategoryModel] {
        let url = "https://prod-api.backendcore.com/webservices/ZMA_LogoMaker/getCategories.php" //"\(APIStore.baseURL2)Data/Categories.json"//getCategories.php"
//        https://prod-api.backendcore.com/webservices/ZMA_LogoMaker/getCategories.php
        return try await makeRequest(urlString: url)
    }
    
    // 5. Get Trending Templates
//    func getTrendingTemplates(country: String) async throws -> TrendingResponse {
//        let url = "\(APIStore.baseURL)trending.php?country=\(country)"
//        return try await makeRequest(urlString: url)
//    }

   
    func isInternetAvailable() async -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetCheck")
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }
        
        monitor.start(queue: queue)
        semaphore.wait() // Wait for the path update handler to execute
        monitor.cancel() // Cancel immediately to release resources
        
        return isConnected
    }
    
    
    // Function to hit the server with template_id and country parameters
    func hitServer(templateID: Int, country: String) async throws {
        // Construct the base URL
        var components = URLComponents(string: APIStore.baseURL)
        
        // Add query parameters
        components?.queryItems = [
            URLQueryItem(name: "template_id", value: String(templateID)),
            URLQueryItem(name: "country", value: country)
        ]
        
        // Ensure the URL is valid
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the response status code
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("Request successful, response: \(data)")
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
}
