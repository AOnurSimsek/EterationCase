//
//  FavoritesViewController.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import UIKit

protocol FavoriteViewModelDelegate: AnyObject {
    func loadingStatus(isLoading: Bool)
    func reloadData()
    func showAlert(with message: String)
}

final class FavoritesViewController: BaseViewController {
    private lazy var statusBarView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .baseBlue
        return view
    }()
    
    private lazy var navigationView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .baseBlue
        return view
    }()
    
    private lazy var appTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .backgroundWhite
        label.font = .custom(name: .MontserratExtraBold, size: 24)
        label.textAlignment = .left
        label.text = "E-Market"
        return label
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16,
                                               bottom: 16, right: 16)
        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var emptyView: EmptyView = .init(type: .favorite)
    
    private let viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setLayout()
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getFavoriteProducts()
    }
    
    private func setUI() {
        view.backgroundColor = .backgroundWhite
        emptyView.isHidden = true
        collectionView.isHidden = true
    }
    
    private func setLayout() {
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusBarView)
        statusBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(appTitleLabel)
        appTitleLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        appTitleLabel.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16).isActive = true
        appTitleLabel.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -16).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 24).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
    }
    
    private func routetoProductDetail(for productId: Int) {
        let service: CoreDataService = CoreDataManager.shared
        let productDetailViewModel: ProductDetailViewModelImpl = .init(data: viewModel.getCellData(for: productId),
                                                                       coreDataService: service)
        let productDetailController: ProductDetailViewController = .init(viewModel: productDetailViewModel)
        productDetailViewModel.setView(productDetailController)
        navigationController?.pushViewController(productDetailController, animated: true)
    }
    
    private func setEmptyView(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
    
}

// MARK: - CollectionView Stuff
extension FavoritesViewController: UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.getRowCont()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.populate(with: viewModel.getCellData(for: indexPath.row),
                      delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        routetoProductDetail(for: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let spacing: CGFloat = 16 + 16 + 16
        let availableCellWidth: CGFloat = (width - spacing)/2
        return .init(width: availableCellWidth,
                     height: 302)
    }
    
}

// MARK: - Cell Delegates
extension FavoritesViewController: ProductCollectionViewCellDelegate {
    func didPressAddtoCart(for id: Int) {
        viewModel.didPressAddtoCart(for: id)
    }
    
    func didPressAddtoFavorite(for id: Int) {
        viewModel.didPressFavorite(for: id)
    }
    
}

// MARK: - VM Delegates
extension FavoritesViewController: FavoriteViewModelDelegate {
    func loadingStatus(isLoading: Bool) {
        isLoading ? showProgressHUD() : hideProgressHUD()
    }
    
    func reloadData() {
        let isEmpty = (viewModel.getRowCont() == 0)

        DispatchQueue.main.async {
            self.setEmptyView(isEmpty: isEmpty)
            self.collectionView.reloadData()
        }
    }
    
    func showAlert(with message: String) {
        showSimpleAlert(with: message)
    }
    
}
