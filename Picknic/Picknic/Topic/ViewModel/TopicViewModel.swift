//
//  TopicViewModel.swift
//  Picknic
//
//  Created by Lee on 8/16/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TopicViewModel {

    let disposeBag = DisposeBag()

    private let networkManager = NetworkManager.shared

    struct Input {
        var viewDidLoadTrigger = BehaviorSubject(value: ())
//        var totalLoadTrigger: PublishSubject<Void>
    }

    struct Output {
        var firstTopicData: BehaviorRelay<[PhotoResult]>
        var secondTopicData: BehaviorRelay<[PhotoResult]>
        var thirdTopicData: BehaviorRelay<[PhotoResult]>
    }


    func transform(input: Input) -> Output {

        let firstTopicData: BehaviorRelay<[PhotoResult]> = BehaviorRelay(value: [])
        let secondTopicData: BehaviorRelay<[PhotoResult]> = BehaviorRelay(value: [])
        let thirdTopicData: BehaviorRelay<[PhotoResult]> = BehaviorRelay(value: [])

        input.viewDidLoadTrigger
            .flatMap { _ in
                return CustomObservable.getPicDataWithResult(api: .topic(topicQuery: .init(topicID: TopicID.golden_hour.rawValue, page: 1, perpage: 20)))
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    firstTopicData.accept(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        input.viewDidLoadTrigger
            .flatMap { _ in
                return CustomObservable.getPicDataWithResult(api: .topic(topicQuery: .init(topicID: TopicID.business_work.rawValue, page: 1, perpage: 20)))
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    secondTopicData.accept(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        input.viewDidLoadTrigger
            .flatMap { _ in
                return CustomObservable.getPicDataWithResult(api: .topic(topicQuery: .init(topicID: TopicID.architecture_interior.rawValue, page: 1, perpage: 20)))
            }
            .bind(with: self) { owner, responseData in
                switch responseData {
                case .success(let data):
                    thirdTopicData.accept(data)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        return Output(firstTopicData: firstTopicData, secondTopicData: secondTopicData, thirdTopicData: thirdTopicData)

    }

//    private func refreshTotalData() {
//        let dispatchGroup = DispatchGroup()
//
//        dispatchGroup.enter()
//        networkManager.callRequest(api: .topic(topicQuery: .init(topicID: TopicID.golden_hour.rawValue, page: 1, perpage: 10)), type: [PhotoResult].self) { [weak self] responseData in
//            guard let self else { return }
//            switch responseData {
//            case .success(let data):
//                self.output.totalData.value.first = data
//            case .failure(let error):
//                print(error)
//            }
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        networkManager.callRequest(api: .topic(topicQuery: .init(topicID: TopicID.business_work.rawValue, page: 1, perpage: 10)), type: [PhotoResult].self) { [weak self] responseData in
//            guard let self else { return }
//            switch responseData {
//            case .success(let data):
//                self.output.totalData.value.second = data
//            case .failure(let error):
//                print(error)
//            }
//            dispatchGroup.leave()
//        }
//        dispatchGroup.enter()
//        networkManager.callRequest(api: .topic(topicQuery: .init(topicID: TopicID.architecture_interior.rawValue, page: 1, perpage: 10)), type: [PhotoResult].self) { [weak self] responseData in
//            guard let self else { return }
//            switch responseData {
//            case .success(let data):
//                self.output.totalData.value.third = data
//            case .failure(let error):
//                print(error)
//            }
//            dispatchGroup.leave()
//        }
//        
//        dispatchGroup.notify(queue: .main) { [weak self] in
//            guard let self else { return }
//            self.input.totalLoadTrigger.value = ()
//        }
//    }
}
