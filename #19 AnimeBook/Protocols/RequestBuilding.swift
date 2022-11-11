//
//  RequestBuilding.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 04.11.2022.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = Codable

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

/// Протокол строителя интернет-запроса
protocol RequestBuilding {
    /// Основной url-адрес
    var baseUrl: String { get }
    /// Дополнительный путь
    var path: String { get }
    /// URL параметры
    var queryItems: [URLQueryItem]? { get }
    /// Метод HTTP
    var method: HTTPMethod { get }
    /// Заголовки запроса
    var headers: HTTPHeaders? { get }
    /// Параметры запроса
    var parameters: Parameters? { get }
    
    /// Создает запрос (может выбросить ошибку)
    func asURLRequest() throws -> URLRequest
}

/// Дефолтная реализация метода
extension RequestBuilding {
    func asURLRequest() throws -> URLRequest {
        guard let url = url else { throw DataFetcherError.wrongUrl }
        print(url)
        var request = URLRequest (url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach {
                request.setValue($1, forHTTPHeaderField: $0)
            }
        }
        if let parameters = parameters {
            do {
                request.httpBody = try JSONEncoder().encode(parameters)
            } catch {
                throw ( DataFetcherError.failedToEncode )
            }
        }
        return request
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
