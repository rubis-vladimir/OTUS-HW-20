//
//  AnimeListAssembly.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import UIKit

/// Компоновщик модуля AnimeList
final class AnimeListAssembly {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Assemblying
extension AnimeListAssembly: Assemblying {
    func assembly() -> UIViewController {
        let router = AnimeListRouter(navigationController: navigationController)
        let presenter = AnimeListPresenter(router: router)
        let viewController = AnimeListViewController(presenter: presenter)
        presenter.delegate = viewController
        return viewController
    }
}
