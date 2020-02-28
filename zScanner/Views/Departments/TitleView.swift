//
//  TitleView.swift
//  zScanner
//
//  Created by Jan Provazník on 26/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

class TitleView: UIView {
    let title: String?
    
    //MARK: Instance part
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func setup() {
        titleLabel.text = title
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .headline
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
}
