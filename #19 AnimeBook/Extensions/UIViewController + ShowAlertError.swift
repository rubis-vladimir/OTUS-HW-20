//
//  UIViewController + ShowAlertError.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 04.11.2022.
//

import UIKit

extension UIViewController {
    
    /// Показывает пользователю информацию об ошибке
    func showAlertError(_ rError: RecoverableError) {
        guard let error = rError.error as? DataFetcherError else { return }
        
        let errorMessage = [error.failureReason, error.recoverySuggestion]
            .compactMap({ $0 })
            .joined(separator: ". ")
        
        let alert = UIAlertController(
            title: error.errorTitle,
            message: errorMessage,
            preferredStyle: .alert)
        
        rError.recoveryOptions.forEach {
            let action = createAlertAction(with: $0)
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
    
    /// Создает действие в зависимости от опции
    private func createAlertAction(with: RecoveryOptions) -> UIAlertAction {
        switch with {
        case let .tryAgain(action: action):
            return UIAlertAction(title: "Try again".localize(),
                                 style: .default) { _ in
                action()
            }
        case .cancel:
            return UIAlertAction(title: "OK", style: .cancel)
        }
    }
}
