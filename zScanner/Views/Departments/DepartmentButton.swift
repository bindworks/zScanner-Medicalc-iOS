//
//  DepartmentView.swift
//  zScanner
//
//  Created by Jakub Skořepa on 24/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DepartmentButton: PrimaryButton {
    let model: DepartmentDomainModel
    
    //MARK: Instance part
    init(model: DepartmentDomainModel) {
        self.model = model
        
        super.init(frame: .zero)
        
        setTitle(model.name, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}