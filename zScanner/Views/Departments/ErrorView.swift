//
//  ErrorView.swift
//  zScanner
//
//  Created by Jan Provazník on 26/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import RxSwift

class ErrorView: UIView {

    let buttonTap: Observable<Void>
    
    init() {
        buttonTap = reloadButton.rx.tap.asObservable()
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(textContainer)
        textContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        textContainer.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        addSubview(reloadButton)
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(8)
            make.trailing.leading.equalToSuperview().inset(64)
            make.bottom.equalToSuperview()
        }
    }
    
    private var textContainer = UIView()
    
    private var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "departments.fetchError.title".localized
        messageLabel.font = .body
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        return messageLabel
    }()

    private var reloadButton: PrimaryButton = {
        let reloadButton = PrimaryButton()
        reloadButton.setTitle("departments.reloadButton.title".localized, for: .normal)
        return reloadButton
    }()
}
