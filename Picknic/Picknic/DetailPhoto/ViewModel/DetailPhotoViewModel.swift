//
//  DetailPhotoViewModel.swift
//  Picknic
//
//  Created by Lee on 8/16/25.
//

import Foundation

// TODO: 데이터를 하나의 흐름에서 관리하는 방식이 아니라 흐름이 끊기는 방식이라서 리팩토링이 필요함

final class DetailPhotoViewModel {

    var photoData: PhotoResult

    var input: Input
    var output: Output

    private let networkManager = NetworkManager.shared

    struct Input {
        var photoResultData: Observable<PhotoResult?> = Observable(value: nil)
    }

    struct Output {
        var statisticsData: Observable<Statistics?> = Observable(value: nil)
    }

    init(photoData: PhotoResult) {
        self.photoData = photoData
        input = Input()
        output = Output()

        loadData()
        fetch()
    }

    func fetch() {

        let photoId = photoData.id

        networkManager.callRequest(api: .statistics(imageID: photoId), type: Statistics.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
                self.output.statisticsData.value = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func loadData() {
        input.photoResultData.value = photoData
    }
}
