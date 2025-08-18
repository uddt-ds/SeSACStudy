//
//  SearchPhotoViewModel.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation
import Alamofire

/*
TODO:
 middle의 page는 그냥 내부 프로퍼티처럼 쓰고 있는데,
 page의 역할을 정해준다면 페이지가 바뀌면 데이터를 fetch하고 searchResult를 업데이트 해주는 역할로 정해줘도 될거 같음

 페이지가 바뀌면 데이터를 fetch하게 했더니 sortType이 바뀌어도 fetch를 하고
 page가 바뀌어도 fetch하는 상황이 발생(이벤트가 2번 발생함)

 뭔가 묶어서 실행시키게 하거나 다른 방법을 선택해야할거 같은데
 */

final class SearchPhotoViewModel {

    private let networkManager = NetworkManager.shared

    var input: Input
    private var middle: Middle
    var output: Output

    var isInfiniteScroll = false
    var totalPage: Int?

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

        // TODO: 페이지네이션 예외처리 리팩토링 필요
        input.scrollDidChangeTrigger.lazyBind { [weak self] _ in
            guard let self else { return }

            guard let totalPage else { return }
            guard let data = output.searchResult.value else { return }
            if totalPage >= self.middle.page.value && data.results.count > 20 {
                self.middle.page.value += 1
            }
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

        // page를 binding하니까 page에서도 fetch가 일어남
        middle.page.lazyBind { page in
            self.fetch(self.input.sortType.value, page: page)
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
    private func fetch(_ orderBy: String, page: Int = 1) {
        guard let keyword = input.searchKeyword.value else { return }

        isInfiniteScroll = true

        let perpage = 20
        let color = input.colorType.value

        if let color {
            networkManager.callRequest(api: .search(searchQuery: .init(query: keyword, page: page, perpage: perpage, orderBy: orderBy, color: color)), type: SearchPhoto.self) { [weak self] response in
                guard let self else { return }

                self.isInfiniteScroll = false

                switch response {
                case .success(let data):
                    if page == 1 {
                        self.output.searchResult.value = data
                        self.totalPage = data.totalPages
                        dump(data)
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
            networkManager.callRequest(api: .search(searchQuery: .init(query: keyword, page: page, perpage: perpage, orderBy: orderBy, color: color)), type: SearchPhoto.self) { [weak self] response in
                guard let self else { return }

                self.isInfiniteScroll = false

                switch response {
                case .success(let data):
                    if page == 1 {
                        self.output.searchResult.value = data
                        self.totalPage = data.totalPages
                        dump(data)
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
