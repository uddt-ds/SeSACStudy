//
//  ImageManager.swift
//  MVVMBasic
//
//  Created by Lee on 8/9/25.
//

import Foundation

enum ImageSystem: String, CaseIterable {
    case image1
    case image2
    case image3
    case image4
    case image5
    case image6
    case image7
    case image8
    case image9
    case image10
    case image11
    case image12
}

final class ImageManager {
    static let shared = ImageManager()

    private init() { }

    private let imageSystemArr = ImageSystem.allCases

    var imageNames: [String] {
        return imageSystemArr.map { $0.rawValue }
    }
}
