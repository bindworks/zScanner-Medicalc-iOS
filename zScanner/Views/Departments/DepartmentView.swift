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
import RxGesture

class DepartmentView: UIView {
    
    private let onClickHandler: ((DepartmentDomainModel) -> Void)?
    
    let model: DepartmentDomainModel
    let isSelected = BehaviorRelay<Bool>(value: true)
    
    //MARK: Instance part
    init(model: DepartmentDomainModel, onClickHandler: ((DepartmentDomainModel) -> Void)? = nil) {
        self.model = model
        self.onClickHandler = onClickHandler
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private let disposeBag = DisposeBag()
    
    private func setup() {
        titleLabel.text = model.name
        
        self.rx.tapGesture()
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.onClickHandler?(self.model)
                self.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        isSelected
            .observeOn(MainScheduler.instance)
            .map({ !$0 })
            .bind(to: selectionView.rx.isHidden)
            .disposed(by: disposeBag)

        addSubview(selectionView)
        selectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private var selectionView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.primary.cgColor
        return view
    }()
    
}
