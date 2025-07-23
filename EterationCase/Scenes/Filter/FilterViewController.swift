//
//  FilterViewController.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import UIKit

protocol FilterViewModelDelegate: AnyObject {
    func loadingStatus(isLoading: Bool)
    func reloadData()
    func showAlert(with message: String)
    func closeView()
}

final class FilterViewController: BaseViewController {
    private lazy var statusBarView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .backgroundWhite
        return view
    }()
    
    private lazy var navigationView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .backgroundWhite
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0,
                                         height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .textBlack
        button.setImage(.iconCloseOutline, for: .normal)
        button.addTarget(self, action: #selector(didPressBackButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = .textBlack
        label.font = .custom(name: .MontserratLight, size: 20)
        label.text = "Filter"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var applyButton: UIButton = {
        let button: UIButton = .init()
        button.backgroundColor = .baseBlue
        button.titleLabel?.font = .custom(name: .MontserratBold, size: 18)
        button.setTitleColor(.backgroundWhite, for: .normal)
        button.setTitle("Apply", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didPressApplyButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let view: UITableView = .init(frame: .zero,
                                      style: .plain)
        view.sectionHeaderTopPadding = 0.0
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(FilterMainTableViewCell.self,
                      forCellReuseIdentifier: FilterMainTableViewCell.reuseIdentifier)
        view.estimatedRowHeight = 60
        view.contentInset = .init(top: 10, left: 0,
                                  bottom: 0, right: 0)
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        return view
    }()
    
    private let viewModel: FilterViewModel
    
    init(viewModel: FilterViewModel) {
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
        addKeyboardObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.generateSections()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUI() {
        view.backgroundColor = .backgroundWhite
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
        navigationView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(closeButton)
        closeButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 16).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        
        navigationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(navigationTitleLabel)
        navigationTitleLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor).isActive = true
        navigationTitleLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 36).isActive = true
        navigationTitleLabel.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -74).isActive = true
        
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
        applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        applyButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
 
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        DispatchQueue.main.async {
            let bottomOffset = CGPoint(x: 0, y: keyboardSize.height*0.6)
            self.tableView.setContentOffset(bottomOffset, animated: true)
        }

    }

    @objc private func keyboardWillHide() {
        DispatchQueue.main.async {
            let bottomOffset = CGPoint(x: 0, y: 0)
            self.tableView.setContentOffset(bottomOffset, animated: true)
        }
        
    }
    
    @objc func didPressBackButton() {
        closeView()
    }
    
    @objc func didPressApplyButton() {
        viewModel.didPressApply()
    }
    
}

extension FilterViewController: UITableViewDelegate,
                                UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionCount()
    }
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCount(for: section)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterMainTableViewCell.reuseIdentifier, for: indexPath) as? FilterMainTableViewCell
        else { return UITableViewCell() }
        
        cell.populate(with: viewModel.getCellData(for: indexPath),
                      delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = viewModel.getSectionType(for: indexPath.section)
        switch type {
        case .sort:
            let sortCellHeight: CGFloat = 40
            let sortHeaderHeight: CGFloat = 34
            let totalInnerCellHeight: CGFloat = CGFloat(viewModel.getCellData(for: indexPath).titles.count) * sortCellHeight
            let totalHeight: CGFloat = totalInnerCellHeight + sortHeaderHeight
            return totalHeight
        case .brand:
            let brandCellHeight: CGFloat = 40
            let brandHeaderHeight: CGFloat = 86
            let totalInnerCellHeight: CGFloat = brandCellHeight * 3
            let totalHeight: CGFloat = totalInnerCellHeight + brandHeaderHeight
            
            return totalHeight
        case .model:
            let modelCellHeight: CGFloat = 40
            let modelHeaderHeight: CGFloat = 86
            let totalInnerCellHeight: CGFloat = modelCellHeight * 3
            let totalHeight: CGFloat = totalInnerCellHeight + modelHeaderHeight
            
            return totalHeight
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        guard section != tableView.numberOfSections - 1
        else { return nil }
        
        let footerView: UIView = .init()
        footerView.backgroundColor = .backgroundWhite
        
        let separator: UIView = .init()
        separator.backgroundColor = .textBlack
        separator.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(separator)
        separator.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20).isActive = true
        separator.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        return footerView
    }
    
}

extension FilterViewController: FilterViewModelDelegate {
    func loadingStatus(isLoading: Bool) {
        isLoading ? showProgressHUD() : hideProgressHUD()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func showAlert(with message: String) {
        showSimpleAlert(with: message)
    }
    
    func closeView() {
        dismiss(animated: true)
    }
    
}

extension FilterViewController: FilterMainTableViewCellDelegate {
    func didSelectCell(for type: FilterMainTypes,
                       title: String) {
        viewModel.didSelectFilter(for: type,
                                  title: title)
    }
    
    func didDeselectCell(for type: FilterMainTypes,
                         title: String) {
        viewModel.didDeselectFilter(for: type,
                                    title: title)
    }
    
}
