//
//  User.swift
//  Picknic
//
//  Created by Lee on 8/17/25.
//

import Foundation

struct UserModel: Codable {
    @BaseUserDefaults(key: PicknicDBKey.nickname.rawValue, defaultValue: "")
    static var nickname: String

    @BaseUserDefaults(key: PicknicDBKey.mbti.rawValue, defaultValue:  "")
    static var  mbti: String

    @BaseUserDefaults(key: PicknicDBKey.likesList.rawValue, defaultValue: [])
    static var likesList: Set<String>
}
