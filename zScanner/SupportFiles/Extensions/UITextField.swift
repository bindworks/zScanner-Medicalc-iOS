//
//  UITextField.swift
//  zScanner
//
//  Created by Jakub Skořepa on 20/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    #warning("TODO Maybe we can merge these two methods")
    func addBottomBorder(height: CGFloat = 1, color: UIColor = UIColor.red, leftInset: CGFloat = 0, rightInset: CGFloat = 0) {
        let bottomLine = UIView()
        bottomLine.frame = CGRect(x: leftInset, y: self.frame.size.height - 1 , width: self.frame.size.width - leftInset - rightInset, height: height)
        bottomLine.backgroundColor = color
        self.addSubview(bottomLine)
    }
    
    func removeBottomBorder() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    enum Inset {
        case left
        case right
        case both
    }
    
    func setInset(inset: Inset, amount: CGFloat, mode: UITextField.ViewMode = .always) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        
        switch inset {
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
