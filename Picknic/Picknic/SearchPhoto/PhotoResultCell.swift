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
        var configuration = UIButton.Configuration.filled()
        let container = AttributeContainer([
            .foregroundColor : UIColor.white,
            .font : UIFont.systemFont(ofSize: 10)
        ])
        let attributedTitle = AttributedString("1000", attributes: container)
        configuration.attributedTitle = attributedTitle
        configuration.image = UIImage(systemName: "star.fill")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 13)
        configuration.baseBackgroundColor = .gray
        configuration.baseForegroundColor = .yellow
        configuration.imagePadding = 4
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        return button
    }()

    private let heartButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "heart.fill")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18)
        configuration.background.cornerRadius = 20
        configuration.baseBackgroundColor = .gray.withAlphaComponent(0.3)
        configuration.baseForegroundColor = .white
        let button = UIButton(configuration: configuration)
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
            make.width.greaterThanOrEqualTo(40)
        }

        heartButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView).inset(20)
            make.size.equalTo(40)
        }
    }

    func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

}
