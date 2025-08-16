//
//  NumberFormatManager.swift
//  Picknic
//
//  Created by Lee on 8/17/25.
//

import Foundation

final class NumberFormatManager {
    static let shared = NumberFormatManager()

    private let formatter = NumberFormatter()

    private init() { }

    func getDemicalNum(_ num: Int) -> String {
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? "\(num)"
    }
}
