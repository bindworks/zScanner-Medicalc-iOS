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
    let pictures = BehaviorRelay<[PageDomainModel]>(value: [])
    
    func addImage(_ image: PageDomainModel, fromGallery: Bool) {
        // Tracking
        tracker.track(.galleryUsed(fromGallery))
        
        // Add image
        var newArray = pictures.value
        newArray.append(image)
        pictures.accept(newArray)
    }
    
    func removeImage(_ image: PageDomainModel) {
        // Tracking
        tracker.track(.deleteImage)

        // Remove image
        var newArray = pictures.value
        _ = newArray.remove(image)
        pictures.accept(newArray)
    }
}
