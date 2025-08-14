//
//  BaseVCProtocol.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit

protocol BaseViewProtocol: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}

extension BaseViewProtocol where Self: UIViewController {
    func configureView() {
        view.backgroundColor = .white
    }
}
