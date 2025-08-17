//
//  DetailPhotoVC.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import UIKit
import SnapKit

/*
 TODO: 데이터 핸들링 리팩토링 필요
 */
final class DetailPhotoVC: UIViewController, BaseViewProtocol {

    var viewModel: DetailPhotoViewModel

    var statisticData: Statistics = .init(id: "",
                                          downloads: .init(total: 0, historical: .init(values: [])),
                                          views: .init(total: 0, historical: .init(values: [])))

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        stackView.distribution = .fill
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

    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileStackView, heartButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .main
        return imageView
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
        label.text = "testtest"
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
        label.text = "testtest"
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var downLoadStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [downLoadLabel, downLoadDetailLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()

    private let infoHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = MenuTitle.info.rawValue
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var infoDetailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sizeStackView, totalViewsStackView, downLoadStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoHeaderLabel, infoDetailStackView])
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
        imageView.backgroundColor = .main
        return imageView
    }()

    private lazy var chartStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chartHeaderLabel, chartImageView])
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [photoImageView, infoStackView, chartStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView = UIView()

    init(viewModel: DetailPhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureTopStackViewSubViewLayout()
        configureLayout()
        configureView()
        bindViewModel()

        addObserverNotificationCenter()
    }

    func bindViewModel() {
        viewModel.output.statisticsData.bind { [weak self] data in
            guard let self else { return }
            guard let data else {
                print("데이터가 없습니다")
                return
            }

            self.statisticData = data
            guard let value = viewModel.input.photoResultData.value else {
                return
            }

            configureUI(with: value, statisticsData: data)
        }
    }

    private func addObserverNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(valueChanged),
                                               name: .isUpdateLikeList,
                                               object: nil)
    }

    // ViewModel로 보내줘야 함
    @objc private func buttonTapped(_ sender: UIButton) {
        heartButton.isSelected.toggle()
        if heartButton.isSelected {
            heartButton.tintColor = .main
            if !UserModel.likesList.contains(statisticData.id) {
                UserModel.updateLikeList(photoId: statisticData.id)
            }
        } else {
            heartButton.tintColor = .gray
            UserModel.updateLikeList(photoId: statisticData.id)
        }
        print(UserModel.likesList)
    }

    @objc private func valueChanged(notification: Notification) {
        guard let isUpdate = notification.userInfo?["isAdded"] as? Bool else { return }
        if isUpdate {
            view.makeToast("저장되었습니다", duration: 2.0, position: .bottom)
        } else {
            view.makeToast("삭제되었습니다", duration: 2.0, position: .bottom)
        }
    }
}

//MARK: Setup UI
extension DetailPhotoVC {
    func configureHierarchy() {
        [topStackView, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
    }

    func configureTopStackViewSubViewLayout() {

        profileLabelStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)

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

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    func configureUI(with data: PhotoResult, statisticsData: Statistics) {
        guard let url = URL(string: data.user.profileImage.medium) else { return }
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url)
        profileNameLabel.text = data.user.name

        postDateLabel.text = data.createdDate

        guard let photoUrl = URL(string: data.urls.small) else { return }
        photoImageView.kf.setImage(with: photoUrl)

        sizeDetailLabel.text = "\(data.height) x \(data.width)"
        downLoadDetailLabel.text = "\(statisticsData.downloads.formattedTotal)"
        totalViewsDetailLabel.text = "\(statisticsData.views.formattedViews)"

        if UserModel.likesList.contains(statisticsData.id) {
            heartButton.isSelected = true
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


