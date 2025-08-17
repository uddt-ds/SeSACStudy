//
//  MBTICell.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import UIKit
import SnapKit

final class MBTICell: UICollectionViewCell, ReusableViewProtocol {

    var buttonTapClosure: ((_ sender: UIButton) -> Void)?

    private lazy var button: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    private func configureHierarchy() {
        contentView.addSubview(button)
    }

    private func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configureButton(title: String, tag: Int) {
        button.setTitle(title, for: .normal)

        button.tag = tag
        DispatchQueue.main.async {
            self.button.layer.cornerRadius = self.button.bounds.width / 2
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        buttonTapClosure?(sender)
        print(button.tag)
    }

    func changeButtonColor(isSelected: Bool) {
        button.isSelected = isSelected

        if button.isSelected {
            button.backgroundColor = .main
            button.setTitleColor(.white, for: .selected)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.lightGray, for: .normal)
        }
    }
}
