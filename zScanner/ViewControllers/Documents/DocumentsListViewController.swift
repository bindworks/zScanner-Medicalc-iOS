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
    func createNewDocument()
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
        documentsTableView.reloadSections([0], with: .fade)
    }
    
    override var leftBarButtonItems: [UIBarButtonItem] {
        return [
            UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"),style: .plain, target: self, action: #selector(openMenu))
        ]
    }
    
    override var rightBarButtonItems: [UIBarButtonItem] {
        return rightBarButtons
    }
    
    // MARK: Interface
    func insertNewDocument(document: DocumentViewModel) {
        documentsViewModel.insertNewDocument(document)
        documentsTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    
    // MARK: Helpers
    private let disposeBag = DisposeBag()
    private var rightBarButtons: [UIBarButtonItem] = [] {
        didSet {
            navigationItem.rightBarButtonItems = rightBarButtons
        }
    }
    
    private func setupBindings() {
        documentsViewModel.documentTypesState
            .asObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] status in
                switch status {
                case .awaitingInteraction:
                    self.rightBarButtons = []
                    
                case .loading:
                    self.rightBarButtons = [self.loadingItem]
                    
                case .success:
                    self.rightBarButtons = []
                    self.departmentsStackView.subviews.forEach({ ($0 as? UIButton)?.isSelected = false })
                    self.coordinator.createNewDocument()
                    
                case .error(let error):
                    self.rightBarButtons = []
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
                                    self?.loadDocumentTypes(departmentCode: button)
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

    private func loadDocumentTypes(departmentCode: DepartmentButton) {
        documentsViewModel.fetchDocumentTypes(for: departmentCode)
    }
    
    private func setupView() {
        navigationItem.title = "document.screen.title".localized
        
        view.addSubview(documentsTableView)
        documentsTableView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        
        documentsTableView.backgroundView = emptyView
        
        emptyView.addSubview(emptyViewLabel)
        emptyViewLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerX.equalToSuperview()
            make.top.equalTo(documentsTableView.sectionHeaderHeight)
            make.centerY.equalToSuperview().multipliedBy(0.666).priority(900)
        }
        
        view.addSubview(departmentsContainerView)
        departmentsContainerView.snp.makeConstraints { make in
            make.top.equalTo(documentsTableView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0).priority(100)
            make.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.666)
        }
        
        departmentsContainerView.addSubview(departmentsHeaderView)
        departmentsHeaderView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        
        departmentsContainerView.addSubview(departmentsStackView)
        departmentsStackView.snp.makeConstraints { make in
            make.top.equalTo(departmentsHeaderView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(safeArea).inset(8)
        }
    }
    
    private lazy var loadingItem: UIBarButtonItem = {
        let loading = UIActivityIndicatorView(style: .gray)
        loading.startAnimating()
        let button = UIBarButtonItem(customView: loading)
        button.isEnabled = false
        return button
    }()
    
    private lazy var documentsTableView: UITableView = {
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
        let departmentsContainerView = UIView()
        departmentsContainerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return departmentsContainerView
    }()
    
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
