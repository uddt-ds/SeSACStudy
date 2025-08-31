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

//TODO: 페이지네이션 방어로직 구현 필요
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
        var searchResult: PublishRelay<[PhotoResult]>
        var scrollGoToTop: PublishRelay<Void>
        var phLabelShouldHidden: PublishRelay<Bool>
    }

    var isInfiniteScroll = false

    var totalCount: Int?
    var totalPage: Int?

    func transform(input: Input) -> Output {

        let invalidInput = BehaviorRelay(value: "")

        let state = State(page: .init(value: 1))

        let sortType = BehaviorRelay<String?>(value: nil)

        let searchResult = PublishRelay<[PhotoResult]>()

        let scrollGoToTop = PublishRelay<Void>()

        var totalData: [PhotoResult] = []
        print(totalData)

        let noticeLabelShouldHidden = PublishRelay<Bool>()

        input.colorType
            .bind(with: self) { owner, _ in
                totalData = []
                scrollGoToTop.accept(())
                state.page.accept(1)
            }
            .disposed(by: disposeBag)

        input.sortButtonState
            .map { $0 ? OrderBy.relevant.rawValue : OrderBy.latest.rawValue  }
            .bind(with: self) { owner, value in
                sortType.accept(value)
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(input.searchKeyword.asObservable(),
                                 state.page.asObservable(),
                                 sortType.asObservable(),
                                 input.colorType.asObservable()
        )
        .debug()
            .flatMap { result in
                return SearchCustomObservable.getSearchData(api: .search(searchQuery: .init(query: result.0, page: result.1, perpage: 20, orderBy: result.2, color: result.3)))
            }
            .debug()
            .bind(with: self) { owner, value in
                switch value {
                case .success(let data):
                    if state.page.value == 1 {
                        totalData = data.results
                    } else {
                        totalData.append(contentsOf: data.results)
                    }
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
