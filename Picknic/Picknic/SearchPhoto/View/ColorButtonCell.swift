//
//  SearchPhotoCell.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit

final class ColorButtonCell: UICollectionViewCell, BaseViewProtocol, ReusableViewProtocol {

    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSet.black.color
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = ColorSet.black.title
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [view, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .systemGray5
        stack.layer.cornerRadius = 15
        stack.clipsToBounds = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() {
        [buttonStackView].forEach { contentView.addSubview($0) }
    }

    func configureLayout() {
        view.snp.makeConstraints { make in
            make.size.equalTo(20)
        }

        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureView() {
        contentView.backgroundColor = .clear
    }

    func configureButton(with data: ColorSet) {
        view.backgroundColor = data.color
        label.text = data.title
    }

    func setupBlankButton(with index: Int) {
        view.backgroundColor = .white
        buttonStackView.backgroundColor = .white
    }

    func selectedButton(isSelected: Bool) {
        print(isSelected)
        if isSelected {
            buttonStackView.backgroundColor = .blue
            label.textColor = .white
        } else {
            buttonStackView.backgroundColor = .systemGray5
            label.textColor = .black
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        buttonStackView.backgroundColor = .lightGray
    }
}


