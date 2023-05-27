//
//  GifResult.swift
//  GiphyApp
//
//  Created by D on 27.05.2023.
//

import Foundation

struct GifResult: Codable {
    let data: [DataResult]
}

struct DataResult: Codable {
    let images: Images
    enum CodingKeys: String, CodingKey {
        case images
    }
}

struct Images: Codable {
    let original: FixedHeight
    let downsizedSmall: DownsizedSmall
    
    enum CodingKeys: String, CodingKey {
        case original
        case downsizedSmall = "downsized_small"
    }
}

struct FixedHeight: Codable {
    let height: String
    let  width: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case height, width, url
    }
}

struct DownsizedSmall: Codable {
    let height: String
    let width: String

    enum CodingKeys: String, CodingKey {
        case height, width
    }
}
