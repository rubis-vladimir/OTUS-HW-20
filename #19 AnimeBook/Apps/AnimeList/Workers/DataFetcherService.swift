//
//  DataFetcherService.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 24.10.2022.
//

import Foundation

/// Протокол работы с запросами Аниме
protocol DataFetcherAnimeManagement {
    /// Запрос аниме
    ///  - Parameters:
    ///   - requestBuilder: конфигуратор запроса
    ///   - completion: захватывает модель Аниме / ошибку
    func fetchAnime(with parameters: ParametersAnimeRequest,
                    completion: @escaping (Result<Anime, DataFetcherError>) -> Void)
    
    func fetchRandomAnime(completion: @escaping (Result<RandomAnime, DataFetcherError>) -> Void)
}

/// Протокол работы с запросами на перевод
protocol DataFetcherTranslateManagement {
    /// Запрос на перевод текста
    func translate(with parameters: TranslateParameters,
                   completion: @escaping (Result<Translate, DataFetcherError>) -> Void)
}

// MARK: Сервис работы с запросами
final class DataFetcherService {
    
    private let dataFetcher: DataFetcherProtocol
    
    init(dataFetcher: DataFetcherProtocol = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    /// Преобразует словарь параметров в строку
    private func convertForRequest(_ parameters: ParametersAnimeRequest) -> String {
        return parameters.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}

// MARK: - DataFetcherServiceManagement
extension DataFetcherService: DataFetcherAnimeManagement {
    func fetchAnime(with parameters: ParametersAnimeRequest,
                   completion: @escaping (Result<Anime, DataFetcherError>) -> Void) {
        let stringParameters = convertForRequest(parameters)
        
        dataFetcher.fetchData(requestBuilder: AnimeRequest.getAnime(patameters: stringParameters),
                              completion: completion)
    }
    
    func fetchRandomAnime(completion: @escaping (Result<RandomAnime, DataFetcherError>) -> Void) {
        dataFetcher.fetchData(requestBuilder: AnimeRequest.getRandomAnime, completion: completion)
    }
}

// MARK: - DataFetcherTranslateManagement
extension DataFetcherService: DataFetcherTranslateManagement {
    func translate(with parameters: TranslateParameters,
                   completion: @escaping (Result<Translate, DataFetcherError>) -> Void) {
        dataFetcher.fetchData(requestBuilder: LanguageRequest.translate(patameters: parameters),
                              completion: completion)
    }
}
