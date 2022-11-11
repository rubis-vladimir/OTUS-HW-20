//
//  DataFetcherStub.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation
@testable import _19_AnimeBook

final class DataFetcherStub {
    
    private let animeError: DataFetcherError?
    private let translateError: DataFetcherError?
    private let randomAnime: RandomAnime?
    private var anime: Anime?
    
    init(animeError: DataFetcherError? = nil,
         translateError: DataFetcherError? = nil,
         randomAnime: RandomAnime? = nil,
         anime: Anime? = nil) {
        self.animeError = animeError
        self.translateError = translateError
        self.randomAnime = randomAnime
        self.anime = anime
    }
}

extension DataFetcherStub: DFM {
    
    func fetchAnime(with parameters: AnimeParameters,
                    completion: @escaping (Result<Anime, DataFetcherError>) -> Void) {
        if let animeError = animeError {
            completion(.failure(animeError))
        } else {
            
            if let limit = parameters.limit,
               let letter = parameters.letter {
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
        if let animeError = animeError {
            completion(.failure(animeError))
        } else if let randomAnime = randomAnime {
            completion(.success(randomAnime))
        }
    }
    
    func translate(with parameters: TranslateParameters,
                   completion: @escaping (Result<Translate, DataFetcherError>) -> Void) {
        if let translateError = translateError {
            completion(.failure(translateError))
        } else {
            var translate = Translate(translations: [])
            parameters.texts.forEach {
                translate.translations.append(Translate.Text(text: "Перевод слова \($0) удался"))
            }
            completion(.success(translate))
        }
    }
}

