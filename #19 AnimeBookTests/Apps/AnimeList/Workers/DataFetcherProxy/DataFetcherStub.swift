//
//  DataFetcherStub.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation
@testable import _19_AnimeBook

final class DataFetcherStub: DataFetcherAnimeManagement {
    
    private var retrieveError: DataFetcherError?
    private var randomAnime: RandomAnime?
    private var anime: Anime?
    
    init(retrieveError: DataFetcherError? = nil,
         randomAnime: RandomAnime? = nil,
         anime: Anime? = nil) {
        self.retrieveError = retrieveError
        self.randomAnime = randomAnime
        self.anime = anime
    }
    
    func fetchAnime(with parameters: ParametersAnimeRequest,
                    completion: @escaping (Result<Anime, DataFetcherError>) -> Void) {
        if let retrieveError = retrieveError {
            completion(.failure(retrieveError))
        } else {
            
            if let limitString = parameters[.limit],
               let limit = Int(limitString),
               let letter = parameters[.letter] {
                (0..<limit).forEach { _ in
                    let data = AnimeData(title: "\(letter)Bar",
                                         images: AnimeData.Image(jpg: AnimeData.Image.JPG(imageUrl: "/baz")))
                    self.anime?.data.append(data)
                }
            }
            guard let anime = anime else { return }
            completion(.success(anime))
        }
    }
    
    func fetchRandomAnime(completion: @escaping (Result<RandomAnime, DataFetcherError>) -> Void) {
        if let retrieveError = retrieveError {
            completion(.failure(retrieveError))
        } else if let randomAnime = randomAnime {
            completion(.success(randomAnime))
        }
    }
}
