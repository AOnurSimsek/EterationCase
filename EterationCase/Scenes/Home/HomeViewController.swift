//
//  HomeViewController.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func loadingStatus(isLoading: Bool)
    func reloadData()
    func showAlert(with message: String)
}

final class HomeViewController:  BaseViewController {
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
    
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = .init()
        textField.borderStyle = .none
        textField.backgroundColor = .searchBackground
        textField.font = .custom(name: .MontserratRegular, size: 16)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        
        textField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.searchGray, NSAttributedString.Key.font:UIFont.custom(name: .MontserratMedium, size: 18)])
        
        let leftContainerView: UIView = .init(frame: CGRect(x: 0, y: 0,
                                                            width: 44, height: 24))
        let searchIconImageView: UIImageView = .init(image: .search)
        searchIconImageView.contentMode = .scaleAspectFit
        searchIconImageView.frame = CGRect(x: 12, y: 4,
                                           width: 16.5, height: 17.5)
        leftContainerView.addSubview(searchIconImageView)
        textField.leftView = leftContainerView
        textField.leftViewMode = .always
        
        let rightPaddingView: UIView = .init(frame: CGRect(x: 0, y: 0,
                                                           width: 24, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .unlessEditing
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange),
                            for: .editingChanged)
        return textField
    }()
    
    private lazy var filterLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .custom(name: .MontserratMedium, size: 18)
        label.textColor = .textBlack
        label.textAlignment = .left
        label.text = "Filters:"
        return label
    }()
    
    private lazy var filterButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("Select Filter", for: .normal)
        button.setTitleColor(.textBlack, for: .normal)
        button.titleLabel?.font = .custom(name: .MontserratRegular, size: 14)
        button.backgroundColor = .baseGray
        button.addTarget(self, action: #selector(didPressSelectFilter),
                         for: .touchUpInside)
        return button
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
    
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
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
        viewModel.getProductData()
    }
    
    private func setUI() {
        view.backgroundColor = .backgroundWhite
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
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 14).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 14).isActive = true
        filterButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 158).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterLabel)
        filterLabel.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor).isActive = true
        filterLabel.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor).isActive = true
        filterLabel.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -16).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 24).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func didPressSelectFilter() {
        let viewModel: FilterViewModelImp = .init(productData: viewModel.getAllproductData(),
                                                  selectedFilters: viewModel.getSelectedFilters(),
                                                  delegate: self)
        let viewController: FilterViewController = .init(viewModel: viewModel)
        viewModel.setView(viewController)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
    
    private func routetoProductDetail(for productId: Int) {
        let service: CoreDataService = CoreDataManager.shared
        let productDetailViewModel: ProductDetailViewModelImpl = .init(data: viewModel.getCellData(for: productId),
                                                                       coreDataService: service)
        let productDetailController: ProductDetailViewController = .init(viewModel: productDetailViewModel)
        productDetailViewModel.setView(productDetailController)
        navigationController?.pushViewController(productDetailController, animated: true)
    }
    
}

// MARK: - CollectionView Stuff
extension HomeViewController: UICollectionViewDelegate,
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
extension HomeViewController: ProductCollectionViewCellDelegate {
    func didPressAddtoCart(for id: Int) {
        viewModel.didPressAddtoCart(for: id)
    }
    
    func didPressAddtoFavorite(for id: Int) {
        viewModel.didPressFavorite(for: id)
    }
    
}

// MARK: - TextField
extension HomeViewController: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        guard let text = searchTextField.text
        else { return }
        
        viewModel.searchTextAdded(text: text)
    }
    
}

extension HomeViewController: FilterDelegate {
    func didPressedApply(selectedFilters: [FilterModel]) {
        viewModel.didSelectFilter(selections: selectedFilters)
    }
    
}

// MARK: - VM Delegates
extension HomeViewController: HomeViewModelDelegate {
    func loadingStatus(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.showProgressHUD() : self.hideProgressHUD()
        }
        
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showAlert(with message: String) {
        showSimpleAlert(with: message)
    }
    
}
