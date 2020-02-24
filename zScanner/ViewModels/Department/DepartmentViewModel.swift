//
//  DepartmentViewModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 24/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RxRelay

class DepartmentViewModel {
    
    let department: DepartmentDomainModel
    
    var isSelected = BehaviorRelay<Bool>(value: false)
    
    init(department: DepartmentDomainModel, isSelected: Bool = false) {
        self.department = department
        self.isSelected.accept(isSelected)
    }
    
    func toggleSelection() {
        isSelected.toggle()
    }
}
