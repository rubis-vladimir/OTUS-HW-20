//
//  UIViewController + ShowAlertError.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 04.11.2022.
//

import UIKit

extension UIViewController {

    /// Показывает пользователю информацию об ошибке
    func showAlertError(_ error: Error) {
        guard let error = error as? DataFetcherError else { return }
        
        let errorMessage = [error.failureReason, error.recoverySuggestion]
            .compactMap({ $0 })
            .joined(separator: ". ")
        
        let alert = UIAlertController(
            title: error.errorTitle,
            message: errorMessage,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

