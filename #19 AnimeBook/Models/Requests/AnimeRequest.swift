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
    case getAnime(patameters: AnimeParameters)
    /// Получить случайное Аниме
    case getRandomAnime
}


// MARK: - RequestBuilding
extension AnimeRequest: RequestBuilding {
    var baseUrl: String {
        "api.jikan.moe"
    }
    
    var path: String {
        switch self {
        case .getAnime:
            return "/v4/anime"
        case .getRandomAnime:
            return "/v4/random/anime"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        
        switch self {
        case .getAnime(let parameters):
            return [
                URLQueryItem(name: "letter", value: parameters.letter),
                URLQueryItem(name: "limit", value: String(parameters.limit ?? 0)),
                URLQueryItem(name: "startDate", value: parameters.startDate?.convertDateToString()),
                URLQueryItem(name: "endDate", value: parameters.endDate?.convertDateToString())
            ]
        case .getRandomAnime:
            return nil
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

