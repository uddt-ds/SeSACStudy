//
//  SearchPhotoViewModel.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation
import Alamofire

class SearchPhotoViewModel {

    private let networkManager = NetworkManager.shared

    var input: Input
    var output: Output

    struct Input {
        var searchKeyword: Observable<String?> = Observable(value: nil)
        var sortType: Observable<String> = Observable(value: OrderBy.relevant.rawValue)
        var page: Observable<Int> = Observable(value: 1)
        var colorType: Observable<String?> = Observable(value: nil)
    }

    struct Output {
        var invalidInput: Observable<String> = Observable(value: "")
        var searchResult: Observable<SearchPhoto?> = Observable(value: nil)
    }

    init() {
        input = Input()
        output = Output()

        input.searchKeyword.bind { [weak self] text in
            guard let self else { return }
            if self.validate(text) {
                fetch()
            }
        }
    }

    private func validate(_ text: String?) -> Bool {
        guard let text = text, text.trimmingCharacters(in: .whitespaces).count > 0 else {
            output.invalidInput.value = "키워드를 입력해주세요"
            return false
        }
        return true
    }

    private func fetch() {
        guard let keyword = input.searchKeyword.value else { return }
        let page = input.page.value
        let perpage = 20
        let orderBy = input.sortType.value
        let color = input.colorType.value
        print(color)
        networkManager.callRequest(api: .search(query: keyword, page: page, perpage: perpage, orderBy: orderBy, color: color), type: SearchPhoto.self) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
                self.output.searchResult.value = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
