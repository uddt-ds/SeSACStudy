//
//  TopicViewModel.swift
//  Picknic
//
//  Created by Lee on 8/16/25.
//

import Foundation

final class TopicViewModel {

    let networkManager = NetworkManager.shared

    var input: Input
    var output: Output

    struct Input {
        var viewDidLoadTrigger: Observable<Void?> = Observable(value: nil)
    }

    struct Output {
        var firstTopicData: Observable<[PhotoResult]> = Observable(value: [])
        var secondTopicData: Observable<[PhotoResult]> = Observable(value: [])
        var thirdTopicData: Observable<[PhotoResult]> = Observable(value: [])
    }

    init() {
        input = Input()
        output = Output()

        input.viewDidLoadTrigger.lazyBind { [weak self] _ in
            guard let self else { return }
            self.fetchFirstTopicData()
            self.fetchSecondTopicData()
            self.fetchThirdTopicData()
        }
    }

    func fetchFirstTopicData() {
        networkManager.callRequest(api: .topic(topicID: TopicID.golden_hour.rawValue, page: 1, perpage: 10), type: [PhotoResult].self) { [weak self] responseData in
            guard let self else { return }
            switch responseData {
            case .success(let data):
                output.firstTopicData.value = data
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchSecondTopicData() {
        networkManager.callRequest(api: .topic(topicID: TopicID.business_work.rawValue, page: 1, perpage: 10), type: [PhotoResult].self) { [weak self] responseData in
            guard let self else { return }
            switch responseData {
            case .success(let data):
                output.secondTopicData.value = data
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchThirdTopicData() {
        networkManager.callRequest(api: .topic(topicID: TopicID.architecture_interior.rawValue, page: 1, perpage: 10), type: [PhotoResult].self) { [weak self] responseData in
            guard let self else { return }
            switch responseData {
            case .success(let data):
                output.thirdTopicData.value = data
            case .failure(let error):
                print(error)
            }
        }
    }
}
