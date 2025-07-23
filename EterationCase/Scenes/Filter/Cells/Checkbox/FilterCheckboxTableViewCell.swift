//
//  FilterCheckboxTableViewCell.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import UIKit

final class FilterCheckboxTableViewCell: UITableViewCell {
    private lazy var selectionImageView: UIImageView = {
        let view: UIImageView = .init()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .left
        label.font = .custom(name: .MontserratRegular, size: 14)
        label.textColor = .textBlack
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
        let image: UIImage = selected ? .checkboxFilled : .checkboxEmpty
        selectionImageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionImageView.image = nil
    }
    
    private func setUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setLayout() {
        selectionImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectionImageView)
        selectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        selectionImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        selectionImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        selectionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: selectionImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func populate(with title: String?) {
        titleLabel.text = title
    }
    
}
