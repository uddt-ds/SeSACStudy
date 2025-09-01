//
//  SearchPhotoVC.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

final class SearchPhotoVC: UIViewController, BaseViewProtocol, UICollectionViewDelegate {

    private let searchController = UISearchController()

    private let viewModel = SearchPhotoViewModel()

    let disposeBag = DisposeBag()

    private var selectedIndexPath: IndexPath?

    private var searchPhotoData: SearchPhoto = .init(total: 0, totalPages: 0, results: [])

    private let throttle = CustomThrottler(interval: 0.5)

    private let scrollDidChangeTrigger = PublishRelay<Void>()

    private let selectedButtonIndex: BehaviorRelay<IndexPath?> = BehaviorRelay(value: nil)

    private let selectedModel: BehaviorRelay<ColorSet?> = BehaviorRelay(value: nil)

    private lazy var buttonCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.makeButtonCollectinoViewLayout())
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
//        view.dataSource = self
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
//        bindViewModel()
        bind()
        addObserverNotificationCenter()
    }

    override func viewDidLayoutSubviews() {
        updatePhotoCollectionViewLayout()
    }

    private func bind() {

        let colorType = BehaviorSubject<String?>(value: nil)

        let searchText = BehaviorSubject<String?>(value: nil)

        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text)
            .distinctUntilChanged()
            .debug()
            .bind(with: self) { owner, value in
                searchText.onNext(value)
            }
            .disposed(by: disposeBag)

        let input = SearchPhotoViewModel.Input(searchKeyword: searchText, sortButtonState: sortButton.rx.buttonState, colorType: colorType, scrollDidChangeTrigger: scrollDidChangeTrigger)

        let output = viewModel.transform(input: input)

        output.colorButtonData
            .bind(to: buttonCollectionView.rx.items(cellIdentifier: ColorButtonCell.identifier, cellType: ColorButtonCell.self)) { row, element, cell in
                cell.configureButton(with: element)
            }
            .disposed(by: disposeBag)


        buttonCollectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                let previousButtonIndex = owner.selectedButtonIndex.value

                if let previousIndex = previousButtonIndex, previousIndex != indexPath {
                    if let cell = owner.buttonCollectionView.cellForItem(at: previousIndex) as? ColorButtonCell {
                        cell.selectedButton(isSelected: false)
                    }

                    if let cell = owner.buttonCollectionView.cellForItem(at: indexPath) as? ColorButtonCell {
                        cell.selectedButton(isSelected: true)
                    }
                }

                if let previousIndex = previousButtonIndex, previousIndex == indexPath {
                    if let cell = owner.buttonCollectionView.cellForItem(at: previousIndex) as? ColorButtonCell {
                        cell.selectedButton(isSelected: false)
                    }
                }

                if previousButtonIndex == nil {
                    if let cell = owner.buttonCollectionView.cellForItem(at: indexPath) as? ColorButtonCell {
                        cell.selectedButton(isSelected: true)
                    }
                }
                owner.selectedButtonIndex.accept(indexPath)
            }
            .disposed(by: disposeBag)

        buttonCollectionView.rx.modelSelected(ColorSet.self)
            .bind(with: self) { owner, value in
                if owner.selectedModel.value == nil {
                    owner.selectedModel.accept(value)
                    colorType.onNext(value.rawValue)
                } else {
                    if let previousModel = owner.selectedModel.value, previousModel.rawValue == value.rawValue {
                        owner.selectedModel.accept(nil)
                        colorType.onNext(nil)
                    }
                }
            }
            .disposed(by: disposeBag)


        output.searchResult
            .bind(to: photoCollectionView.rx.items(cellIdentifier: PhotoResultCell.identifier, cellType: PhotoResultCell.self)) { row, element, cell in
                cell.configureCell(with: element)
            }
            .disposed(by: disposeBag)

        output.phLabelShouldHidden
            .bind(to: phLabel.rx.isHidden)
            .disposed(by: disposeBag)

        output.scrollGoToTop
            .bind(with: self) { owner, _ in
                DispatchQueue.main.async {
                    owner.photoCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }

    private func sortButtonToggle() {
        sortButton.isSelected.toggle()
    }

    private func addObserverNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(valueChanged),
                                               name: .isUpdateLikeList,
                                               object: nil)
    }

    private func showPlaceHolderLabel() {
        if searchPhotoData.results.count == 0 {
            phLabel.text = "검색 결과가 없어요"
            phLabel.isHidden = false
        } else {
            phLabel.isHidden = true
        }
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

// MARK: Setup UI
extension SearchPhotoVC {
    private func setupSearchController() {
        searchController.searchBar.placeholder = "키워드 검색"
        searchController.automaticallyShowsCancelButton = false
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

    private func setupNav() {
        navigationItem.title = "SEARCH PHOTO"
        navigationController?.navigationBar.scrollEdgeAppearance = .init()
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

        layout.itemSize = .init(width: 80, height: 34)

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

    private func updatePhotoCollectionViewLayout() {
        typealias quantity = PhotoCollectionViewQuantity

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = quantity.lineSpacing.value
        layout.minimumInteritemSpacing = quantity.itemSpacing.value
        layout.sectionInset = .init(top: quantity.topInset.value,
                                    left: quantity.leadingInset.value,
                                    bottom: quantity.bottomInset.value,
                                    right: quantity.trailingInset.value)

        let deviceHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let deviceWidth = view.safeAreaLayoutGuide.layoutFrame.width

        let cellHeight = (deviceHeight - (quantity.lineSpacing.value * 2)) / 2.5
        let cellWidth = (deviceWidth - (quantity.itemSpacing.value)) / 2

        layout.itemSize = .init(width: cellWidth, height: cellHeight)

        photoCollectionView.collectionViewLayout = layout
        photoCollectionView.collectionViewLayout.invalidateLayout()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSizeHeight = self.photoCollectionView.contentSize.height
        let collectionViewHeight = self.photoCollectionView.bounds.height
        let offset = scrollView.contentOffset

        guard contentSizeHeight > collectionViewHeight else { return
            viewModel.isInfiniteScroll = false
        }

        if offset.y > (contentSizeHeight - collectionViewHeight - 400), !viewModel.isInfiniteScroll {
            throttle.run { [weak self] in
                guard let self else { return }
                self.scrollDidChangeTrigger.accept(())
            }
        }
    }
}

extension Reactive where Base: UIButton {
    var buttonState: Observable<Bool> {
        return base.rx.tap.map { _ in
            return base.isSelected
        }
    }
}

//MARK: 버튼 컬렉션뷰를 위한 수치
extension SearchPhotoVC {
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
}

//MARK: 사진 컬렉션뷰를 위한 수치
extension SearchPhotoVC {
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
}
