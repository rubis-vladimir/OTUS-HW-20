//
//  AnimeRequest.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 04.11.2022.
//

import Foundation

/// Запрос Аниме из сети
enum AnimeRequest {
    /// Получить Аниме по параметрам
    case getAnime(patameters: String?)
    /// Получить случайное Аниме
    case getRandomAnime
}


// MARK: - RequestBuilding
extension AnimeRequest: RequestBuilding {
    var baseUrl: String {
        "https://api.jikan.moe/v4"
    }
    
    var path: String {
        switch self {
        case .getAnime (let parameters):
            var path = "/anime"
            if let parameters = parameters {
                path += "?\(parameters)"
            }
            return path
        case .getRandomAnime:
            return "/random/anime"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAnime, .getRandomAnime:
            return .get
        }
    }
    
    var headers: HTTPHeaders? { return nil }
    var parameters: Parameters? { return nil }
}

