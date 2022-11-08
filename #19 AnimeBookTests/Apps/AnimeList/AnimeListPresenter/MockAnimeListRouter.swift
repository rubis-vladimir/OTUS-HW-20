//
//  MockAnimeListRouter.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 07.11.2022.
//

import UIKit
@testable import _19_AnimeBook

final class MockAnimeListRouter: AnimeListRouting {
    var navigationController: UINavigationController?

    private var animeModel: AnimeModel?
    
    func showDetail(anime: AnimeModel) {
        self.animeModel = anime
    }
    
    func retrieve() -> String? {
        animeModel?.title
    }
}
