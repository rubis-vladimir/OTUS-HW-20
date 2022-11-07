//
//  DataFetcherProxy.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 02.11.2022.
//

import Foundation

/// Протокол управления заместителем
protocol DataFetcherProxyProtocol {
    func fetchAnime(with type: GetAnimeType,
                    completion: @escaping (Result<[AnimeModel], DataFetcherError>) -> Void)
}

/// Заместитель DataFetcher
final class DataFetcherProxy {
    
    private let translateManager: Translatable
    private let dataFetcher: DataFetcherAnimeManagement
    private let animeAdapter: Adaptation
    
    init(translateManager: Translatable = TranslateManager(),
         dataFetcher: DataFetcherAnimeManagement = DataFetcherService(),
         animeAdapter: Adaptation = AnimeCellAdapter()) {
        self.translateManager = translateManager
        self.dataFetcher = dataFetcher
        self.animeAdapter = animeAdapter
    }
}

// MARK: - DataFetcherProxyProtocol
extension DataFetcherProxy: DataFetcherProxyProtocol {
    func fetchAnime(with type: GetAnimeType,
                    completion: @escaping (Result<[AnimeModel], DataFetcherError>) -> Void) {
        
        switch type {
        case .random:
            dataFetcher.fetchRandomAnime { [weak self] result in
                switch result {
                case .success(let anime):
                    self?.convertAndTranslate(data: [anime.data],
                                              completion: completion)
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case let .search(with: parameters):
            dataFetcher.fetchAnime(with: parameters) { [weak self] result in
                switch result {
                case .success(let anime):
                    self?.convertAndTranslate(data: anime.data,
                                              completion: completion)
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Private func
extension DataFetcherProxy {
    /// Конвертирует одну модель данных в другую и решает нужно ли переводить текст
    private func convertAndTranslate(data: [AnimeData],
                                     completion: @escaping (Result<[AnimeModel], DataFetcherError>) -> Void) {
        animeAdapter.getModels(from: data) { [weak self] models in
            
            if self?.currentAppleLanguage() == "Base" {
                completion(.success(models))
            } else {
                let texts = models.map { $0.title }
                let trParams = TranslateParameters(folderId: APIKeys.serviceId.rawValue,
                                                   texts: texts,
                                                   sourceLanguageCode: Localization.en.rawValue,
                                                   targetLanguageCode: self?.currentAppleLanguage() ?? Localization.ru.rawValue)
                
                self?.translateManager.translate(parameters: trParams,
                                                 completion: { result in
                    switch result {
                    case .success(let texts):
                        guard let models = self?.createNewModels(with: texts,
                                                                 oldModels: models) else { return }
                        completion(.success(models))
                    case .failure(let error):
                        completion(.success(models))
                        completion(.failure(error))
                    }
                })
            }
        }
    }
    
    /// Пересоздает модель с переведенным текстом
    private func createNewModels(with texts: [String],
                                 oldModels: [AnimeModel]) -> [AnimeModel] {
        var newModels: [AnimeModel] = []
        (0...oldModels.count-1).forEach {
            let model = AnimeModel(title: texts[$0],
                                   imageData: oldModels[$0].imageData)
            newModels.append(model)
        }
        return newModels
    }
    
    /// Проверяет установленный на устройстве язык
    private func currentAppleLanguage() -> String {
        let appleLanguageKey = "AppleLanguages"
        let userdef = UserDefaults.standard
        var currentWithoutLocale = "Base"
        if let langArray = userdef.object(forKey: appleLanguageKey) as? [String] {
            if var current = langArray.first {
                if let range = current.range(of: "-") {
                    current = String(current[..<range.lowerBound])
                }
                
                currentWithoutLocale = current
            }
        }
        return currentWithoutLocale
    }
}
