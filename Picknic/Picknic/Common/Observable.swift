//
//  Observable.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import Foundation

final class Observable<T> {

    var action: ((T) -> Void)?

    var value: T {
        didSet {
            action?(value)
        }
    }

    init(value: T) {
        self.value = value
    }

    func bind(closure: @escaping ((T) -> Void)) {
        action?(value)
        self.action = closure
    }

    func lazyBind(closure: @escaping ((T) -> Void)) {
        self.action = closure
    }
}
