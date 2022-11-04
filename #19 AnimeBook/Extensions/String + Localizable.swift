//
//  String + Localizable.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 01.11.2022.
//

import Foundation

extension String {
    
    /// Локализация
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
