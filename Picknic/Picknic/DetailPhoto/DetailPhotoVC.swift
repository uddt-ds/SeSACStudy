//
//  DetailPhotoVC.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import UIKit

final class DetailPhotoVC: UIViewController, BaseViewProtocol {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "테스트 이름"
        label.textColor = .black
        return label
    }()

    private let postDateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.text = "0000년 0월 0일 게시일"
        label.textColor = .black
        return label
    }()

    private lazy var profileLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileNameLabel, postDateLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, profileLabelStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .blue
        return button
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileStackView, heartButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue
        return imageView
    }()

    private let infoHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = MenuTitle.info.rawValue
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.text = SubTitle.size.rawValue
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let sizeDetailLabel : UILabel = {
        let label = UILabel()
        label.text = "0000 x 0000"
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var sizeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sizeLabel, sizeDetailLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        return stackView
    }()

    private let totalViewsLabel: UILabel = {
        let label = UILabel()
        label.text = SubTitle.totalViews.rawValue
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let totalViewsDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "1525253"
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var totalViewsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalViewsLabel, totalViewsDetailLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()

    private let downLoadLabel: UILabel = {
        let label = UILabel()
        label.text = SubTitle.downloads.rawValue
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let downLoadDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "3333333"
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var downLoadStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [downLoadLabel, downLoadDetailLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()

    private lazy var infoDetailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sizeStackView, totalViewsStackView, downLoadStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let chartHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = MenuTitle.chart.rawValue
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    // TODO: 임시 이미지
    private let chartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureTopStackViewSubViewLayout()
        configureLayout()
        configureView()
    }

    func configureHierarchy() {
        [topStackView, photoImageView, infoHeaderLabel, infoDetailStackView, chartHeaderLabel, chartImageView].forEach { view.addSubview($0) }
    }

    func configureTopStackViewSubViewLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
        }

        heartButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }

    func configureLayout() {
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }

        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200) // TODO: 수정 필요
        }

        infoHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        infoDetailStackView.snp.makeConstraints { make in
            make.top.equalTo(infoHeaderLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(infoHeaderLabel).offset(100)
        }

        chartHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(infoDetailStackView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        chartImageView.snp.makeConstraints { make in
            make.top.equalTo(chartHeaderLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(infoHeaderLabel).offset(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DetailPhotoVC {
    enum MenuTitle: String {
        case info = "정보"
        case chart = "차트"
    }

    enum SubTitle: String {
        case size = "크기"
        case totalViews = "조회수"
        case downloads = "다운로드"
    }
}
