//
//  NetworkDataFetcher.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 24.10.2022.
//

import Foundation

// MARK: Протокол получения данных
protocol DataFetcherProtocol {
    
    /// Создает и направляет запрос в сеть для получения данных
    ///  - Parameters:
    ///     - requestBuilder: конструктор запроса
    ///     - responce: замыкание для захвата данных/ошибки
    func fetchData<T: Decodable>(requestBuilder: RequestBuilding,
                                 completion: @escaping (Result<T, DataFetcherError>) -> Void)
}

/// Сервис работы с сетью
final class NetworkDataFetcher {
    
    /// Запрашивает данные из сети и при получении декодирует в модель типа `T`
    private func fetchJSONData<T: Decodable>(request: URLRequest,
                                             completion: @escaping (Result<T, DataFetcherError>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            
            guard responce != nil else {
                completion(.failure(.notInternet))
                return
            }
            
            guard let data = data,
                    error == nil else {
                completion(.failure(.failedToLoad))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.failedToDecode))
            }
        }.resume()
    }
}

// MARK: - DataFetcherProtocol
extension NetworkDataFetcher: DataFetcherProtocol {
    func fetchData<T: Decodable>(requestBuilder: RequestBuilding,
                                 completion: @escaping (Result<T, DataFetcherError>) -> Void) {
        do {
            let request = try requestBuilder.asURLRequest()
            fetchJSONData(request: request,
                          completion: completion)
        } catch let error  {
            guard let dfError = error as? DataFetcherError else {
                print(error.localizedDescription)
                return }
            completion(.failure(dfError))
        }
    }
}
