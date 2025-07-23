//
//  CheckBoxHeaderView.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import UIKit

protocol CheckBoxHeaderViewDelegate: AnyObject {
    func didStartSearch(text: String)
}

final class CheckBoxHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(name: .MontserratRegular, size: 12)
        label.textColor = .headerGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField: UITextField = .init()
        textField.borderStyle = .none
        textField.backgroundColor = .searchBackground
        textField.font = .custom(name: .MontserratMedium, size: 12)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        
        textField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.searchGray, NSAttributedString.Key.font:UIFont.custom(name: .MontserratMedium, size: 12)])
        
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
    
    private weak var delegate: CheckBoxHeaderViewDelegate?

    init(title: String?,
         delegate: CheckBoxHeaderViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = .backgroundWhite
        titleLabel.text = title
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -16).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchTextField.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
}

// MARK: - Serach Stuff
extension CheckBoxHeaderView: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        let spaceDeletedText = (searchTextField.text?.replacingOccurrences(of: " ", with: "") ?? "")
        if spaceDeletedText != "",
           spaceDeletedText.count > 1 {
            delegate?.didStartSearch(text: spaceDeletedText)
        } else {
            delegate?.didStartSearch(text: "")
        }
        
    }
    
}
