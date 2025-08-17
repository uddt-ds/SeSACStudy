//
//  ColorSet.swift
//  Picknic
//
//  Created by Lee on 8/18/25.
//

import UIKit

enum ColorSet: String, CaseIterable {
    case black
    case white
    case yellow
    case orange
    case red
    case purple
    case magenta
    case green
    case blue
    case blank

    var color: UIColor {
        switch self {
        case .black: return .black
        case .white: return .white
        case .yellow: return .yellow
        case .orange: return .orange
        case .red: return .red
        case .purple: return .purple
        case .magenta: return .magenta
        case .green: return .green
        case .blue: return .blue
        case .blank: return .white
        }
    }

    var title: String {
        switch self {
        case .black: return "블랙"
        case .white: return "화이트"
        case .yellow: return "옐로우"
        case .orange: return "오렌지"
        case .red: return "레드"
        case .purple: return "퍼플"
        case .magenta: return "마젠타"
        case .green: return "그린"
        case .blue: return "블루"
        case .blank: return ""
        }
    }
}
