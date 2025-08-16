//
//  SearchPhotoViewModel.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation
import Alamofire

/*
 TODO: 최신순, 관련도순 정렬 시 데이터에 대한 정확도가 떨어짐
 페이지 수가 지금 이상하게 늘어나는 중 디버깅이 필요함
 */

class SearchPhotoViewModel {

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


        // TODO: 검색할 때 초기화 적용 필요
        input.searchKeyword.bind { [weak self] text in
            guard let self else { return }
            let page = self.middle.page.value
            
            if page != 1 && !isInfiniteScroll {
                self.middle.page.value = 1
                self.output.searchResult.value = nil
            }

            // TODO: 만약에 유저가 최신순을 누른 상태로 검색을 한다면? 최신순인지 관련도순인지에 대한 데이터도 필요함
            if self.validate(text) {
                fetch(self.input.sortType.value)
            }

            self.output.scrollGoToTop.value = ()
        }

        // TODO: 페이지 2개씩 올라가는 문제 해결 필요
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
    }

    private func validate(_ text: String?) -> Bool {
        guard let text = text, text.trimmingCharacters(in: .whitespaces).count > 0 else {
            output.invalidInput.value = "키워드를 입력해주세요"
            return false
        }
        return true
    }

    private func fetch(_ orderBy: String) {
        guard let keyword = input.searchKeyword.value else { return }

        isInfiniteScroll = true

        let page = middle.page.value
        let perpage = 20
        let color = input.colorType.value
        networkManager.callRequest(api: .search(query: keyword, page: page, perpage: perpage, orderBy: orderBy, color: color), type: SearchPhoto.self) { [weak self] response in
            guard let self else { return }

            self.isInfiniteScroll = false

            // 새로운 검색하면 page 1로 바뀌는지 확인이 필요함
//            if !self.isInfiniteScroll {
//                self.middle.page.value = 1
//                self.output.searchResult.value = nil
//            }

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
