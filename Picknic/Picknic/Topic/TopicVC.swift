//
//  TopicVC.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit

final class TopicVC: UIViewController, BaseViewProtocol {

    private let viewModel = TopicViewModel()

    var firstTopicData: [PhotoResult] = []
    var secondTopicData: [PhotoResult] = []
    var thirdTopicData: [PhotoResult] = []

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.text = TopicTitle.header.rawValue
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let headerBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let firstTopicLabel: UILabel = {
        let label = UILabel()
        label.text = TopicTitle.first.rawValue
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var firstTopicCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        return collectionView
    }()

    private let secondTopicLabel: UILabel = {
        let label = UILabel()
        label.text = TopicTitle.second.rawValue
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var secondTopicCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        return collectionView
    }()

    private let thirdTopicLabel: UILabel = {
        let label = UILabel()
        label.text = TopicTitle.third.rawValue
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var thirdTopicCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        return collectionView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        setupNav()

        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.input.viewDidLoadTrigger.value = ()

        viewModel.output.totalData.bind { data in
            self.firstTopicData = data.first
            self.secondTopicData = data.second
            self.thirdTopicData = data.third

            [self.firstTopicCollectionView, self.secondTopicCollectionView, self.thirdTopicCollectionView].forEach { $0.reloadData() }
        }
    }

    @objc private func buttonTapped() {
        let mbtiVC = MBTIViewController()
        navigationController?.pushViewController(mbtiVC, animated: true)
    }
}

// MARK: Setup UI
extension TopicVC {
    func configureHierarchy() {
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        [headerBackgroundView, headerLabel].forEach { view.addSubview($0) }

        [firstTopicLabel, firstTopicCollectionView, secondTopicLabel, secondTopicCollectionView, thirdTopicLabel, thirdTopicCollectionView].forEach { contentView.addSubview($0) }
    }

    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerBackgroundView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }

        headerBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.directionalVerticalEdges.equalTo(headerLabel.snp.directionalVerticalEdges)
        }

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(26)
        }

        firstTopicLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(headerLabel)
            make.height.equalTo(16)
        }

        firstTopicCollectionView.snp.makeConstraints { make in
            make.top.equalTo(firstTopicLabel.snp.bottom).offset(10)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(220)
        }

        secondTopicLabel.snp.makeConstraints { make in
            make.top.equalTo(firstTopicCollectionView.snp.bottom).offset(20)
            make.leading.equalTo(headerLabel)
            make.height.equalTo(16)
        }

        secondTopicCollectionView.snp.makeConstraints { make in
            make.top.equalTo(secondTopicLabel.snp.bottom).offset(10)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(220)
        }

        thirdTopicLabel.snp.makeConstraints { make in
            make.top.equalTo(secondTopicCollectionView.snp.bottom).offset(20)
            make.leading.equalTo(headerLabel)
            make.height.equalTo(16)
        }

        thirdTopicCollectionView.snp.makeConstraints { make in
            make.top.equalTo(thirdTopicLabel.snp.bottom).offset(10)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(220)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    // TODO: profileImageView 값 전달 필요
    private func setupNav() {
        navigationItem.title = ""

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(buttonTapped))

        let scaledImage = UIImage.image11.resizeImage(size: CGSize(width: 40, height: 40))
        let imageView = UIImageView(image: scaledImage)
        imageView.frame = CGRect(origin: .zero, size: scaledImage.size)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.main.cgColor
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imageView)
        navigationController?.navigationBar.shadowImage = nil
    }

    func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        typealias quantity = TopicCollectinoViewQuantity

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = quantity.lineSpacing.value
        layout.minimumInteritemSpacing = quantity.itemSpacing.value
        layout.sectionInset = .init(top: quantity.topInset.value,
                                    left: quantity.leadingInset.value,
                                    bottom: quantity.bottomInset.value,
                                    right: quantity.trailingInset.value)
        layout.itemSize = .init(width: 150, height: 200)
        return layout
    }
}

extension TopicVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case firstTopicCollectionView:
            return firstTopicData.count
        case secondTopicCollectionView:
            return secondTopicData.count
        case thirdTopicCollectionView:
            return thirdTopicData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case firstTopicCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else { return .init() }
            cell.configureCell(with: firstTopicData[indexPath.item])
            return cell
        case secondTopicCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else { return .init() }
            cell.configureCell(with: secondTopicData[indexPath.item])
            return cell
        case thirdTopicCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else { return .init() }
            cell.configureCell(with: thirdTopicData[indexPath.item])
            return cell
        default:
            return .init()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case firstTopicCollectionView:
            let viewModel = DetailPhotoViewModel(photoData: firstTopicData[indexPath.item])
            let vc = DetailPhotoVC(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        case secondTopicCollectionView:
            let viewModel = DetailPhotoViewModel(photoData: secondTopicData[indexPath.item])
            let vc = DetailPhotoVC(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        case thirdTopicCollectionView:
            let viewModel = DetailPhotoViewModel(photoData: thirdTopicData[indexPath.item])
            let vc = DetailPhotoVC(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}

extension TopicVC {
    enum TopicCollectinoViewQuantity {
        case lineSpacing
        case itemSpacing
        case leadingInset
        case trailingInset
        case topInset
        case bottomInset

        var value: CGFloat {
            switch self {
            case .lineSpacing: return 8
            case .itemSpacing: return 0
            case .leadingInset: return 20
            case .trailingInset: return 20
            case .topInset: return 0
            case .bottomInset: return 0
            }
        }
    }
}

extension TopicVC {
    enum TopicTitle: String {
        case header = "OUR TOPIC"
        case first = "골든아워"
        case second = "비즈니스 및 업무"
        case third = "건축 및 인테리어"
    }
}
