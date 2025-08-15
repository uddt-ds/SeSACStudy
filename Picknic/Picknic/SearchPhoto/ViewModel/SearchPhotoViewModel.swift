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
        validate()
    }

    func validate() {
        input.searchKeyword.lazyBind { [weak self] text in
            guard let self else { return }

            guard let text, text.count < 0 else {
                self.output.invalidInput.value = "검색어를 입력해주세요"
                return
            }
        }
    }

    func fetchData() {
        guard let keyword = input.searchKeyword.value else { return }
        let page = input.page.value
        let perpage = 20
        let orderBy = input.sortType.value
        guard let color = input.colorType.value else { return }
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
