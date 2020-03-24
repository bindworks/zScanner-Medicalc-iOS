//
//  DocumentType.swift
//  zScanner
//
//  Created by Jakub Skořepa on 28/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct DocumentTypeNetworkModel: Decodable {
    let id: String
    let display: String
    let subtypes: [DocumentSubTypeNetworkModel]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case display
        case subtypes = "sub-type"
    }
}

struct DocumentTypesNetworkModel: Decodable {
    let type: [DocumentTypeNetworkModel]
}

extension DocumentTypeNetworkModel {
    func toDomainModel() -> DocumentTypeDomainModel {
        return DocumentTypeDomainModel(
            id: id,
            name: display,
            subtypes: subtypes?.map({ $0.toDomainModel() }) ?? []
        )
    }
}
