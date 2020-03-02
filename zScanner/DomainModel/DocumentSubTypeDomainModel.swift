//
//  DocumentSubTypeDomainModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 02/03/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct DocumentSubTypeDomainModel: Equatable {
    var id: String
    var name: String
}

// MARK: ListItem implementation
extension DocumentSubTypeDomainModel: ListItem {
    var title: String {
        return name
    }
}
