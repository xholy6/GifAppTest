import Foundation

extension URLRequest {
    static func makeRequest(path: String, baseURL: URL = Constants.apiBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        return request
    }
}
