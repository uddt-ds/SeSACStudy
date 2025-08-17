//
//  SearchPhotoVC.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit
import Toast

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
    case blank

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
        case .blank: return .white
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
        case .blank: return ""
        }
    }
}

enum ButtonCollectionViewQuantity: CaseIterable {
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

enum PhotoCollectionViewQuantity: CaseIterable {
    case lineSpacing
    case itemSpacing
    case leadingInset
    case trailingInset
    case topInset
    case bottomInset

    var value: CGFloat {
        switch self {
        case .lineSpacing: return 2
        case .itemSpacing: return 2
        case .leadingInset: return 0
        case .trailingInset: return 0
        case .topInset: return 0
        case .bottomInset: return 0
        }
    }
}

final class SearchPhotoVC: UIViewController, BaseViewProtocol {

    private let searchController = UISearchController()

    private let viewModel = SearchPhotoViewModel()

    private var selectedIndexPath: IndexPath?

    private var searchPhotoData: SearchPhoto = .init(total: 0, totalPages: 0, results: [])

    private lazy var buttonCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.makeButtonCollectinoViewLayout())
        view.dataSource = self
        view.delegate = self
        view.register(ColorButtonCell.self, forCellWithReuseIdentifier: ColorButtonCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private lazy var sortButton: ToggleButton = {
        let button = ToggleButton()
        return button
    }()

    private lazy var photoCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.makePhotoCollectionViewLayout())
        view.dataSource = self
        view.delegate = self
        view.register(PhotoResultCell.self, forCellWithReuseIdentifier: PhotoResultCell.identifier)
        view.showsVerticalScrollIndicator = false
        return view
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
        sortButtonToggle()

        bindViewModel()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(valueChanged),
                                               name: .isUpdateLikeList,
                                               object: nil)
    }

    private func sortButtonToggle() {
        sortButton.isToggle = { [weak self] isToggle in
            guard let self else { return }
            print(isToggle)
            if isToggle {
                self.viewModel.input.sortType.value = OrderBy.latest.rawValue
                self.photoCollectionView.reloadData()
            } else {
                self.viewModel.input.sortType.value = OrderBy.relevant.rawValue
                self.photoCollectionView.reloadData()
            }
        }
    }

    private func setupSearchController() {
        searchController.searchBar.placeholder = "키워드 검색"
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
    }

    func configureHierarchy() {
        [buttonCollectionView, sortButton, photoCollectionView, phLabel].forEach { view.addSubview($0) }
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
            make.height.equalTo(36)
            make.width.equalTo(70)
        }

        phLabel.snp.makeConstraints { make in
            make.center.equalTo(photoCollectionView.snp.center)
        }

        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonCollectionView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindViewModel() {
        viewModel.output.searchResult.lazyBind { [weak self] response in
            guard let self else { return }
            guard let response else { return }
            self.searchPhotoData = response
            self.photoCollectionView.reloadData()
            showPlaceHolderLabel()
        }

        viewModel.output.scrollGoToTop.lazyBind { [weak self] _ in
            guard let self else { return }
            if searchPhotoData.results.count != 0 {
                self.photoCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }

    // result도 없고, searchButton도 눌렀으면 "검색 결과가 없어요"
    // result만 없으면 검색어를 입력해주세요
    private func showPlaceHolderLabel() {
        if searchPhotoData.results.count == 0 {
            phLabel.text = "검색 결과가 없어요"
            phLabel.isHidden = false
        } else {
            phLabel.isHidden = true
        }
    }

    private func setupNav() {
        navigationItem.title = "SEARCH PHOTO"
        navigationController?.navigationBar.scrollEdgeAppearance = .init()
    }

    @objc private func valueChanged(notification: Notification) {
        guard let isUpdate = notification.userInfo?["isAdded"] as? Bool else { return }
        if isUpdate {
            view.makeToast("저장되었습니다", duration: 2.0, position: .bottom)
        } else {
            view.makeToast("삭제되었습니다", duration: 2.0, position: .bottom)
        }
    }

    private func makeButtonCollectinoViewLayout() -> UICollectionViewFlowLayout {
        typealias quantity = ButtonCollectionViewQuantity

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = quantity.lineSpacing.value
        layout.minimumInteritemSpacing = quantity.itemSpacing.value
        layout.sectionInset = .init(top: quantity.topInset.value,
                                    left: quantity.leadingInset.value,
                                    bottom: quantity.bottomInset.value,
                                    right: quantity.trailingInset.value)
        return layout
    }

    private func makePhotoCollectionViewLayout() -> UICollectionViewFlowLayout {
        typealias quantity = PhotoCollectionViewQuantity

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = quantity.lineSpacing.value
        layout.minimumInteritemSpacing = quantity.itemSpacing.value
        layout.sectionInset = .init(top: quantity.topInset.value,
                                    left: quantity.leadingInset.value,
                                    bottom: quantity.bottomInset.value,
                                    right: quantity.trailingInset.value)
        return layout
    }
}

extension SearchPhotoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case buttonCollectionView:
            return ColorSet.allCases.count
        case photoCollectionView:
            return searchPhotoData.results.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case buttonCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorButtonCell.identifier, for: indexPath) as? ColorButtonCell else { return .init() }
            cell.configureButton(with: ColorSet.allCases[indexPath.item])

            let isSelected = (indexPath == selectedIndexPath)
            cell.selectedButton(isSelected: isSelected)

            if ColorSet.allCases[indexPath.item] == ColorSet.blank {
                cell.setupBlankButton(with: indexPath.item)
                cell.isUserInteractionEnabled = false
            }
            return cell
        case photoCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoResultCell.identifier, for: indexPath) as? PhotoResultCell else { return .init() }
            cell.configureCell(with: searchPhotoData.results[indexPath.item])
            let likeListData = UserModel.likesList

            for likeData in likeListData {
                if searchPhotoData.results[indexPath.item].id == likeData {
                    cell.isAlreadyLike(isSelected: true)
                }
            }

            cell.heartButtonTapped = { [weak self] in
                guard let self else { return }
                UserModel.updateLikeList(photoId: searchPhotoData.results[indexPath.item].id)
                print(UserModel.likesList)
            }
            return cell
        default:
            return .init()
        }
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSizeHeight = self.photoCollectionView.contentSize.height
        let collectionViewHeight = self.photoCollectionView.bounds.height
        let offset = scrollView.contentOffset
//
//        guard contentSizeHeight > collectionViewHeight else { return
//            viewModel.isInfiniteScroll = false
//        }

        // TODO: 페이지 2개씩 올라가는 문제 해결 필요
        if offset.y > (contentSizeHeight - collectionViewHeight - 180), !viewModel.isInfiniteScroll {
            viewModel.isInfiniteScroll = true
            viewModel.input.scrollDidChangeTrigger.value = ()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case buttonCollectionView:
            if viewModel.input.colorType.value == nil {
                viewModel.input.colorType.value = ColorSet.allCases[indexPath.item].rawValue
                selectedIndexPath = indexPath
                collectionView.reloadItems(at: [indexPath])
            } else if viewModel.input.colorType.value != nil &&
                        viewModel.input.colorType.value == ColorSet.allCases[indexPath.item].rawValue {
                viewModel.input.colorType.value = nil
                selectedIndexPath = nil
                collectionView.reloadItems(at: [indexPath])
            } else if viewModel.input.colorType.value != ColorSet.allCases[indexPath.item].rawValue {
                let previousIndexPath = selectedIndexPath
                selectedIndexPath = indexPath
                viewModel.input.colorType.value = ColorSet.allCases[indexPath.item].rawValue
                if let selectedIndexPath, let previousIndexPath {
                    collectionView.reloadItems(at: [
                        previousIndexPath,
                        selectedIndexPath
                    ])
                }
        }
        case photoCollectionView:
            let viewModel = DetailPhotoViewModel(photoData: searchPhotoData.results[indexPath.item])
            let vc = DetailPhotoVC(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}

extension SearchPhotoVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case buttonCollectionView:
            return .init(width: (view.frame.width) / 5, height: 32)
        case photoCollectionView:
            return .init(width: ((collectionView.frame.width) / 2) - PhotoCollectionViewQuantity.lineSpacing.value,
                         height: (collectionView.frame.height) / 2.3 - PhotoCollectionViewQuantity.itemSpacing.value)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PhotoCollectionViewQuantity.lineSpacing.value
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return PhotoCollectionViewQuantity.itemSpacing.value
    }
}

extension SearchPhotoVC: UISearchBarDelegate  {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.input.searchKeyword.value = searchBar.text
    }
}
