//
//  SearchPhotoCell.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit

final class SearchPhotoCell: UICollectionViewCell, BaseViewProtocol, ReusableViewProtocol {

    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSet.black.color
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = ColorSet.black.title
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [view, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.backgroundColor = .lightGray
        stack.layer.cornerRadius = 8
        stack.clipsToBounds = true
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
            make.size.equalTo(14)
        }

        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureView() {
        contentView.backgroundColor = .clear
    }

}


