//
//  SearchPhotoModel.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation

struct SearchPhotoModel: Decodable {
    let total: Int
    let totalPages: Int
    let results: [SearchResults]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct SearchResults: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: SearchURL
    let likes: Int
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likes
        case user
    }
}

struct SearchURL: Decodable {
    let raw: String
    let small: String
}

struct User: Decodable {
    let name: String
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let medium: String
}
