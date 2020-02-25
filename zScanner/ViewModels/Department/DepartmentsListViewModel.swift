//
//  DepartmentListViewModel.swift
//  zScanner
//
//  Created by Jan Provazník on 25/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class DepartmentsListViewModel {
    enum DepartmentState {
        case awaitingInteraction
        case loading
        case success
        case error(RequestError)
    }
    
    //MARK: Instance part
    private let database: Database
    private let networkManager: NetworkManager
    
    private(set) var departments: [DepartmentViewModel] = []
    
    var selectedDepartment: Observable<DepartmentViewModel>!
    
    init(database: Database, ikemNetworkManager: NetworkManager) {
        self.database = database
        self.networkManager = ikemNetworkManager
        
        fetchDepartments()
        setupObservables()
    }
    
    //MARK: Interface
    let departmentState = BehaviorSubject<DepartmentState>(value: .loading)
    
    //MARK: Helpers
    let disposeBag = DisposeBag()
    
    func fetchDepartments() {
        networkManager
            .getDepartments()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] requestStatus in
                switch requestStatus {
                case .progress:
                    self?.departmentState.onNext(.loading)
                    
                case .success(data: let networkModel):
                    self?.departments = networkModel.map({ $0.toDomainModel() }).map({ DepartmentViewModel(department: $0) })
                    
                    self?.departmentState.onNext(.success)
                    
                case .error(let error):
                    self?.departmentState.onNext(.error(error))
                    
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupObservables() {
        selectedDepartment = Observable.from(
            self.departments.map({ department in department.isSelected.map({ _ in department }) })
        )
        .merge()
        
        departments.reduce(Disposables.create()) { disposable, department in
            let subscription = selectedDepartment
                .map({ (a: DepartmentViewModel) -> Bool in a === department })
                .subscribe(onNext: { department.isSelected.accept($0) })
            return Disposables.create(disposable, subscription)
        }
        .disposed(by: disposeBag)
    }
}
