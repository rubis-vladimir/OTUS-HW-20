//
//  DetailAnimePresenter.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import Foundation

/// Протокол передачи UI-эвентов
protocol DetailAnimePresentation {
    var model: AnimeModel { get }
}

/// Слой презентации модуля DetailAnime
final class DetailAnimePresenter: DetailAnimePresentation {
    
    let model: AnimeModel
    
    init(model: AnimeModel) {
        self.model = model
    }
}
