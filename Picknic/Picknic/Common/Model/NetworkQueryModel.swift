//
//  NetworkQueryModel.swift
//  Picknic
//
//  Created by Lee on 8/18/25.
//

import Foundation

struct TopicQuery {
    let topicID: String
    let page: Int
    let perpage: Int
}

struct SearchQuery {
    let query: String
    let page: Int
    let perpage: Int
    let orderBy: String
    let color: String?
}

struct StatisticsQuery {
    let imageID: String
}
