//
//  TranslateManagerStub.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation
@testable import _19_AnimeBook

final class TranslateManagerStub: Translatable {
    
    private var retrieveError: DataFetcherError?
    
    init(retrieveError: DataFetcherError? = nil) {
        self.retrieveError = retrieveError
    }
    
    func translate(parameters: TranslateParameters,
                   completion: @escaping (Result<[String], DataFetcherError>) -> Void) {
        if let retrieveError = retrieveError {
            completion(.failure(retrieveError))
        } else {
            var translate: [String] = []
            parameters.texts.forEach {
                translate.append("Перевод слова \($0) удался")
            }
            completion(.success(translate))
        }
    }
}
