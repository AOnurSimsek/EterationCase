//
//  EmptyView.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import UIKit

enum EmptyViewTypes {
    case favorite
    case cart
    
    var tilte: String {
        switch self {
        case .favorite:
            "Nothing here.\n Check out products and add some favorites to your list!"
        case .cart:
            "Nothing here.\n Check out products and add to your cart!"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .favorite:
            return .starEmpty.withTintColor(.headerGray)
        case .cart:
            return .iconBasketOutline.withTintColor(.headerGray)
        }
    }
    
}

final class EmptyView: UIView {
    private let imageView: UIImageView = {
        let view: UIImageView = .init()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(name: .MontserratRegular, size: 18)
        label.textColor = .headerGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(type: EmptyViewTypes) {
        super.init(frame: .zero)
        backgroundColor = .backgroundWhite
        imageView.image = type.image
        titleLabel.text = type.tilte
        setupLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
    }
    
}
