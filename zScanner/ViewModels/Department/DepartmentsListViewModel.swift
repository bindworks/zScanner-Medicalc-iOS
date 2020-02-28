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
    private let networkManager: NetworkManager
    
    let departments = BehaviorRelay<[DepartmentDomainModel]>(value: [])
    
    init(ikemNetworkManager: NetworkManager) {
        self.networkManager = ikemNetworkManager
    }
    
    //MARK: Interface
    let departmentState = BehaviorSubject<DepartmentState>(value: .awaitingInteraction)
    
    //MARK: Helpers
    let disposeBag = DisposeBag()
    
    func fetchDepartments() {
        networkManager
            .getDepartments()
            .subscribe(onNext: { [weak self] requestStatus in
                switch requestStatus {
                case .progress:
                    self?.departmentState.onNext(.loading)
                    
                case .success(data: let networkModel):
                    let departments = networkModel
                        .map({ $0.toDomainModel() })
                    self?.departments.accept(departments)
                    self?.departmentState.onNext(.success)
                    
                case .error(let error):
                    self?.departmentState.onNext(.error(error))
                    
                }
            })
            .disposed(by: disposeBag)
    }
}
