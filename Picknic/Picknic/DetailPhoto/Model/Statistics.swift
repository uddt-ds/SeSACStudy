//
//  StatisticsModel.swift
//  Picknic
//
//  Created by Lee on 8/16/25.
//

import Foundation

struct Statistics: Decodable {
    let id: String
    let downloads: Downloads
    let views: Views
}

struct Downloads: Decodable {
    let total: Int
    let historical: Historical
}

extension Downloads {
    var formattedTotal: String {
        return NumberFormatManager.shared.getDemicalNum(total)
    }
}

struct Views: Decodable {
    let total: Int
    let historical: Historical
}

extension Views {
    var formattedViews: String {
        return NumberFormatManager.shared.getDemicalNum(total)
    }
}

struct Historical: Decodable {
    let values: [Value]
}

struct Value: Decodable {
    let date: String
    let value: Int
}
