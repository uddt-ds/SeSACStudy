//
//  NetworkManager.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation
import Alamofire

final class NetworkManager {

    static let shared = NetworkManager()

    private init() { }

    func callRequest<T: Decodable>(api: UnsplashRouter, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = api.endPoint else { return }
        AF.request(url,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { responseData in

            let statusCode = responseData.response?.statusCode ?? 503

            switch statusCode {
            case 200..<300:
                switch responseData.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(NetworkError.failDecoding))
                }

            case 400..<504:
                let error = ServerError(rawValue: statusCode)
                print(error?.errorDescription ?? "알 수 없는 에러입니다")

            default:
                print(ServerError.unknownError.errorDescription ?? "알 수 없는 에러입니다")
            }
        }
    }
}


