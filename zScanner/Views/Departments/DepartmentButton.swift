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
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .primaryDark : .primary
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    let disposedBag = DisposeBag()
    
    private func setup() {
        setTitle(model.name, for: .normal)
        
        snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
        }
        
        rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.isSelected = true
            })
            .disposed(by: disposedBag)
    }
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        return activityIndicator
    }()
}
