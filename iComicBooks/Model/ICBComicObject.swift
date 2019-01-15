//
//  ICBComicObject.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on on 02/12/2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

/*
    ICBComic model with an initializer that accepts a JSON object.
*/

/** ICBComic object */
struct ICBComic {
    let month: String
    let num: Int
    let link: String?
    let year: String
    let news: String?
    let safeTitle: String
    let transcript: String?
    let alt: String
    let img: String
    let title: String
    let day: String
    
    enum CodingKeys: String, CodingKey {
        case month
        case num
        case link
        case year
        case news
        case safeTitle = "safe_title"
        case transcript
        case alt
        case img
        case title
        case day
    }
}

/** A type representing an error value that can be missing */
enum SerializationError: Error {
    case missing(String)
}

/** JSON initializer for ICBComic object that throws an error of that type whenever deserialization fails */
extension ICBComic: Decodable {    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        month = try values.decode(String.self, forKey: .month)
        num = try values.decode(Int.self, forKey: .num)
        link = try values.decode(String.self, forKey: .link)
        year = try values.decode(String.self, forKey: .year)
        news = try values.decode(String.self, forKey: .news)
        safeTitle = try values.decode(String.self, forKey: .safeTitle)
        transcript = try values.decode(String.self, forKey: .transcript)
        alt = try values.decode(String.self, forKey: .alt)
        img = try values.decode(String.self, forKey: .img)
        title = try values.decode(String.self, forKey: .title)
        day = try values.decode(String.self, forKey: .day)
    }
}
