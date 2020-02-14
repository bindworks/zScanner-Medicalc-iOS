//
//  DepartmentDomainModel.swift
//  zScanner
//
//  Created by Jan Provazník on 14/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct DepartmentDomainModel {
    var id: String
    var name: String
}

extension DepartmentDomainModel: Equatable {
    static func == (lhs: DepartmentDomainModel, rhs: DepartmentDomainModel) -> Bool {
        return lhs.id == rhs.id
    }
}
