//
//  Anime.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import Foundation

struct Anime: Codable {
    var data: [AnimeData]
}

struct RandomAnime: Codable {
    var data: AnimeData
}

struct AnimeData: Codable {
    var title: String
    var images: Image
    
    struct Image: Codable {
        var jpg: JPG
        
        struct JPG: Codable {
            var imageUrl: String
            
            enum CodingKeys: String, CodingKey {
                case imageUrl = "image_url"
            }
        }
    }
}
