//
//  DepartmentDatabaseModel.swift
//  zScanner
//
//  Created by Jan Provazník on 14/02/2020.
//  Copyright © 2020 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RealmSwift

class DepartmentDatabaseModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    
    convenience init(document: DepartmentDomainModel) {
        self.init()
        
        self.id = document.id
        self.name = document.name
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
}

//MARK: -
extension DepartmentDatabaseModel {
    func toDomainModel() -> DepartmentDomainModel {
        return DepartmentDomainModel(
            id: id,
            name: name
        )
    }
}
