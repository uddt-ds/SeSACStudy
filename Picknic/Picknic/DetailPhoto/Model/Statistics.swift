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

struct Views: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [Value]
}

struct Value: Decodable {
    let date: String
    let value: Int
}
