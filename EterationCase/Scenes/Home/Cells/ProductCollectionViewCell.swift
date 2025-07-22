//
//  ProductCollectionViewCell.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import UIKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    func didPressAddtoCart(for id: Int)
    func didPressAddtoFavorite(for id: Int)
}

final class ProductCollectionViewCell: UICollectionViewCell {
    private lazy var stackView: UIStackView = {
        let view: UIStackView = .init()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label : UILabel = .init()
        label.numberOfLines = 1
        label.font = .custom(name: .MontserratMedium,
                             size: 15)
        label.textAlignment = .left
        label.textColor = .baseBlue
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label: UILabel = .init()
        label.numberOfLines = 2
        label.font = .custom(name: .MontserratMedium,
                             size: 15)
        label.textAlignment = .left
        label.textColor = .textBlack
        return label
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("Add to Cart",
                        for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.titleLabel?.font = .custom(name: .MontserratRegular,
                                          size: 16)
        button.tintColor = .backgroundWhite
        button.backgroundColor = .baseBlue
        button.addTarget(self, action: #selector(didPressAddToCart),
                         for: .touchUpInside)
        return button
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
    
    private weak var delegate: ProductCollectionViewCellDelegate?
    private var itemId: Int?
    
    private func setLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        let imageAspectRatio = productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 480/640)
        imageAspectRatio.isActive = true
        imageAspectRatio.priority = UILayoutPriority(999)
        productImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        stackView.addArrangedSubview(productImageView)
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)
        favoriteButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -6).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 6).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        contentView.bringSubviewToFront(favoriteButton)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(priceLabel)
        
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(productNameLabel)
        
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        stackView.addArrangedSubview(addToCartButton)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        itemId = nil
        favoriteButton.setImage(nil, for: .normal)
        addToCartButton.transform = .identity
    }
        
    private func setUI() {
        contentView.backgroundColor = .backgroundWhite
        contentView.clipsToBounds = false
        contentView.layer.shadowColor = UIColor.textBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0,
                                                height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
    }
    
    func populate(with data: ProductModel,
                  delegate: ProductCollectionViewCellDelegate) {
        self.delegate = delegate
        itemId = data.id
        productImageView.setImage(path: data.image)
        priceLabel.text = (data.price ?? 0).getPrice()
        productNameLabel.text = data.name
        favoriteButton.setImage(data.isFavorite ? .starFilled : .starEmpty,
                                for: .normal)
    }
    
    @objc func didPressAddToCart() {
        guard let id = itemId
        else { return }
        
        delegate?.didPressAddtoCart(for: id)
        addToCartButton.respondtoTap()
    }
    
    @objc func didpressFavoriteButton() {
        guard let id = itemId
        else { return }
        
        delegate?.didPressAddtoFavorite(for: id)
    }
    
}
