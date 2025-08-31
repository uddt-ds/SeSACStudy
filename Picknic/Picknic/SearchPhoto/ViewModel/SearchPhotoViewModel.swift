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
        var totalData: BehaviorRelay<[PhotoResult]>
        var totalPage: BehaviorRelay<Int>
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

        let state = State(page: .init(value: 1),
                          totalData: .init(value: []),
                          totalPage: .init(value: 1))

        let sortType = BehaviorRelay<String?>(value: nil)

        let searchResult = PublishRelay<[PhotoResult]>()

        let scrollGoToTop = PublishRelay<Void>()

        let noticeLabelShouldHidden = PublishRelay<Bool>()

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
        .filter({ input, _, _, _ in
            guard let keyword = input else { return false }
            return !keyword.trimmingCharacters(in: .whitespaces).isEmpty
        })
        .flatMap { result in
            return SearchCustomObservable.getSearchData(api: .search(searchQuery: .init(query: result.0, page: result.1, perpage: 20, orderBy: result.2, color: result.3)))
        }
        .debug()
        .bind(with: self) { owner, value in
            switch value {
            case .success(let data):
                state.totalPage.accept(data.totalPages)

                if state.page.value == 1 {
                    state.totalData.accept(data.results)
                    if !state.totalData.value.isEmpty {
                        scrollGoToTop.accept(())
                    }
                } else {
                    let currentData = state.totalData.value
                    let newData = currentData + data.results
                    state.totalData.accept(newData)
                }
                searchResult.accept(state.totalData.value)
                noticeLabelShouldHidden.accept(true)
            case .failure(let error):
                invalidInput.accept(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)

        input.scrollDidChangeTrigger
            .bind(with: self) { owner, _ in
                if state.page.value < state.totalPage.value {
                    var changedPage = state.page.value
                    changedPage += 1
                    state.page.accept(changedPage)
                }
            }
            .disposed(by: disposeBag)

        Observable.merge(
            input.colorType.map { _ in () },
            input.sortButtonState.map { _ in () },
            input.searchKeyword.map { _ in () }
        )
            .bind(with: self) { owner, _ in
                state.page.accept(1)
                state.totalData.accept([])
            }
            .disposed(by: disposeBag)


        return Output(invalidInput: invalidInput, searchResult: searchResult, scrollGoToTop: scrollGoToTop, phLabelShouldHidden: noticeLabelShouldHidden)
    }
}

//    private func validate(_ text: String?) -> Bool {
//        guard let text = text, text.trimmingCharacters(in: .whitespaces).count > 0 else {
//            output.invalidInput.value = "키워드를 입력해주세요"
//            return false
//        }
//        return true
//    }
