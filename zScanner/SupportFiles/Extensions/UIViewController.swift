//
//  UIViewController.swift
//  zScanner
//
//  Created by Jakub Skořepa on 20/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

extension UIViewController {
    var safeArea: UILayoutGuide {
        return view.safeAreaLayoutGuide
    }
    
    // Whenever user gonna tap somewhere else than the current view so it will dismiss the keyboard
    func setupKeyboardHandling() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
