//
//  FirstTopicCell.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit

final class TopicCell: UICollectionViewCell, ReusableViewProtocol, BaseViewProtocol {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()

    let button = StarButton()

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

    func configureHierarchy() {
        [imageView, button].forEach { contentView.addSubview($0) }
    }

    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
        }
    }

    func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}

