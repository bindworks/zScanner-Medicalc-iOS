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
    
    private var model: DepartmentViewModel?
    
    //MARK: Instance part
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Interface
    func setup(with model: DepartmentViewModel) {
        self.model = model
        
        titleLabel.text = model.department.name
        model.isSelected
            .observeOn(MainScheduler.instance)
            .map({ !$0 })
            .bind(to: selectionView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    // MARK: Helpers
    private let disposeBag = DisposeBag()
    
    private func setup() {
        rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.model?.toggleSelection()
            })
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
