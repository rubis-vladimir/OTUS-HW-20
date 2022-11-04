//
//  Request.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 25.10.2022.
//

import Foundation

enum LanguageRequest<T: Codable> {
    /// Перевести текст
    case translate(patameters: T)
}

// MARK: - RequestBuilding
extension LanguageRequest: RequestBuilding {
    var baseUrl: String {
        "https://translate.api.cloud.yandex.net"
    }
    
    var path: String {
        switch self {
        case .translate:
            return "/translate/v2/translate"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .translate:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .translate:
            return [
                "Authorization": "Api-Key \(APIKeys.translateAPIKey.rawValue)",
                "Content-Type": "text/plain"
            ]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .translate(parameters):
            return parameters
        }
    }
}


