//
//  DocumentsListViewController.swift
//  zScanner
//
//  Created by Jakub Skořepa on 21/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import RxSwift

protocol DocumentsListCoordinator: BaseCoordinator {
    func createNewDocument(with department: DepartmentDomainModel)
    func openMenu()
}

class DocumentsListViewController: BaseViewController, ErrorHandling {
    
    // MARK: Instance part
    private unowned let coordinator: DocumentsListCoordinator
    private let documentsViewModel: DocumentsListViewModel
    private let departmentsViewModel: DepartmentsListViewModel
        
    init(documentsViewModel: DocumentsListViewModel, departmentsViewModel: DepartmentsListViewModel, coordinator: DocumentsListCoordinator) {
        self.coordinator = coordinator
        self.documentsViewModel = documentsViewModel
        self.departmentsViewModel = departmentsViewModel
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        documentsViewModel.updateDocuments()
        
        if tableView.isDescendant(of: UIApplication.shared.keyWindow!) {
            tableView.reloadSections([0], with: .fade)
        }
    }
    
    override var leftBarButtonItems: [UIBarButtonItem] {
        return [
            UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"),style: .plain, target: self, action: #selector(openMenu))
        ]
    }
    
    // MARK: Interface
    func insertNewDocument(document: DocumentViewModel) {
        documentsViewModel.insertNewDocument(document)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    
    // MARK: Helpers
    private let disposeBag = DisposeBag()

    
    private func setupBindings() {
        documentsViewModel.documentTypesState
            .asObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .awaitingInteraction:
                    break
                    
                case .loading:
                    self.departmentsStackView.subviews.forEach({
                        if let button = $0 as? DepartmentButton, button.isSelected {
                            button.isLoading = true
                        }
                    })
                    
                case .success:
                    self.resetButtons()
                    
                    if let department = self.documentsViewModel.lastSelectedDepartment {
                        self.coordinator.createNewDocument(with: department)
                    }
                    
                case .error(let error):
                    self.resetButtons()
                    self.handleError(error)
                }
            })
            .disposed(by: disposeBag)
        
        departmentsViewModel.departmentState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                
                switch status {
                case .awaitingInteraction:
                    self.departmentsViewModel.fetchDepartments()
                    
                case .loading:
                    self.departmentsStackView.subviews.forEach({ $0.removeFromSuperview() })
                    self.departmentsStackView.addArrangedSubview(self.departmentsLoadingView)
                    
                case .success:
                    self.departmentsStackView.subviews.forEach({ $0.removeFromSuperview() })
                    
                    self.departmentsViewModel.departments.value
                        .map({
                            DepartmentButton(model: $0)
                        })
                        .forEach({ (button) in
                            button.rx.tap
                                .subscribe({ [weak self] _ in
                                    self?.loadDocumentTypes(for: button.model)
                                })
                                .disposed(by: self.disposeBag)

                            self.departmentsStackView.addArrangedSubview(button)
                        })
                    
                case .error( _):
                    self.departmentsStackView.subviews.forEach({ $0.removeFromSuperview() })
                    
                    self.departmentsStackView.addArrangedSubview(self.departmentsErrorView)
                    
                }
            })
            .disposed(by: disposeBag)
        
        departmentsErrorView.buttonTap
            .subscribe(onNext: { [weak self] _ in
                self?.departmentsViewModel.fetchDepartments()
            })
        .disposed(by: disposeBag)
    }
    
    @objc private func openMenu() {
        coordinator.openMenu()
    }

    private func loadDocumentTypes(for department: DepartmentDomainModel) {
        documentsViewModel.fetchDocumentTypes(for: department)
    }
    
    private func resetButtons() {
        departmentsStackView.subviews.forEach({
            if let button = $0 as? DepartmentButton {
                button.isLoading = false
                button.isSelected = false
            }
        })
    }
    
    private func setupView() {
        navigationItem.title = "document.screen.title".localized
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
        }
        
        tableView.backgroundView = emptyView
        
        emptyView.addSubview(emptyViewLabel)
        emptyViewLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualTo(tableView.safeAreaLayoutGuide.snp.top).offset(8)
            make.centerY.equalToSuperview().multipliedBy(0.666).priority(500)
        }
        
        view.addSubview(departmentsContainerView)
        departmentsContainerView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.33)
        }
        
        departmentsContainerView.addSubview(departmentsHeaderView)
        departmentsHeaderView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        
        departmentsContainerView.addSubview(departmentsScrollView)
        departmentsScrollView.snp.makeConstraints { make in
            make.top.equalTo(departmentsHeaderView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(safeArea).inset(8)
        }

        departmentsScrollView.addSubview(departmentsStackView)
        departmentsStackView.snp.makeConstraints { make in
            make.top.equalTo(departmentsScrollView.contentLayoutGuide.snp.top)
            make.leading.equalTo(departmentsScrollView.snp.leading)
            make.trailing.equalTo(departmentsScrollView.snp.trailing)
            make.bottom.equalTo(departmentsScrollView.contentLayoutGuide.snp.bottom)
            make.width.equalTo(departmentsScrollView.snp.width)
            make.width.equalTo(departmentsScrollView.contentLayoutGuide.snp.width)
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(DocumentTableViewCell.self)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var departmentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var departmentsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var departmentsScrollView = UIScrollView()
    
    private lazy var departmentsHeaderView = TitleView(title: "departments.tableHeader.title".localized)
    
    private lazy var departmentsLoadingView = LoadingView()
    
    private lazy var departmentsErrorView = ErrorView()
    
    private lazy var emptyView = UIView()
    
    private lazy var emptyViewLabel: UILabel = {
        let label = UILabel()
        label.text = "document.emptyView.title".localized
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .body
        label.textAlignment = .center
        return label
    }()
}

//MARK: - UITableViewDataSource implementation
extension DocumentsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = documentsViewModel.documents.count
        tableView.backgroundView?.isHidden = count > 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let document = documentsViewModel.documents[indexPath.row]
        let cell = tableView.dequeueCell(DocumentTableViewCell.self)
        cell.setup(with: document, delegate: self)
        return cell
    }
}

//MARK: - DocumentViewDelegate implementation
extension DocumentsListViewController: DocumentViewDelegate {}
