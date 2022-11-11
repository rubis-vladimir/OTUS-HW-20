//
//  DataFetcherError.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 03.11.2022.
//

import Foundation

/// Протокол описания ошибки
protocol LocalizedError : Error {
    /// Заголовок ошибки
    var errorTitle: String? { get }
    /// Причина ошибки
    var failureReason: String? { get }
    /// Предложения по восстановлению
    var recoverySuggestion: String? { get }
}

/// Ошибки слоя получения, коддирования/декодирования данных
enum DataFetcherError: Error {
    /// Не может создать URL из строки
    case wrongUrl
    /// Отсутствует сетевое соединение
    case notInternet
    /// Загрузка данных не удалась
    case failedToLoad
    /// Данные не удалось закодировать
    case failedToEncode
    /// Данные не удалось декодировать
    case failedToDecode
    /// Не удалось перевести текст
    case failedToTranslate
}


// MARK: - LocalizedError
extension DataFetcherError: LocalizedError {
    var errorTitle: String? {
        switch self {
        case .notInternet:
            return "No Internet Connection".localize()
        case .wrongUrl, .failedToLoad, .failedToEncode, .failedToDecode, .failedToTranslate:
            return "Error".localize()
        }
    }
    
    var failureReason: String? {
        switch self {
        case .notInternet:
            return nil
        case .wrongUrl, .failedToLoad, .failedToEncode, .failedToDecode:
            return "Something went wrong".localize()
        case .failedToTranslate:
            return "Unfortunately, it was not possible to localize (translate) the data".localize()
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .notInternet:
            return "Please check your internet connection and try again".localize()
        case .failedToLoad:
            return "Please, try again".localize()
        case .wrongUrl, .failedToEncode, .failedToDecode, .failedToTranslate:
            return "Send information to support. We will deal with this problem in the near future".localize()
        }
    }
}




