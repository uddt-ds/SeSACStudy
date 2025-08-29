//
//  SearchCustomObservable.swift
//  Picknic
//
//  Created by Lee on 8/29/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class SearchCustomObservable {
    static func getSearchData(api: UnsplashRouter) -> Single<Result<SearchPhoto, NetworkError>> {
        return Single<Result<SearchPhoto, NetworkError>>.create { value in
            if let url = api.endPoint {
                AF.request(url,
                           parameters: api.parameter,
                           encoding: URLEncoding(destination: .queryString),
                           headers: api.headers
                )
                .responseDecodable(of: SearchPhoto.self) { responseData in
                    switch responseData.result {
                    case .success(let data):
                        value(.success(.success(data)))
                    case .failure(let error):
                        value(.success(.failure(.invalidURL)))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
