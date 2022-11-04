//
//  Date + ConvertDate.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 26.10.2022.
//

import Foundation

extension Date {
    
    /// Преобразует дату в строку
    func convertDateToString() -> String {
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "yyyy-MM-dd"
        let stringDate = df.string(from: self)
        
        return stringDate
    }
}
