//
//  CustomObservable.swift
//  Picknic
//
//  Created by Lee on 8/29/25.
//

import Foundation
import RxSwift
import Alamofire

final class CustomObservable {
    static func getPicDataWithResult(api: UnsplashRouter) -> Observable<Result<[PhotoResult], NetworkError>> {
        return Observable<Result<[PhotoResult], NetworkError>>.create { value in
            if let url = api.endPoint {
                AF.request(url,
                           method: api.method,
                           parameters: api.parameter,
                           encoding: URLEncoding(destination: .queryString),
                           headers: api.headers)
                .validate(statusCode: 200..<300)
                    .responseDecodable(of: [PhotoResult].self) { responseData in
                        switch responseData.result {
                        case .success(let data):
                            value.onNext(.success(data))
                            value.onCompleted()
                        case .failure(let error):
                            value.onNext(.failure(.invalidURL))
                            value.onCompleted()
                        }
                    }
            }
            return Disposables.create()
        }
    }
}
