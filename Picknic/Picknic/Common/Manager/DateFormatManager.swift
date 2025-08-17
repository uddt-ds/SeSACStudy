//
//  DateFormatManager.swift
//  Picknic
//
//  Created by Lee on 8/17/25.
//

import Foundation

final class DateFormatManager {
    static let shared = DateFormatManager()

    private let formatter = DateFormatter()
    private let formatter2 = DateFormatter()

    private init() { }

    func getDate(_ strDate: String) -> String {
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: strDate) else { return .init() }

        formatter2.locale = .init(identifier: "ko_KR")
        formatter2.dateFormat = "yyyy년 M월 d일"
        return formatter2.string(from: date)
    }
}
