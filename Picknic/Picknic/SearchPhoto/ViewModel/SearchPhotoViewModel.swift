//
//  SearchPhotoViewModel.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class SearchPhotoViewModel {

    private let networkManager = NetworkManager.shared

    let disposeBag = DisposeBag()

    struct Input {
        var searchKeyword: BehaviorSubject<String?>
        var sortButtonState: Observable<Bool>
        var colorType:  BehaviorSubject<String?>
        var scrollDidChangeTrigger: PublishRelay<Void>
    }

    struct State {
        var page: BehaviorRelay<Int>
    }

    struct Output {
        var colorButtonData = BehaviorRelay(value: ColorSet.allCases)
        var invalidInput: BehaviorRelay<String>
        var searchResult: BehaviorRelay<[PhotoResult]>
        var scrollGoToTop: BehaviorRelay<Void>
        var phLabelShouldHidden: PublishRelay<Bool>
    }

    var isInfiniteScroll = false

    var totalCount: Int?
    var totalPage: Int?

    func transform(input: Input) -> Output {

        let invalidInput = BehaviorRelay(value: "")

        let state = State(page: .init(value: 1))

        let sortType = BehaviorRelay<String?>(value: nil)

        let searchResult = BehaviorRelay<[PhotoResult]>(value: [])

        let scrollGoToTop = BehaviorRelay(value: ())

        var totalData: [PhotoResult] = []

        let noticeLabelShouldHidden = PublishRelay<Bool>()

        input.sortButtonState
            .map { $0 ? OrderBy.relevant.rawValue : OrderBy.latest.rawValue  }
            .bind(with: self) { owner, value in
                sortType.accept(value)
            }
            .disposed(by: disposeBag)

        // 다른 버튼 누르면, 검색어를 다 비워야하는 로직 추가가 필요함
        // 묶어놨는데 얘를 어떻게 처리할지 고민해봐야 함
        Observable.combineLatest(input.searchKeyword.asObservable(),
                                 state.page.asObservable(),
                                 sortType.asObservable(),
                                 input.colorType.asObservable()
        )
        .debug()
            .flatMap { result in
                SearchCustomObservable.getSearchData(api: .search(searchQuery: .init(query: result.0, page: result.1, perpage: 20, orderBy: result.2, color: result.3)))
            }
            .debug()
            .bind(with: self) { owner, value in
                switch value {
                case .success(let data):
                    totalData.append(contentsOf: data.results)
                    searchResult.accept(totalData)
                    noticeLabelShouldHidden.accept(true)
                case .failure(let error):
                    invalidInput.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        input.scrollDidChangeTrigger
            .bind(with: self) { owner, _ in
                var changedPage = state.page.value
                changedPage += 1
                state.page.accept(changedPage)
            }
            .disposed(by: disposeBag)

        return Output(invalidInput: invalidInput, searchResult: searchResult, scrollGoToTop: scrollGoToTop, phLabelShouldHidden: noticeLabelShouldHidden)
    }

//    init() {
//
//        input.searchKeyword.bind { [weak self] text in
//            guard let self else { return }
//            let page = self.middle.page.value
//
//            if page != 1 && !isInfiniteScroll {
//                self.middle.page.value = 1
//                self.output.searchResult.value = nil
//            }
//
//            if self.validate(text) {
//                fetch(self.input.sortType.value)
//            }
//
//            self.output.scrollGoToTop.value = ()
//        }
//
//        // TODO: 페이지네이션 예외처리 리팩토링 필요
//        input.scrollDidChangeTrigger.lazyBind { [weak self] _ in
//            guard let self else { return }
//
//            guard let totalPage else { return }
//            guard let totalCount else { return }
//            if totalPage >= self.middle.page.value, totalCount >= 21 {
//                self.middle.page.value += 1
//            }
//            print(middle.page.value)
//        }
//
//        input.sortType.bind { sortType in
//            self.middle.page.value = 1
//            self.output.searchResult.value = nil
//            self.fetch(sortType)
//            self.output.scrollGoToTop.value = ()
//        }
//
//        input.colorType.bind { colorType in
//            self.middle.page.value = 1
//            self.output.searchResult.value = nil
//            self.fetch(self.input.sortType.value)
//            self.output.scrollGoToTop.value = ()
//        }
//
//        // page를 binding하니까 page에서도 fetch가 일어남
//        middle.page.bind { page in
//            self.fetch(self.input.sortType.value, page: page)
//        }
}

//    private func validate(_ text: String?) -> Bool {
//        guard let text = text, text.trimmingCharacters(in: .whitespaces).count > 0 else {
//            output.invalidInput.value = "키워드를 입력해주세요"
//            return false
//        }
//        return true
//    }


//    //TODO: fetch 관련 구조 개선 필요. color가 없는게 default라서 있을 때는 별도로 fetch해야하는 상황
//    private func fetch(_ orderBy: String, page: Int = 1) {
//        guard let keyword = input.searchKeyword.value else { return }
//
//        isInfiniteScroll = true
//
//        let perpage = 20
//        let color = input.colorType.value
//
//        if let color {
//            networkManager.callRequest(api: .search(searchQuery: .init(query: keyword, page: page, perpage: perpage, orderBy: orderBy, color: color)), type: SearchPhoto.self) { [weak self] response in
//                guard let self else { return }
//
//                self.isInfiniteScroll = false
//
//                switch response {
//                case .success(let data):
//                    if page == 1 {
//                        self.output.searchResult.value = data
//                        self.totalPage = data.totalPages
//                        self.totalCount = data.total
//                        dump(data)
//                    } else if page >= 2 {
//                        var currentData = self.output.searchResult.value ?? .init(total: 0, totalPages: 0, results: [])
//                        currentData.results.append(contentsOf: data.results)
//                        currentData.total = data.total
//                        currentData.totalPages = data.totalPages
//                        self.output.searchResult.value = currentData
//                    }
//
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        } else {
//            networkManager.callRequest(api: .search(searchQuery: .init(query: keyword, page: page, perpage: perpage, orderBy: orderBy, color: color)), type: SearchPhoto.self) { [weak self] response in
//                guard let self else { return }
//
//                self.isInfiniteScroll = false
//
//                switch response {
//                case .success(let data):
//                    if page == 1 {
//                        self.output.searchResult.value = data
//                        self.totalPage = data.totalPages
//                        self.totalCount = data.total
//                        dump(data)
//                    } else if page >= 2 {
//                        var currentData = self.output.searchResult.value ?? .init(total: 0, totalPages: 0, results: [])
//                        currentData.results.append(contentsOf: data.results)
//                        currentData.total = data.total
//                        currentData.totalPages = data.totalPages
//                        self.output.searchResult.value = currentData
//                    }
//
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
