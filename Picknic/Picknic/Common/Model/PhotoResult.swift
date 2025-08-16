//
//  PhotoResultModel.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: PhotoURL
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

extension PhotoResult {
    var formatterLikes: String {
        return NumberFormatManager.shared.getDemicalNum(likes)
    }
}

struct PhotoURL: Decodable {
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
