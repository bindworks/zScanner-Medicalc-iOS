//
//  Page.swift
//  zScanner
//
//  Created by Jakub Skořepa on 16/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class Page {
    
    var image: UIImage
    let description = BehaviorRelay<String>(value: "")
    
    init(image: UIImage) {
        self.image = image
    }
}

extension Page: Equatable {
    static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.image == rhs.image
    }
}
