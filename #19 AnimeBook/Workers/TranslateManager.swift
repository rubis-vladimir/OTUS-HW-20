//
//  TranslateManager.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 02.11.2022.
//

import Foundation

/// Протокол перевода
protocol Translatable {
    /// Переводит текст
    ///  - Parameters:
    ///   - parameters: параметры для перевода, включая сам текст
    ///   - copletion: возвращает массив переведенных строк / ошибку
    func translate(parameters: TranslateParameters,
                   completion: @escaping (Result<[String], DataFetcherError>) -> Void)
}

/// Сервис перевода текста
final class TranslateManager {
    
    private let dataFetcher: DataFetcherTranslateManagement
    
    init(dataFetcher: DataFetcherTranslateManagement = DataFetcherService()) {
        self.dataFetcher = dataFetcher
    }
}

// MARK: - Translatable
extension TranslateManager: Translatable {
    func translate(parameters: TranslateParameters,
                   completion: @escaping (Result<[String], DataFetcherError>) -> Void) {
        dataFetcher.translate(with: parameters) { result in
            switch result {
            case .success(let translate):
                let texts = translate.translations.map {$0.text}
                completion(.success(texts))
            case .failure(_ ):
                completion(.failure(.failedToTranslate))
            }
        }
    }
}
