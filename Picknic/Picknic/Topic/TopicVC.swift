//
//  TopicVC.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit

final class TopicVC: UIViewController, BaseViewProtocol {

    let viewModel = TopicViewModel()

    var firstTopicData: [PhotoResult] = []
    var secondTopicData: [PhotoResult] = []
    var thirdTopicData: [PhotoResult] = []

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.text = TopicTitle.header.rawValue
        label.textColor = .black
        label.textAlignment = .left
        return label
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeFirstCollectinoViewLayout())
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeFirstCollectinoViewLayout())
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeFirstCollectinoViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()

        navigationController?.navigationBar.isHidden = true

        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.input.viewDidLoadTrigger.value = ()

        viewModel.output.firstTopicData.lazyBind { data in
            self.firstTopicData = data
            self.firstTopicCollectionView.reloadData()
        }

        viewModel.output.secondTopicData.lazyBind { data in
            self.secondTopicData = data
            self.secondTopicCollectionView.reloadData()
        }

        viewModel.output.thirdTopicData.lazyBind { data in
            self.thirdTopicData = data
            self.thirdTopicCollectionView.reloadData()
        }
    }

    func configureHierarchy() {
        [imageView, headerLabel, firstTopicLabel, firstTopicCollectionView, secondTopicLabel, secondTopicCollectionView, thirdTopicLabel, thirdTopicCollectionView].forEach { view.addSubview($0) }
    }

    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.size.equalTo(36)
        }

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(26)
        }

        firstTopicLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(30)
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
        }
    }

    func makeFirstCollectinoViewLayout() -> UICollectionViewFlowLayout {
        typealias quantity = TopicCollectinoViewQuantity

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = quantity.lineSpacing.value
        layout.minimumInteritemSpacing = quantity.itemSpacing.value
        layout.sectionInset = .init(top: quantity.topInset.value,
                                    left: quantity.leadingInset.value,
                                    bottom: quantity.bottomInset.value,
                                    right: quantity.trailingInset.value)
        layout.itemSize = .init(width: 150, height: 200) // TODO: 삭제 필요. width 동적으로 가져와야함
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
            print(#function, firstTopicData)
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

    enum TopicTitle: String {
        case header = "OUR TOPIC"
        case first = "골든아워"
        case second = "비즈니스 및 업무"
        case third = "건축 및 인테리어"
    }
}
