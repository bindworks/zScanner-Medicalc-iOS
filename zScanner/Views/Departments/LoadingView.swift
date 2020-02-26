//
//  LoadingView.swift
//  zScanner
//
//  Created by Jan Provazník on 25/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    //MARK: Instance part
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Interface
    func setup() {
        snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
}
