//
//  ListItemSelectionViewController.swift
//  zScanner
//
//  Created by Jakub Skořepa on 05/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

protocol ListItemSelectionCoordinator: BaseCoordinator {}

// MARK: -
class ListItemSelectionViewController<T: ListItem>: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Instance part
    private unowned let coordinator: ListItemSelectionCoordinator
    private let viewModel: ListPickerField<T>
    
    init(viewModel: ListPickerField<T>, coordinator: ListItemSelectionCoordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(coordinator: coordinator)
    }
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    // MARK: Helpers
    private func setupView() {
        navigationItem.title = viewModel.title
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(UITableViewCell.self)
        return tableView
    }()

    // MARK: - UITableViewDataSource implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.list[indexPath.row]
        let cell = tableView.dequeueCell(UITableViewCell.self)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = item.title
        return cell
    }
    
    // MARK: - UITableViewDelegate implementation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.list[indexPath.row]
        viewModel.selected.accept(item)
        coordinator.backButtonPressed(sender: self)
    }
}
