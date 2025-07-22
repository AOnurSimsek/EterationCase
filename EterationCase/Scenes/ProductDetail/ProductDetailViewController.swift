//
//  ProductDetailViewController.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import UIKit

protocol ProductDetailViewModelDelegate: AnyObject {
    func reloadData(with data: ProductModel)
    func loadingStatus(isLoading: Bool)
}

final class ProductDetailViewController: BaseViewController {
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
    
    private lazy var backButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .backgroundWhite
        button.setImage(.iconArrowBack, for: .normal)
        button.addTarget(self, action: #selector(didPressBackButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .backgroundWhite
        label.font = .custom(name: .MontserratExtraBold, size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var scrollContentView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("",
                        for: .normal)
        button.tintColor = .clear
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didpressFavoriteButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var productTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .left
        label.textColor = .textBlack
        label.font = .custom(name: .MontserratExtraBold, size: 18)
        return label
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 0
        label.font = .custom(name: .MontserratRegular, size: 14)
        label.textColor = .textBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .backgroundWhite
        return view
    }()
    
    private lazy var priceStackView: UIStackView = {
        let view: UIStackView = .init()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .custom(name: .MontserratRegular, size: 18)
        label.textAlignment = .left
        label.textColor = .baseBlue
        label.text = "Price:"
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .left
        label.font = .custom(name: .MontserratBold, size: 18)
        label.textColor = .textBlack
        return label
    }()
    
    private lazy var addtoCartButton: UIButton = {
        let button: UIButton = .init()
        button.backgroundColor = .baseBlue
        button.titleLabel?.font = .custom(name: .MontserratBold, size: 18)
        button.setTitleColor(.backgroundWhite, for: .normal)
        button.setTitle("Add to Cart", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didPressAddtoCartButton),
                         for: .touchUpInside)
        return button
    }()
    
    private let viewModel: ProductDetailViewModel
    
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setUI()
        setLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getProductData()
    }
    
    private func setUI() {
        view.backgroundColor = .backgroundWhite
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setLayout() {
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusBarView)
        statusBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        
        navigationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(navigationTitleLabel)
        navigationTitleLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        navigationTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 36).isActive = true
        navigationTitleLabel.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -74).isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollContentView)
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 16).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
        productImageView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16).isActive = true
        productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 0.75).isActive = true
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(favoriteButton)
        favoriteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 10).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -10).isActive = true
        productImageView.bringSubviewToFront(favoriteButton)
        
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(productTitleLabel)
        productTitleLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor).isActive = true
        productTitleLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor).isActive = true
        productTitleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16).isActive = true
        
        productDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(productDescriptionLabel)
        productDescriptionLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 16).isActive = true
        productDescriptionLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor).isActive = true
        productDescriptionLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor).isActive = true
        
        
        priceContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceContainerView)
        priceContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        priceContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        priceContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.bringSubviewToFront(priceContainerView)
        
        addtoCartButton.translatesAutoresizingMaskIntoConstraints = false
        priceContainerView.addSubview(addtoCartButton)
        addtoCartButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        addtoCartButton.widthAnchor.constraint(equalToConstant: 182).isActive = true
        addtoCartButton.bottomAnchor.constraint(equalTo: priceContainerView.bottomAnchor, constant: -22).isActive = true
        addtoCartButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor).isActive = true
        view.bringSubviewToFront(addtoCartButton)
        
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        priceContainerView.addSubview(priceStackView)
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.addArrangedSubview(priceTitleLabel)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor, constant: 16).isActive = true
        priceStackView.trailingAnchor.constraint(equalTo: addtoCartButton.leadingAnchor, constant: -16).isActive = true
        priceStackView.centerYAnchor.constraint(equalTo: addtoCartButton.centerYAnchor).isActive = true
        view.bringSubviewToFront(priceStackView)
        priceStackView.topAnchor.constraint(equalTo: priceContainerView.topAnchor, constant: 16).isActive = true
        
        scrollContentView.bottomAnchor.constraint(greaterThanOrEqualTo: productDescriptionLabel.bottomAnchor, constant: 200).isActive = true
    }
    
    @objc func didpressFavoriteButton() {
        viewModel.didPressAddtoFavorite()
        favoriteButton.respondtoTap(responseType: .getBigger)
    }
    
    @objc func didPressAddtoCartButton() {
        viewModel.didPressAddtoCart()
        addtoCartButton.respondtoTap(responseType: .getSmaller)
    }
    
    @objc func didPressBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProductDetailViewController: ProductDetailViewModelDelegate {
    func reloadData(with data: ProductModel) {
        navigationTitleLabel.text = data.name
        productImageView.setImage(path: data.image)
        productTitleLabel.text = data.name
        productDescriptionLabel.text = (data.brand ?? "") + "\n" + (data.description ?? "")
        priceLabel.text = (data.price ?? 0).getPrice()
        favoriteButton.setImage(data.isFavorite ? .starFilled : .starEmpty,
                                for: .normal)
    }
    
    func loadingStatus(isLoading: Bool) {
        isLoading ? showProgressHUD() : hideProgressHUD()
    }
    
}
