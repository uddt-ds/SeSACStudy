//
//  PhotoResultCell.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit

final class PhotoResultCell: UICollectionViewCell, BaseViewProtocol, ReusableViewProtocol {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let starCountButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        let container = AttributeContainer([
            .foregroundColor : UIColor.white,
            .font : UIFont.systemFont(ofSize: 10)
        ])
        let attributedTitle = AttributedString("1000", attributes: container)
        configuration.attributedTitle = attributedTitle
        configuration.image = UIImage(systemName: "star.fill")?.withTintColor(.yellow)
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .gray
        return button
    }()

    private let heartButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "heart")
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureHierarchy() {
        [imageView, starCountButton, heartButton].forEach { contentView.addSubview($0) }
    }

    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        starCountButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(imageView).inset(20)
            make.height.equalTo(36)
            make.width.lessThanOrEqualTo(50)
        }

        heartButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView).inset(20)
            make.height.equalTo(44)
            make.width.lessThanOrEqualTo(50)
        }
    }

    func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

}
