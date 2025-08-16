//
//  SearchPhotoModel.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation

struct SearchPhoto: Decodable {
    var total: Int
    var totalPages: Int
    var results: [PhotoResult]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
