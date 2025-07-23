//
//  FilterMainTableViewCell.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import UIKit

protocol FilterMainTableViewCellDelegate: AnyObject {
    func didSelectCell(for type: FilterMainTypes,
                       title: String)
    func didDeselectCell(for type: FilterMainTypes,
                         title: String)
}

final class FilterMainTableViewCell: UITableViewCell {
    private lazy var tableView: UITableView = {
        let view: UITableView = .init(frame: .zero,
                                      style: .plain)
        view.sectionHeaderTopPadding = 0.0
        view.bounces = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(FilterCheckboxTableViewCell.self,
                      forCellReuseIdentifier: FilterCheckboxTableViewCell.reuseIdentifier)
        view.register(FilterRadioButtonCell.self,
                      forCellReuseIdentifier: FilterRadioButtonCell.reuseIdentifier)
        view.allowsMultipleSelection = true
        return view
    }()
    
    private var dataModel: FilterModel?
    private var filteredDataModel: FilterModel?
    
    private var searchQueue: DispatchQueue = .init(label: "search.filter.queue",
                                                   qos: .userInitiated)
    private var searchTask: DispatchWorkItem?
    
    private weak var delegate: FilterMainTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    private func reloadCell(with data: FilterModel?) {
        guard let model = data
        else { return }
        
        self.filteredDataModel = model
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setSelections(with: model.selectedFilters ?? [])
        }
        
    }
    
    func populate(with model: FilterModel,
                  delegate: FilterMainTableViewCellDelegate) {
        self.delegate = delegate
        dataModel = model
        filteredDataModel = model
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setSelections(with: model.selectedFilters ?? [])
        }
        
    }
    
}

extension FilterMainTableViewCell: UITableViewDelegate,
                                   UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return filteredDataModel?.titles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch filteredDataModel?.type {
        case .sort:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterRadioButtonCell.reuseIdentifier, for: indexPath) as? FilterRadioButtonCell,
                    indexPath.row < filteredDataModel?.titles.count ?? 0
            else { return UITableViewCell() }
            
            cell.populate(with: filteredDataModel?.titles[indexPath.row])
            return cell
        case .brand,
             .model:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCheckboxTableViewCell.reuseIdentifier, for: indexPath) as? FilterCheckboxTableViewCell
            else { return UITableViewCell() }
            
            cell.populate(with: filteredDataModel?.titles[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        switch filteredDataModel?.type {
        case .sort:
            let headerView: RadioButtonHeaderView = .init(title: filteredDataModel?.type.title)
            return headerView
        case .brand,
             .model:
            let headerView: CheckBoxHeaderView = .init(title: filteredDataModel?.type.title,
                                                       delegate: self)
            return headerView
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        switch filteredDataModel?.type {
        case .sort:
            return 34
        case .brand,
             .model:
            return 86
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let type = filteredDataModel?.type
        else { return }
        
        let title: String = filteredDataModel?.titles[indexPath.row] ?? ""
        filteredDataModel?.selectedFilters?.append(title)
        delegate?.didSelectCell(for: type,
                                title: filteredDataModel?.titles[indexPath.row] ?? "")
    }
    
    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath) {
        guard let type = filteredDataModel?.type
        else { return }
        
        let title: String = filteredDataModel?.titles[indexPath.row] ?? "-"
        if let firstIndex = filteredDataModel?.selectedFilters?.firstIndex(of: title) {
            filteredDataModel?.selectedFilters?.remove(at: firstIndex)
        }
        
        delegate?.didDeselectCell(for: type,
                                  title: filteredDataModel?.titles[indexPath.row] ?? "")
    }
    
    func tableView(_ tableView: UITableView,
                   willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch filteredDataModel?.type {
        case .sort:
            guard let selectedIndex = tableView.indexPathForSelectedRow
            else { return indexPath }
            
            tableView.deselectRow(at: selectedIndex,
                                  animated: false)
            
            filteredDataModel?.selectedFilters = []
            delegate?.didDeselectCell(for: .sort,
                                      title: filteredDataModel?.titles[selectedIndex.row] ?? "")
            return indexPath
        default:
            return indexPath
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        switch filteredDataModel?.type {
        case .sort:
            return nil
        default:
            return indexPath
        }
        
    }
    
    private func setSelections(with titles: [String]) {
        guard !titles.isEmpty
        else { return }
        
        let selectedIndexes: [Int] = titles.compactMap { title in
            guard let index = filteredDataModel?.titles.firstIndex(where: { $0 == title})
            else { return nil }
            
            return index
        }

        selectedIndexes.forEach {
            self.tableView.selectRow(at: .init(row: $0, section: 0),
                                     animated: false,
                                     scrollPosition: .top)
        }
            
    }
    
}

extension FilterMainTableViewCell:CheckBoxHeaderViewDelegate {
    func didStartSearch(text: String) {
        searchTask?.cancel()
        guard text != ""
        else {
            dataModel?.selectedFilters = filteredDataModel?.selectedFilters
            reloadCell(with: dataModel)
            return
        }
        
        let searchTask: DispatchWorkItem = .init {
            let filteredTitles = self.dataModel?.titles.filter { ($0).localizedCaseInsensitiveContains(text)} ?? []
            self.filteredDataModel?.titles = filteredTitles
            self.reloadCell(with: self.filteredDataModel)
        }
        
        self.searchTask = searchTask
        searchQueue.asyncAfter(deadline: .now() + .milliseconds(200),
                               execute: searchTask)
    }
    
}
