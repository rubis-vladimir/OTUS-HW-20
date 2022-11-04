//
//  AnimeListRouter.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import UIKit

/// Протокол навигации модуля AnimeList
protocol AnimeListRouting: Routing {
    /// Переход на экран детальной информации
    ///  - Parameter anime: модель аниме
    func showDetail(anime: AnimeModel)
}

/// Слой навигации модуля AnimeList
final class AnimeListRouter {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - AnimeListRouting
extension AnimeListRouter: AnimeListRouting {
    func showDetail(anime: AnimeModel) {
        guard let navigationController = navigationController else { return }
        let presenter = DetailAnimePresenter(model: anime)
        let vc = DetailAnimeViewController(presenter: presenter)
        navigationController.pushViewController(vc, animated: true)
    }
}
