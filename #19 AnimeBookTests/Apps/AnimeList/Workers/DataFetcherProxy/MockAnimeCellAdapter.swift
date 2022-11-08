//
//  MockAnimeCellAdapter.swift
//  #19 AnimeBookTests
//
//  Created by Владимир Рубис on 08.11.2022.
//

import Foundation
@testable import _19_AnimeBook

final class MockAnimeCellAdapter: Adaptation {
    
    func getModels(from dataModel: [AnimeData],
                   completion: @escaping ([AnimeModel]) -> Void) {
        var animeModels: [AnimeModel] = []
        dataModel.forEach {
            animeModels.append(AnimeModel(title: $0.title))
        }
        completion(animeModels)
    }
}
