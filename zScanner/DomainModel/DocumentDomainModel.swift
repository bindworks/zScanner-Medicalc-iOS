//
//  DocumentDomainModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 21/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

struct DocumentDomainModel {
    var id: String
    var folder: FolderDomainModel
    var type: DocumentTypeDomainModel
    var subType: DocumentSubTypeDomainModel
    var created: Date
    var name: String
    var pages: [PageDomainModel]
    var department: DepartmentDomainModel
}

extension DocumentDomainModel: Equatable {
    static func == (lhs: DocumentDomainModel, rhs: DocumentDomainModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension DocumentDomainModel {
    static var emptyDocument: DocumentDomainModel {
        return DocumentDomainModel(
            id: UUID().uuidString,
            folder: FolderDomainModel(
                externalId: "",
                id: "",
                name: ""
            ),
            type: DocumentTypeDomainModel(
                id: "",
                name: "",
                subtypes: []
            ),
            subType: DocumentSubTypeDomainModel(
                id: "",
                name: ""
            ),
            created: Date(),
            name: "",
            pages: [],
            department: DepartmentDomainModel(
                id: "",
                name: ""
            )
        )
    }
}
