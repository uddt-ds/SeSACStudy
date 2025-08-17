//
//  ProfileImageCell.swift
//  MVVMBasic
//
//  Created by Lee on 8/9/25.
//

import UIKit

class ProfileImageCell: UICollectionViewCell, ReusableViewProtocol {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.disable.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        contentView.addSubview(imageView)
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureView() {
        backgroundColor = .clear
    }

    func configureCell(imageName: String) {
        imageView.image = UIImage(named: imageName)
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2
        }
    }

}
