//
//  SearchPhotoViewModel.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation
import Alamofire

/*
 TODO: 데이터 이상 없는지 디버깅 필요
 insomnia에서 받아오는 raw 데이터와 swift에서 받아오는 raw 데이터가 차이가 있을 수 있는지 확인 필요
 */

final class SearchPhotoViewModel {

    private let networkManager = NetworkManager.shared

    var input: Input
    var middle: Middle
    var output: Output

    var isInfiniteScroll = false

    struct Input {
        var searchKeyword: Observable<String?> = Observable(value: nil)
        var sortType: Observable<String> = Observable(value: OrderBy.relevant.rawValue)
        var scrollDidChangeTrigger: Observable<Void?> = Observable(value: nil)
        var colorType: Observable<String?> = Observable(value: nil)
    }

    struct Middle {
        var page: Observable<Int> = Observable(value: 1)
    }

    struct Output {
        var invalidInput: Observable<String> = Observable(value: "")
        var searchResult: Observable<SearchPhoto?> = Observable(value: nil)
        var scrollGoToTop: Observable<Void?> = Observable(value: nil)
    }

    init() {
        input = Input()
        middle = Middle()
        output = Output()

        input.searchKeyword.bind { [weak self] text in
            guard let self else { return }
            let page = self.middle.page.value
            
            if page != 1 && !isInfiniteScroll {
                self.middle.page.value = 1
                self.output.searchResult.value = nil
            }

            if self.validate(text) {
                fetch(self.input.sortType.value)
            }

            self.output.scrollGoToTop.value = ()
        }

        input.scrollDidChangeTrigger.lazyBind { [weak self] _ in
            guard let self else { return }

            self.middle.page.value += 1
            self.fetch(self.input.sortType.value)
            print(middle.page.value)
        }

        input.sortType.bind { sortType in
            self.middle.page.value = 1
            self.output.searchResult.value = nil
            self.fetch(sortType)
            self.output.scrollGoToTop.value = ()
        }

        input.colorType.bind { colorType in
            self.middle.page.value = 1
            self.output.searchResult.value = nil
            self.fetch(self.input.sortType.value)
            self.output.scrollGoToTop.value = ()
        }
    }

    private func validate(_ text: String?) -> Bool {
        guard let text = text, text.trimmingCharacters(in: .whitespaces).count > 0 else {
            output.invalidInput.value = "키워드를 입력해주세요"
            return false
        }
        return true
    }


    //TODO: fetch 관련 구조 개선 필요. color가 없는게 default라서 있을 때는 별도로 fetch해야하는 상황
    private func fetch(_ orderBy: String) {
        guard let keyword = input.searchKeyword.value else { return }

        isInfiniteScroll = true

        let page = middle.page.value
        let perpage = 20
        let color = input.colorType.value
        if let color {
            print(color)
            networkManager.callRequest(api: .search(query: keyword, page: page, perpage: perpage, orderBy: orderBy, color: color), type: SearchPhoto.self) { [weak self] response in
                guard let self else { return }

                self.isInfiniteScroll = false

                switch response {
                case .success(let data):
                    if page == 1 {
                        self.output.searchResult.value = data
                    } else if page >= 2 {
                        var currentData = self.output.searchResult.value ?? .init(total: 0, totalPages: 0, results: [])
                        currentData.results.append(contentsOf: data.results)
                        currentData.total = data.total
                        currentData.totalPages = data.totalPages
                        self.output.searchResult.value = currentData
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            networkManager.callRequest(api: .search(query: keyword, page: page, perpage: perpage, orderBy: orderBy, color: color), type: SearchPhoto.self) { [weak self] response in
                guard let self else { return }

                self.isInfiniteScroll = false

                switch response {
                case .success(let data):
                    if page == 1 {
                        self.output.searchResult.value = data
                    } else if page >= 2 {
                        var currentData = self.output.searchResult.value ?? .init(total: 0, totalPages: 0, results: [])
                        currentData.results.append(contentsOf: data.results)
                        currentData.total = data.total
                        currentData.totalPages = data.totalPages
                        self.output.searchResult.value = currentData
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
