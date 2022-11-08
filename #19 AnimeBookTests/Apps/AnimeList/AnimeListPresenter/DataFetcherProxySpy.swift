//
//  DataFetcherProxySpy.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 07.11.2022.
//

import Foundation
@testable import _19_AnimeBook

final class DataFetcherProxySpy: DataFetcherProxyProtocol {
    
    private var animeModels: [AnimeModel] = []
    private var error: DataFetcherError?

    convenience init(animeModels: [AnimeModel] = [] ,
                     error: DataFetcherError? = nil) {
        self.init()
        self.animeModels.append(contentsOf: animeModels)
        self.error = error
    }
    
    func fetchAnime(with type: GetAnimeType,
                    completion: @escaping (Result<[AnimeModel], DataFetcherError>) -> Void) {
        switch type {
        case .random:
            if !animeModels.isEmpty {
                completion(.success(animeModels))
            } else if let error = error {
                completion(.failure(error))
            }
            
        case let .search(with: with):
            if !with.isEmpty {
                with.forEach { key, value in
                    guard key == .letter else { return }
                    let animeModel = AnimeModel(title: "\(value) Bar")
                    animeModels.append(animeModel)
                    completion(.success(animeModels))
                }
            } else {
                if !animeModels.isEmpty {
                    completion(.success(animeModels))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
}
