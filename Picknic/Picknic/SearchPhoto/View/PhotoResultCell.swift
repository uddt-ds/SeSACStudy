//
//  PhotoResultCell.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import Kingfisher

final class PhotoResultCell: UICollectionViewCell, BaseViewProtocol, ReusableViewProtocol {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let starCountButton = StarButton()

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

    func configureCell(with data: PhotoResult) {
        guard let url = URL(string: data.urls.small) else { return }
        imageView.kf.setImage(with: url)

        let container = AttributeContainer([
            .foregroundColor : UIColor.white,
            .font : UIFont.systemFont(ofSize: 10)
        ])
        let attributedTitle = AttributedString("\(data.likes)", attributes: container)
        starCountButton.configuration?.attributedTitle = attributedTitle
    }
}
