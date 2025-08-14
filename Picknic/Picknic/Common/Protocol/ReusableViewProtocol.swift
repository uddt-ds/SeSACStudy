//
//  ReusableViewProtocol.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import Foundation

protocol ReusableViewProtocol: AnyObject {
    static var identifier: String { get }
}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
