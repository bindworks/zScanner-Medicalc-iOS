//
//  DepartmentTableViewCell.swift
//  zScanner
//
//  Created by Jan Provazník on 21/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {
    //MARK: Instance part
    private var viewModel: DepartmentDomainModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
        titleLabel.text = nil
    }
    
    //MARK: Interface
    func setup(with model: DepartmentDomainModel) {
        self.viewModel = model
        
        titleLabel.text = String(format: "%@ - %@", model.id, model.name)
    }
    
    
    private func setupView() {
        contentView.addSubview(textContainer)
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.topMargin)
            make.bottom.equalTo(contentView.snp.bottomMargin)
            make.left.equalTo(contentView.snp.leftMargin)
        }
        
        textContainer.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.right.left.bottom.equalToSuperview()
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .black
        return label
    }()
    
    private var textContainer = UIView()
}
