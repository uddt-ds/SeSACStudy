//
//  ServerError.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation

enum ServerError: Int,  Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case unknownError = 503
}

extension ServerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString(String(describing: self), comment: "잘못된 요청입니다. 파라미터를 확인해주세요")
        case .unauthorized:
            return NSLocalizedString(String(describing: self), comment: "유효하지 않은 인증입니다. 토큰을 확인해주세요")
        case .forbidden:
            return NSLocalizedString(String(describing: self), comment: "요청 권한이 없습니다")
        case .notFound:
            return NSLocalizedString(String(describing: self), comment: "요청된 리소스가 존재하지 않습니다")
        case .serverError:
            return NSLocalizedString(String(describing: self), comment: "서버 에러입니다")
        case .unknownError:
            return NSLocalizedString(String(describing: self), comment: "알 수 없는 에러입니다")
        }
    }
}
