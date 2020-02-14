//
//  DepartmentNetworkModel.swift
//  zScanner
//
//  Created by Jan Provazník on 14/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct DepartmentNetworkModel: Decodable {
    var id: String
    var display: String
}

extension DepartmentNetworkModel {
    func toDomainModel() -> DepartmentDomainModel {
        return DepartmentDomainModel(
            id: id,
            name: display
        )
    }
}
