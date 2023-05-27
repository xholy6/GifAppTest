//
//  GifListService.swift
//  GifApp
//
//  Created by D on 27.05.2023.
//

import Foundation

final class GifListService {
    static let shared = GifListService()
    
    private init() {}
    
    private (set) var gifs: [String] = []
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    static let didChangeNotification = Notification.Name(rawValue: "GisListServiceDidChange")

    func makeAPIcall(with keyword: String, number gifs: Int, completion: @escaping (Bool) -> Void ) {
        task = urlSession.dataTask(with: gifFindRequest(
            keyword: keyword,
            gifs: gifs)
        ) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data,
                let gifurl = try? JSONDecoder().decode(GifResult.self, from: data) {
                
                var urls: [String] = []
                DispatchQueue.main.async {
                    for i in gifurl.data {
                        let image = i.images
                        urls.append(image.original.url)
                    }
                    print("xxxxxxxxx\(urls)")
                    self.gifs = urls
                    NotificationCenter.default.post(
                        name: GifListService.didChangeNotification,
                        object: self,
                        userInfo: ["gifs" : self.gifs])
                    completion(true)
                }
                
            } else {
                completion(false)
                assertionFailure("\(error)")
            }
        }
         task?.resume()
    }
    
    func gifFindRequest(keyword: String, gifs: Int) -> URLRequest {
        URLRequest.makeRequest(path: "search?api_key=\(Constants.apiKey)&q=\(keyword)&limit=\(gifs)&offset=0&rating=g&lang=en")
    }
    
}
