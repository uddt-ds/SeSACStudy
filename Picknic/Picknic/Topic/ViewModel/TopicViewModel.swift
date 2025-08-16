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
        var totalLoadTrigger: Observable<Void?> = Observable(value: nil)
    }

    struct Output {
        var firstTopicData: Observable<[PhotoResult]> = Observable(value: [])
        var secondTopicData: Observable<[PhotoResult]> = Observable(value: [])
        var thirdTopicData: Observable<[PhotoResult]> = Observable(value: [])
        var totalData: Observable<(first: [PhotoResult], second: [PhotoResult], third: [PhotoResult])> = Observable(value: ([], [], []))
    }

    init() {
        input = Input()
        output = Output()

        input.viewDidLoadTrigger.lazyBind { [weak self] _ in
            guard let self else { return }
            self.refreshTotalData()
        }

        input.totalLoadTrigger.lazyBind { [weak self] _ in
            guard let self else { return }
            self.output.firstTopicData.value = self.output.totalData.value.first
            self.output.secondTopicData.value = self.output.totalData.value.second
            self.output.thirdTopicData.value = self.output.totalData.value.third
        }
    }

    private func refreshTotalData() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        networkManager.callRequest(api: .topic(topicID: TopicID.golden_hour.rawValue, page: 1, perpage: 10), type: [PhotoResult].self) { [weak self] responseData in
            guard let self else { return }
            switch responseData {
            case .success(let data):
                self.output.totalData.value.first = data
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        networkManager.callRequest(api: .topic(topicID: TopicID.business_work.rawValue, page: 1, perpage: 10), type: [PhotoResult].self) { [weak self] responseData in
            guard let self else { return }
            switch responseData {
            case .success(let data):
                self.output.totalData.value.second = data
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        networkManager.callRequest(api: .topic(topicID: TopicID.architecture_interior.rawValue, page: 1, perpage: 10), type: [PhotoResult].self) { [weak self] responseData in
            guard let self else { return }
            switch responseData {
            case .success(let data):
                self.output.totalData.value.third = data
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.input.totalLoadTrigger.value = ()
        }
    }
}
