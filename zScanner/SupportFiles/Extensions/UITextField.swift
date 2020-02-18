//
//  UITextField.swift
//  zScanner
//
//  Created by Jakub Skořepa on 20/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

extension UITextField {
    func setBottomBorder(show: Bool = true, animated: Bool = true, color: UIColor = .primary, duration: CFTimeInterval = 0.333) {
        borderStyle = .none
        
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = show ? color.cgColor : UIColor.clear.cgColor
        layer.shadowRadius = 0.0
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        UIView.animate(withDuration: animated ? duration : 0) {
            self.layer.shadowOpacity = show ? 1 : 0
        }
    }
}
