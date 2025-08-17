//
//  BaseUserDefaults.swift
//  Picknic
//
//  Created by Lee on 8/17/25.
//

import Foundation

enum PicknicDBKey: String {
    case nickname
    case mbti
    case likesList
}

@propertyWrapper
struct BaseUserDefaults<T: Codable> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults = UserDefaults.standard

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            if let data = storage.data(forKey: key) {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return decodedData
                } catch {
                    print(UserDefaultsError.failDecoding)
                }
                print(UserDefaultsError.invalidKey)
            }
            return defaultValue
        }
        set {
            do {
                let encodedData = try JSONEncoder().encode(newValue)
                storage.set(encodedData, forKey: key)
            } catch {
                print(UserDefaultsError.failEncoding)
            }
        }
    }
}


extension BaseUserDefaults {
    enum UserDefaultsError: String, Error {
        case invalidKey = "유효하지 않은 키입니다"
        case failDecoding = "정보를 디코딩하는데 실패했습니다"
        case failEncoding = "정보를 인코딩하는데 실패했습니다"
    }

}
