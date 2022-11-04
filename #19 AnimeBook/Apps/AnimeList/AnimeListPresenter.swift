//
//  AnimeListPresenter.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import Foundation

typealias ParametersAnimeRequest = [AnimeParameters: String]

/// Виды запросов аниме
enum GetAnimeType {
    /// Запрос одного случайного аниме
    case random
    /// Запрос аниме по параметрам
    case search(with: ParametersAnimeRequest)
}

/// Протокол передачи UI-ивентов модуля AnimeList
protocol AnimeListPresentation {
    /// Массив загруженных моделей аниме
    var animeModels: [AnimeModel] { get }
    /// Запрос Аниме по типу
    func getAnime(with type: GetAnimeType)
    /// Произвели нажатие на item
    func tapAnime(_ anime: AnimeModel)
}

/// Слой презентации модуля AnimeList
final class AnimeListPresenter {
    private let router: AnimeListRouting
    private let dataFetcher: DataFetcherProxyProtocol
    
    weak var delegate: AnimeListPresenterDelegate?
    
    private(set) var animeModels: [AnimeModel] = [] {
        didSet {
            delegate?.updateUI()
        }
    }
    
    init(router: AnimeListRouting,
         dataFetcher: DataFetcherProxyProtocol = DataFetcherProxy()) {
        self.router = router
        self.dataFetcher = dataFetcher
    }
}

// MARK: - AnimeListPresentation
extension AnimeListPresenter: AnimeListPresentation {
    
    func getAnime(with type: GetAnimeType) {
        dataFetcher.fetchAnime(with: type) { [weak self] result in
            switch result {
            case .success(let models):
                self?.animeModels = models
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    
    func tapAnime(_ anime: AnimeModel) {
        router.showDetail(anime: anime)
    }
}
