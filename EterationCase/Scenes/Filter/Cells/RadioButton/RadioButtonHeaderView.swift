//
//  RadioButtonHeaderView.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import UIKit

final class RadioButtonHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(name: .MontserratRegular, size: 12)
        label.textColor = .headerGray
        label.textAlignment = .left
        return label
    }()

    init(title: String?) {
        super.init(frame: .zero)
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
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
