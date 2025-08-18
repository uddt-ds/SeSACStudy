//
//  FirstTopicCell.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit
import Kingfisher

final class TopicCell: UICollectionViewCell, ReusableViewProtocol, BaseViewProtocol {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()

    private let button = StarButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
        configureSkeleton()
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

    func configureCell(with data: PhotoResult) {
        guard let url = URL(string: data.urls.small) else { return }
//        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)

        let container = AttributeContainer([
            .foregroundColor : UIColor.white,
            .font : UIFont.systemFont(ofSize: 10)
        ])
        let attributedTitle = AttributedString("\(data.formatterLikes)", attributes: container)
        button.configuration?.attributedTitle = attributedTitle
    }
}

extension TopicCell {
    private func configureSkeleton() {
        isSkeletonable = true
        imageView.isSkeletonable = true
    }
}

