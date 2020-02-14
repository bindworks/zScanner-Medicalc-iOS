//
//  UITextField.swift
//  zScanner
//
//  Created by Jakub Skořepa on 20/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

extension UITextField {
    func setBottomBorder(show: Bool = true, color: CGColor = UIColor.white.cgColor) {
        borderStyle = .none
        
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = show ? color : UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = show ? 1.0 : 0
        layer.shadowRadius = 0.0
    }
    
    enum Padding {
        case left
        case right
        case both
    }
    
    func setPadding(padding: Padding, size: CGFloat, mode: UITextField.ViewMode = .always) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: self.frame.height))
        
        switch padding {
        case .right:
            self.rightView = paddingView
            self.rightViewMode = mode
        case .left:
            self.leftView = paddingView
            self.leftViewMode = mode
        case .both:
            self.leftView = paddingView
            self.leftViewMode = mode
            
            self.rightView = paddingView
            self.rightViewMode = mode
        }
    }
}
