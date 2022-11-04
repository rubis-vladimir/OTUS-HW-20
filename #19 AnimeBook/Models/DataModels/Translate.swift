//
//  Translate.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 03.11.2022.
//

import Foundation

struct Translate: Decodable {
    var translations: [Text]
    
    struct Text: Decodable {
        var text: String
    }
}

