//
//  ImageDownloadService.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 24.10.2022.
//

import Foundation

/// Протокол загрузки изображений из сети
protocol ImageDownloadServiceProtocol {
    
    /// Получает данные изображения
    ///  - Parameters:
    ///   - from: urlString
    ///   - responce: захватывает данные / ошибку
    func getData(from: String,
                 responce: @escaping (Result<Data, DataFetcherError>) -> Void)
}

// MARK: - ImageDownloadServiceProtocol
final class ImageDownloadService: ImageDownloadServiceProtocol {
    
    func getData(from: String,
                 responce: @escaping (Result<Data, DataFetcherError>) -> Void) {
        guard let url = URL(string: from) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data, error == nil else {
                responce(.failure(.failedToLoad))
                return
            }
            responce(.success(data))
        }.resume()
    }
}
