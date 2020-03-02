//
//  NewDocumentTypeViewController.swift
//  zScanner
//
//  Created by Jakub Skořepa on 01/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import RxSwift

protocol NewDocumentTypeCoordinator: BaseCoordinator {
    func showSelector<T: ListItem>(for list: ListPickerField<T>)
    func saveFields(_ fields: [FormField])
    func showNextStep()
}

// MARK: -
class NewDocumentTypeViewController: BaseViewController {
    
    // MARK: Instance part
    private unowned let coordinator: NewDocumentTypeCoordinator
    private let viewModel: NewDocumentTypeViewModel
    
    init(viewModel: NewDocumentTypeViewModel, coordinator: NewDocumentTypeCoordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(coordinator: coordinator)
    }
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    // MARK: Helpers
    private let disposeBag = DisposeBag()
    private var fieldsDisposeBag = DisposeBag()
    
    private func setupBindings() {
        viewModel.fields.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.fieldsDisposeBag = DisposeBag()
            
            self.tableView.reloadData()
            
            self.viewModel.isValid
                .bind(to: self.continueButton.rx.isEnabled)
                .disposed(by: self.fieldsDisposeBag)
        })
        .disposed(by: self.disposeBag)
 
        continueButton.rx.tap
            .do(onNext: { [unowned self] in
                self.tableView.visibleCells.forEach({ ($0 as? TextInputTableViewCell)?.enableSelection() })
            })
            .subscribe(onNext: { [unowned self] in
                self.coordinator.saveFields(self.viewModel.fields.value)
                self.coordinator.showNextStep()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        navigationItem.title = viewModel.folderName
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.right.bottom.left.equalTo(safeArea).inset(20)
            make.height.equalTo(44)
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(FormFieldTableViewCell.self)
        tableView.registerCell(TextInputTableViewCell.self)
        tableView.registerCell(DateTimePickerTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var continueButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("newDocumentType.button.title".localized, for: .normal)
        return button
    }()
    
    private lazy var documentTypesHeaderView = TitleView(title: "form.listPicker.title".localized)
}

// MARK: - UITableViewDataSource implementation
extension NewDocumentTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fields.value.count
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.fields.value[indexPath.row]
        
        switch item {
        case let list as ListPickerField<DocumentTypeDomainModel>:
            let cell = tableView.dequeueCell(FormFieldTableViewCell.self)
            cell.setup(with: list)
            return cell
        case let list as ListPickerField<DocumentSubTypeDomainModel>:
            let cell = tableView.dequeueCell(FormFieldTableViewCell.self)
            cell.setup(with: list)
            return cell
        case let text as TextInputField:
            let cell = tableView.dequeueCell(TextInputTableViewCell.self)
            cell.setup(with: text)
            return cell
        case let date as DateTimePickerField:
            let cell = tableView.dequeueCell(FormFieldTableViewCell.self)
            cell.setup(with: date)
            return cell
        case let datePicker as DateTimePickerPlaceholder:
            let cell = tableView.dequeueCell(DateTimePickerTableViewCell.self)
            cell.setup(with: datePicker)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate implementation
extension NewDocumentTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.fields.value[indexPath.row]
        
        // Remove focus from textField is user select different cell
        tableView.visibleCells.forEach({ ($0 as? TextInputTableViewCell)?.enableSelection() })
        
        switch item {
        case let list as ListPickerField<DocumentTypeDomainModel>:
            coordinator.showSelector(for: list)
            
        case let list as ListPickerField<DocumentSubTypeDomainModel>:
            coordinator.showSelector(for: list)
            
        case is TextInputField:
            if let cell = tableView.cellForRow(at: indexPath) as? TextInputTableViewCell {
                cell.enableTextEdit()
            }
            
        default:
            break
        }
    }
}
