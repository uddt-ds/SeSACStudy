//
//  NetworkError.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case failDecoding
    case noData
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString(String(describing: self), comment: "잘못된 URL입니다")
        case .failDecoding:
            return NSLocalizedString(String(describing: self), comment: "디코딩 에러입니다")
        case .noData:
            return NSLocalizedString(String(describing: self), comment: "데이터가 없습니다")
        }
    }
}
