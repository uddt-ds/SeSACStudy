//
//  CustomThrottler.swift
//  Picknic
//
//  Created by Lee on 8/18/25.
//

import Foundation

// TODO: 코드 이해해보기
final class CustomThrottler {
    private var timer: Timer?
    private var interval: TimeInterval

    init(interval: TimeInterval) {
        self.interval = interval
    }

    func run(_ handler: @escaping () -> Void) {
        if timer?.isValid == true {
            return
        }

        handler()

        timer = Timer.scheduledTimer(withTimeInterval: interval,
                                     repeats: false,
                                     block: { timer in
            timer.invalidate()
        })
    }
}
