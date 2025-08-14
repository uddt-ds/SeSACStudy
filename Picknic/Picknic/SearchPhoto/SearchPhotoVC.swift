//
//  SearchPhotoVC.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit

enum ColorSet: String, CaseIterable {
    case black
    case white
    case yellow
    case orange
    case red
    case purple
    case magenta
    case green
    case blue

    var color: UIColor {
        switch self {
        case .black: return .black
        case .white: return .white
        case .yellow: return .yellow
        case .orange: return .orange
        case .red: return .red
        case .purple: return .purple
        case .magenta: return .magenta
        case .green: return .green
        case .blue: return .blue
        }
    }

    var title: String {
        switch self {
        case .black: return "블랙"
        case .white: return "화이트"
        case .yellow: return "옐로우"
        case .orange: return "오렌지"
        case .red: return "레드"
        case .purple: return "퍼플"
        case .magenta: return "마젠타"
        case .green: return "그린"
        case .blue: return "블루"
        }
    }
}

enum CollectionViewQuantity {
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
        case .leadingInset: return 8
        case .trailingInset: return 8
        case .topInset: return 0
        case .bottomInset: return 0
        }
    }
}

final class SearchPhotoVC: UIViewController, BaseViewProtocol {

    let searchController = UISearchController()

    private lazy var buttonCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.makeCollectinoViewLayout())
        view.dataSource = self
        view.delegate = self
        view.register(SearchPhotoCell.self, forCellWithReuseIdentifier: SearchPhotoCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private lazy var sortButton: ToggleButton = {
        let button = ToggleButton()
        return button
    }()

    private let phLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 검색해보세요"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        setupNav()
        setupSearchController()
    }


    func setupSearchController() {
        searchController.searchBar.placeholder = "키워드 검색"
        searchController.delegate = self
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
    }

    func configureHierarchy() {
        [buttonCollectionView, sortButton, phLabel].forEach { view.addSubview($0) }
    }

    func configureLayout() {
        buttonCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }

        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(buttonCollectionView)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(43)
            make.width.equalTo(70)
        }

        phLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()      // TODO: CollectionView 센터로 수정 필요
        }
    }

    func setupNav() {
        navigationItem.title = "SEARCH PHOTO"
    }

    func makeCollectinoViewLayout() -> UICollectionViewFlowLayout {
        typealias quantity = CollectionViewQuantity
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = quantity.lineSpacing.value
        layout.minimumInteritemSpacing = quantity.itemSpacing.value
        layout.sectionInset = .init(top: quantity.topInset.value,
                                    left: quantity.leadingInset.value,
                                    bottom: quantity.bottomInset.value,
                                    right: quantity.trailingInset.value)
        layout.itemSize = .init(width: 60, height: 32) // TODO: 삭제 필요. width 동적으로 가져와야함
        return layout
    }
}

extension SearchPhotoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPhotoCell.identifier, for: indexPath) as? SearchPhotoCell else { return .init() }
        return cell
    }
    

}

extension SearchPhotoVC: UISearchControllerDelegate  {

}
