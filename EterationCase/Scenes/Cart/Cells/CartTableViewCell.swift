//
//  CartTableViewCell.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func didPressAddButton(for id: Int)
    func didPressReduceButton(for id: Int)
}

final class CartTableViewCell: UITableViewCell {
    private lazy var horizontalStackView: UIStackView = {
        let view: UIStackView = .init()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let view: UIStackView = .init()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 0
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let view: UIStackView = .init()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 8
        return view
    }()
    
    private lazy var productTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .custom(name: .MontserratRegular, size: 16)
        label.textColor = .textBlack
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .custom(name: .MontserratMedium, size: 13)
        label.textColor = .baseBlue
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("+", for: .normal)
        button.backgroundColor = .searchBackground
        button.setTitleColor(.searchGray, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMaxXMaxYCorner,
                                      .layerMaxXMinYCorner]
        button.tintColor = .searchGray
        return button
    }()
    
    private lazy var reduceButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("-", for: .normal)
        button.backgroundColor = .searchBackground
        button.setTitleColor(.searchGray, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMinXMinYCorner,
                                      .layerMinXMaxYCorner]
        button.tintColor = .searchGray
        return button
    }()

    private lazy var productQuantityLabel: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .custom(name: .MontserratRegular, size: 18)
        label.textColor = .backgroundWhite
        label.backgroundColor = .baseBlue
        return label
    }()
    
    private weak var delegate: CartTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    private func setUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setLayout() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        reduceButton.translatesAutoresizingMaskIntoConstraints = false
        reduceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        reduceButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonStackView.addArrangedSubview(reduceButton)
        productQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        productQuantityLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        productQuantityLabel.widthAnchor.constraint(equalToConstant: 56).isActive = true
        buttonStackView.addArrangedSubview(productQuantityLabel)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonStackView.addArrangedSubview(addButton)
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.addArrangedSubview(productTitleLabel)
        titleStackView.addArrangedSubview(productPriceLabel)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(titleStackView)
        horizontalStackView.addArrangedSubview(buttonStackView)
        horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func addTargets() {
        reduceButton.addTarget(self, action: #selector(didPressReduceButton(_:)),
                               for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didPressAddButton(_:)),
                            for: .touchUpInside)
    }
    
    @objc func didPressAddButton(_ sender: UIButton) {
        guard let id = sender.itemId
        else { return }
        
        delegate?.didPressAddButton(for: id)
    }
    
    @objc func didPressReduceButton(_ sender: UIButton) {
        guard let id = sender.itemId
        else { return }
        
        delegate?.didPressReduceButton(for: id)
    }
    
    func populate(with data: CartModel,
                  delegate: CartTableViewCellDelegate) {
        self.delegate = delegate
        addButton.itemId = data.id
        reduceButton.itemId = data.id
        productTitleLabel.text = data.product?.name
        productPriceLabel.text = String((data.product?.price ?? 0).getPrice())
        productQuantityLabel.text = String(data.quantity)
    }
    
}
