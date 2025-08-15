//
//  NetworkManager.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let networkManager = NetworkManager()

    private init() { }

    func callRequest<T: Decodable>(api: UnsplashRouter, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = api.endPoint else { return }
        AF.request(url,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.headers)
        .responseDecodable(of: T.self) { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                completion(.failure(NetworkError.invalidURL))
                return
            }

            switch statusCode {
            case 200..<300:
                switch responseData.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(NetworkError.failDecoding))
                }
            case 400:
                completion(.failure(ServerError.badRequest))
            case 401:
                completion(.failure(ServerError.unauthorized))
            case 403:
                completion(.failure(ServerError.forbidden))
            case 404:
                completion(.failure(ServerError.notFound))
            case 500:
                completion(.failure(ServerError.serverError))
            case 503:
                completion(.failure(ServerError.serverError2))
            default:
                completion(.failure(ServerError.unknownError))
            }
        }
    }
}


