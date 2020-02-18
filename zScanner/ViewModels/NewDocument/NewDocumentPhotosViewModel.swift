//
//  NewDocumentPhotosViewModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 14/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class NewDocumentPhotosViewModel {
    
    // MARK: Instance part
    private let tracker: Tracker
    
    init(tracker: Tracker) {
        self.tracker = tracker
    }
    
    // MARK: Interface
    let pages = BehaviorRelay<[Page]>(value: [])
    
    func addPage(_ page: Page, fromGallery: Bool) {
        // Tracking
        tracker.track(.galleryUsed(fromGallery))
        
        // Add image
        var newArray = pages.value
        newArray.append(page)
        pages.accept(newArray)
    }
    
    func removePage(_ page: Page) {
        // Tracking
        tracker.track(.deleteImage)

        // Remove image
        var newArray = pages.value
        _ = newArray.remove(page)
        pages.accept(newArray)
    }
}
