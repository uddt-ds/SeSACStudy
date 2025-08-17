//
//  ProfileViewController.swift
//  MVVMBasic
//
//  Created by Lee on 8/9/25.
//

import UIKit

final class ProfileViewController: UIViewController {

    let imageManager = ImageManager.shared

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 80
        imageView.layer.borderColor = UIColor.main.cgColor
        imageView.layer.borderWidth = 5
        return imageView
    }()

    private let cameraImageButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16)
        let image = UIImage(systemName: "camera.fill", withConfiguration: symbolConfiguration)
        button.setImage(image, for: .normal)
        button.backgroundColor = .main
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.tintColor = .white
        return button
    }()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureHierarchy()
        configureLayout()
        configureView()
        setupNav()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: ProfileImageCell.identifier)
    }

    private func makeCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = (deviceWidth - 56 - (16 * 3)) / 4
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .zero
        layout.itemSize = .init(width: cellWidth, height: cellWidth)
        return layout
    }

    private func configureHierarchy() {
        [imageView, cameraImageButton, collectionView].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(160)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }

        cameraImageButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalTo(imageView.snp.bottom).offset(-44)
            make.trailing.equalTo(imageView).offset(-12)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(60)
            make.directionalHorizontalEdges.equalToSuperview().inset(28)
            make.height.equalToSuperview().multipliedBy(0.293)
        }
    }

    private func configureView() {
        collectionView.backgroundColor = .clear
    }

    private func setupNav() {
        navigationItem.title = "PROFILE SETTING"
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCell.identifier, for: indexPath) as? ProfileImageCell else { return .init() }
        cell.configureCell(imageName: imageManager.imageNames[indexPath.item])
        return cell
    }
}
