//
//  CartViewController.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import UIKit

protocol CarViewModelDelegate: AnyObject {
    func loadingStatus(isLoading: Bool)
    func reloadData()
    func showAlert(with message: String)
}

final class CartViewController: BaseViewController {
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
    
    private lazy var tableView: UITableView = {
        let view: UITableView = .init(frame: .zero,
                                      style: .plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(CartTableViewCell.self,
                      forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        view.estimatedRowHeight = 60
        view.contentInset = .init(top: 10, left: 0,
                                  bottom: 100, right: 0)
        return view
    }()
    
    private lazy var totalContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .backgroundWhite
        return view
    }()
    
    private lazy var totalStackView: UIStackView = {
        let view: UIStackView = .init()
        view.axis = .vertical
        view.spacing = 8
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .custom(name: .MontserratRegular, size: 18)
        label.textAlignment = .left
        label.textColor = .baseBlue
        label.text = "Total:"
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label: UILabel = .init()
        label.textAlignment = .left
        label.font = .custom(name: .MontserratBold, size: 18)
        label.textColor = .textBlack
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button: UIButton = .init()
        button.backgroundColor = .baseBlue
        button.titleLabel?.font = .custom(name: .MontserratBold, size: 18)
        button.setTitleColor(.backgroundWhite, for: .normal)
        button.setTitle("Complete", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didPressCompleteButton),
                         for: .touchUpInside)
        return button
    }()
    
    private let viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
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
        viewModel.getCartProducts()
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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        totalContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(totalContainerView)
        totalContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        totalContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        totalContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        view.bringSubviewToFront(totalContainerView)
        
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        totalContainerView.addSubview(completeButton)
        completeButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        completeButton.widthAnchor.constraint(equalToConstant: 182).isActive = true
        completeButton.bottomAnchor.constraint(equalTo: totalContainerView.bottomAnchor, constant: -22).isActive = true
        completeButton.trailingAnchor.constraint(equalTo: totalContainerView.trailingAnchor,
                                                  constant: -16).isActive = true
        view.bringSubviewToFront(completeButton)
        
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        totalContainerView.addSubview(totalStackView)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.addArrangedSubview(totalLabel)
        totalStackView.addArrangedSubview(totalPriceLabel)
        totalStackView.leadingAnchor.constraint(equalTo: totalContainerView.leadingAnchor, constant: 16).isActive = true
        totalStackView.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -16).isActive = true
        totalStackView.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor).isActive = true
        view.bringSubviewToFront(totalStackView)
        totalStackView.topAnchor.constraint(equalTo: totalContainerView.topAnchor, constant: 16).isActive = true
    }
    
    @objc func didPressCompleteButton() {
        showCompleteAlert()
    }
    
    private func showCompleteAlert() {
        let alertContoller = UIAlertController(title: "E-Market",
                                               message: "Do you want to complete your order?",
                                               preferredStyle: .alert)
        alertContoller.addAction(UIAlertAction(title: "Cancel",
                                               style: .default,
                                               handler: nil))
        alertContoller.addAction(UIAlertAction(title: "Complete",
                                               style: .default,
                                               handler: { [weak self] _ in
            guard let self = self
            else { return }
            
            self.viewModel.completeShopping()
        }))
        
        present(alertContoller, animated: true)
    }
    
}

//MARK: - TableView Stuff
extension CartViewController: UITableViewDelegate,
                              UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCont()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell
        else { return UITableViewCell() }
        
        cell.populate(with: viewModel.getCellData(for: indexPath.row),
                      delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel.deleteProduct(at: indexPath.row)
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
}

// MARK: - Cell Delegate
extension CartViewController: CartTableViewCellDelegate {
    func didPressAddButton(for id: Int) {
        viewModel.didPressAddButton(for: id)
    }
    
    func didPressReduceButton(for id: Int) {
        viewModel.didPressReduceButton(for: id)
    }
    
}

// MARK: - VM Delegate
extension CartViewController: CarViewModelDelegate {
    func loadingStatus(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.showProgressHUD() : self.hideProgressHUD()
        }
        
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.totalPriceLabel.text = self.viewModel.getTotalPrice().getPrice()
        }
        
    }
    
    func showAlert(with message: String) {
        showSimpleAlert(with: message)
    }
    
}
