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

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposedBag = DisposeBag()
    
    func setup() {
        setTitle(model.name, for: .normal)
        
        rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isSelected.toggle()
                self.backgroundColor = self.isSelected ? UIColor.primaryDark : UIColor.primary
            })
            .disposed(by: disposedBag)
    }
}
