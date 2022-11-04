//
//  Parameters.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 03.11.2022.
//

import Foundation

struct TranslateParameters: Codable {
    var folderId: String
    var texts: [String]
    var sourceLanguageCode: String
    var targetLanguageCode: String
    
    enum CodingKeys: String, CodingKey {
        case folderId = "folder id"
        case texts = "texts"
        case sourceLanguageCode = "sourceLanguageCode"
        case targetLanguageCode = "targetLanguageCode"
    }
}

enum AnimeParameters: String, Codable {
    case limit
    case letter
    case startDate
    case endDate
}
