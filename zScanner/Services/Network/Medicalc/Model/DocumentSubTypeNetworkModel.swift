//
//  DocumentSubTypeNetworkModel.swift
//  zScanner
//
//  Created by Jan Provazník on 03/03/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct DocumentSubTypeNetworkModel: Decodable {
    let id: String
    let display: String
}

extension DocumentSubTypeNetworkModel {
    func toDomainModel() -> DocumentSubTypeDomainModel {
        return DocumentSubTypeDomainModel(
            id: id,
            name: display
        )
    }
}
