//
//  AnimeCellAdapter.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 27.10.2022.
//

import Foundation

/// Протокол адаптации модели данных
protocol Adaptation {
    /// Преобразует дата модель во вью модель
    ///  - Parameters:
    ///   - dataModel: дата модель
    ///   - copletion: захватывает вью модель
    func getModels(from dataModel: [AnimeData],
                    completion: @escaping ([AnimeModel]) -> Void)}

/// Адаптер модели данных
final class AnimeCellAdapter {
    private let imageDownloadService: ImageDownloadServiceProtocol
    
    init(imageDownloadService: ImageDownloadServiceProtocol) {
        self.imageDownloadService = imageDownloadService
    }
}

// MARK: - Adaptation
extension AnimeCellAdapter: Adaptation {
    
    func getModels(from dataModel: [AnimeData],
                   completion: @escaping ([AnimeModel]) -> Void) {
        var modelsArray: [AnimeModel] = []
        let dispatchGroup = DispatchGroup()
        
        dataModel.forEach {
            var model = AnimeModel(title: $0.title)
            let urlString = $0.images.jpg.imageUrl
            
            dispatchGroup.enter()
            
            imageDownloadService.getData(from: urlString) { result in
                switch result {
                case .success(let data):
                    model.imageData = data
                    modelsArray.append(model)
                    dispatchGroup.leave()
                case .failure(_):
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(modelsArray)
        }
    }
}
