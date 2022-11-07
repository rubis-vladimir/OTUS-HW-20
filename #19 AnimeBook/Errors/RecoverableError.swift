//
//  RecoverableError.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 07.11.2022.
//

import Foundation

/// Варианты восстановления ошибок
enum RecoveryOptions {
    case tryAgain(action: (() -> Void))
    case cancel
}

/// Восстанавливаемая ошибка
struct RecoverableError {
    let error: Error
    let recoveryOptions: [RecoveryOptions]
}
