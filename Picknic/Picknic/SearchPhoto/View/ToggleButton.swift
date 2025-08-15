//
//  ToggleButton.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit

final class ToggleButton: UIButton {
    var isToggle: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle(" 관련순", for: .normal)
        setTitle(" 최신순", for: .selected)
        titleLabel?.font = .boldSystemFont(ofSize: 14)
        setTitleColor(.black, for: .normal)
        setTitleColor(.black, for: .selected)
        setImage(UIImage(systemName: "text.badge.checkmark"), for: .normal)
        tintColor = .black
        backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func bind() {
        addTarget(self, action: #selector(changeSelectedButton), for: .touchUpInside)
    }

    @objc private func changeSelectedButton() {
        isSelected.toggle()
        isToggle?(isSelected)
    }
}
