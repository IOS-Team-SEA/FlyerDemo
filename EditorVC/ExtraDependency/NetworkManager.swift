//
//  NetworkManager.swift
//  FlyerDemo
//
//  Created by HKBeast on 06/11/25.
//

import Foundation
import UIKit
import Combine
import Swift
import IOS_CommonEditor

class NetworkManager {
    let BASE_URL = "https://prod-cdn.backendcore.com/"
    static let shared = NetworkManager()
    private let cacheSemaphore = DispatchSemaphore(value: 1)
    private var cachedPhotosByCategory: [String: [Photo]] = [:]
    private var imageDataDictionary: [String: Data] = [:]
    
    private init() {}

    func downloadFontFromServer(fontName: String) async throws -> URL {
        // Construct the font URL
        guard let url = URL(string: BASE_URL + "Fonts/\(fontName)") else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            // Check if HTTP response is valid (status 200-299)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            var file = File(name: fontName, data: data, fileExtension: "")
            try AppFileManager.shared.fontAssets?.addFile(file: &file)

            print("Font downloaded and saved at: \(file.url)")
            return file.url!
        } catch {
            throw NetworkError.noInternet
        }
    }

    
    func downloadMusicFromServer(musicPath: String) async throws -> URL {
        // Construct the font URL
        guard let url = URL(string: BASE_URL + "\(musicPath)") else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            // Check if HTTP response is valid (status 200-299)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            let music = (musicPath as NSString).lastPathComponent
            var file = File(name: music, data: data, fileExtension: "")
            try AppFileManager.shared.music?.addFile(file: &file)

            print("Music downloaded and saved at: \(file.url)")
            return file.url!
        } catch {
            throw NetworkError.noInternet
        }
    }
    
    func fetchCategories() async throws -> [ServerCategoryModel] {
        let endPoint = "webservices/ZMA_LogoMaker/getCategories.php" // "Data/Categories.json"
        guard let url = URL(string: "\(BASE_URL)\(endPoint)") else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            // Check the HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                // If the status code is not 200 (OK), handle the error accordingly
                throw NetworkError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter())
            let categories = try decoder.decode([ServerCategoryModel].self, from: data)
            return categories
        } catch {
            throw NetworkError.decodingError
        }
    }

    
    func fetchTemplatesHeaders(endPoint: String) async throws -> [ServerDBTemplateHeader] {
        let endPoint = endPoint
        guard let url = URL(string: "\(BASE_URL)\(endPoint)") else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check the response for errors or unexpected status codes
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter())
            
            // Check if data is not empty
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            let templates = try decoder.decode([ServerDBTemplateHeader].self, from: data)
            print("Template from Server: \(templates)")
            return templates
        } catch {
            throw NetworkError.noInternet
        }
    }

    
    func    fetchTemplateData(endPoint: String) async throws -> ServerDBTemplate {
        guard let url = URL(string: "\(BASE_URL)\(endPoint)") else {
            throw NetworkError.invalidURL
        }
        logInfo("API CALL - Download Template url - \(url)")
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
            
//            var file = File(name: "template_Json_Test1", data: data, fileExtension: "json")
//            try AppFileManager.shared.music?.addFile(file: &file)
            
            let decoder = JSONDecoder()
            let templates = try decoder.decode(ServerDBTemplate.self, from: data)
//            print("Template Data from Server: \(templates)")
            return templates
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw NetworkError.decodingError
        } catch {
            print("Unexpected error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    
    func fetchAllTemplateData(endPoint: String) async throws -> AllTemplateData {
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
            let templates = try decoder.decode(AllTemplateData.self, from: data)
            print("All Template Data from Server: \(templates)")
            return templates
        } catch {
            print("NError \(error)")
            throw NetworkError.noInternet
        }
    }


    func downloadThumbnail(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check for HTTP response status codes indicating an error
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            guard let image = UIImage(data: data) else {
                throw NetworkError.decodingError
            }
            
            return image
        } catch {
            throw NetworkError.noInternet
        }
    }
    
    
    func fetchImage(imageURL: String) async throws -> UIImage? {
        do {
            let imageTask = Task { () -> UIImage? in
                guard let url = URL(string: "\(BASE_URL)\(imageURL)") else {
                    throw URLError(.badURL)
                }
                
                print("Starting network request...\(imageURL)")
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
            }
            
            return try await imageTask.value
        } catch {
            throw NetworkError.noInternet
        }
    }
    func fetchImageData(imageURL: String) async throws -> Data? {
        do {
                guard let url = URL(string: "\(BASE_URL)\(imageURL)") else {
                    throw URLError(.badURL)
                }
                
                print("Starting network request...\(imageURL)")
                let (data, response) = try await URLSession.shared.data(from: url)
                
                // Check HTTP response status code
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NSError(domain: "HTTP", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                }
                
                return data
          
        } catch {
            throw NetworkError.noInternet
        }
    }

    
    func fetchImageRSVP(imageURL: String) async throws -> UIImage? {
        do {
            let imageTask = Task { () -> UIImage? in
                guard let url = URL(string: "\(BASE_URL)\(imageURL)") else {
                    throw URLError(.badURL)
                }
                
                print("Starting network request...\(imageURL)")
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
            }
            
            return try await imageTask.value
        } catch {
            throw NetworkError.noInternet
        }
    }
}

extension NetworkManager{
    
    // Used for Unsplash View
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NetworkError.noData
        }
        return image
    }
    
    func fetchData(for categories: [String]) async throws -> [String: [Photo]]{
        let group = DispatchGroup()
        
        for category in categories {
            group.enter()
            Task {
                do {
                    if let cachedPhotos = cachedPhotosByCategory[category] {
                        print("Category is already existed")
                    } else {
                        let categoryPhotos = try await fetchData(for: category)

                        cacheSemaphore.wait()
                        cachedPhotosByCategory[category] = categoryPhotos
                        cacheSemaphore.signal()
                    }
                } catch {
                    print("Error fetching data for category \(category): \(error)")
                }
                group.leave()
            }
        }

        await group.wait()
        print(cachedPhotosByCategory)
        return cachedPhotosByCategory
    }

    private func fetchData(for category: String) async throws -> [Photo] {
        let url = "https://api.unsplash.com/photos/random/?count=20&client_id=5xhc-VPNBonw-I0xkbkmGlZjmlW0rUIDSQgK0seWXaA&query=\(category)"
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([Photo].self, from: data)
            return decodedData.map { var photo = $0; photo.category = category; return photo }
        } catch {
            print("Error decoding JSON data for category \(category): \(error)")
            throw error
        }
    }
    
    func fetchImageData(for photos: [Photo]) async throws -> [String: Data] {
        let imageDownloadGroup = DispatchGroup()
        
        for i in 0...5 {
            guard let imageUrlString = photos[i].urls["regular"],
                  let imageUrl = URL(string: imageUrlString) else {
                continue
            }
            
            // Check if image data already exists in the cache
            if let cachedImageData = imageDataDictionary[photos[i].id] {
                // Image data already exists in the cache, skip fetching
                print("Image data for photo with ID \(photos[i].id) already exists in the cache")
                continue
            }
            
            imageDownloadGroup.enter() // Enter the group before starting the download
            
            Task {
                do {
                    let imageData = try await downloadImageData(from: imageUrl)
                    if let imageData = imageData {
                        // Store the downloaded image data in the dictionary
                        cacheSemaphore.wait()
                        imageDataDictionary[photos[i].id] = imageData
                        cacheSemaphore.signal()
                    } else {
                        print("Image data is nil for photo with ID \(photos[i].id)")
                    }
                } catch {
                    print("Error downloading image with ID \(photos[i].id): \(error)")
                }
                
                imageDownloadGroup.leave() // Leave the group after downloading
            }
        }
        
        // Wait for all image downloads to complete
        await imageDownloadGroup.wait()
        print(imageDataDictionary)
        return imageDataDictionary
    }
    
     func downloadImageData(from url: URL) async throws -> Data? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    class func HitUrl(url:String) {
        let url = URL(string: url)
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil) {
                    
                }else{
                    print(error?.localizedDescription as Any)
                }
            }).resume()
        }
    }
    
    class func getRequestUsingNsurlSession(url:String,completionHanlder:@escaping (_ Result:[String : AnyObject]?, _ Error:Error?) -> Void) {
        
        let url = URL(string: url)
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil) {
                    // completionHanlder(nil, error)
                }else{
                    do{
                        
                        guard let dataInJson = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String : AnyObject] else {return}
                        completionHanlder(dataInJson, nil)
                        
                    } catch let error as NSError {
                        completionHanlder(nil, error)
                    }
                }
            }).resume()
        }
    }
}









































//func fetchCategories() async throws -> [CategoryInfo] {
//    var categoryInfos : [CategoryInfo] = []
//    let endPoint = "Data/Categories.json"
//    guard let url = URL(string: "\(BASE_URL)\(endPoint)") else {
//        throw NetworkError.invalidURL
//    }
//
//    do {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .formatted(DateFormatter())
//        var categories = try decoder.decode([Category].self, from: data)
//
//        // Iterate through categories and set default values for canDelete and isHeaderDownloaded
//        for index in 0..<categories.count {
//            // Create CategoryInfo objects
//             categoryInfos = categories.map { category in
//                return CategoryInfo(category: category,
//                                    canDelete: false,
//                                    isHeaderDownloaded: false)
//            }
//        }
//
//        return categoryInfos
//    } catch {
//        throw NetworkError.decodingError
//    }
//}
