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
        
        let imageDownloadService = ImageDownloadService()
        let animeCellAdapter = AnimeCellAdapter(imageDownloadService: imageDownloadService)
        let networkDataFetcher = NetworkDataFetcher()
        let dataFetcher = DataFetcherService(dataFetcher: networkDataFetcher)
        let dataFetcherProxy = DataFetcherProxy(dataFetcher: dataFetcher,
                                                animeAdapter: animeCellAdapter)
        
        let router = AnimeListRouter(navigationController: navigationController)
        let presenter = AnimeListPresenter(router: router,
                                           dataFetcher: dataFetcherProxy)
        let viewController = AnimeListViewController(presenter: presenter)
        presenter.delegate = viewController
        return viewController
    }
}
