//
//  DocumentNetworkModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 06/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

struct DocumentNetworkModel: Encodable {
    var correlation: String
    var folderInternalId: String
    var documentType: String
    var documentSubType: String
    var pages: Int
    var datetime: String
    var name: String
    var notes: String
    var department: String
    
    init(from domainModel: DocumentDomainModel) {
        self.correlation = domainModel.id
        self.folderInternalId = domainModel.folder.id
        self.documentType = domainModel.type.id
        #warning("TODO Find how to add id of subtypes?")
        self.documentSubType = domainModel.type.id
        
        self.pages = domainModel.pages.count
        self.datetime = domainModel.created.utcString
        self.name = domainModel.type.name
        self.notes = domainModel.notes
        self.department = domainModel.department.name
    }
}
