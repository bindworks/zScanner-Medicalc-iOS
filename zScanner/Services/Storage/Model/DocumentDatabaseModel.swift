//
//  DocumentRealmModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 24/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RealmSwift

class DocumentDatabaseModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var created = Date()
    @objc dynamic var name = ""
    @objc dynamic var notes = ""
    @objc dynamic var typeId = ""
    @objc dynamic var typeName = ""
    @objc dynamic var department: DepartmentDatabaseModel?
    @objc dynamic var folder: FolderDatabaseModel?
    let pages = List<PageDatabaseModel>()
    
    
    convenience init(document: DocumentDomainModel) {
        self.init()
        
        self.id = document.id
        self.created = document.created
        self.name = document.name
        self.notes = document.notes
        
        let realm = try! Realm()
        self.typeId = document.type.id
        self.typeName = document.type.name
        self.department = realm.loadObject(DepartmentDatabaseModel.self, withId: document.department.id) ?? DepartmentDatabaseModel(document: document.department)
        self.folder = realm.loadObject(FolderDatabaseModel.self, withId: document.folder.id) ?? FolderDatabaseModel(folder: document.folder)
        
        self.pages.append(objectsIn: document.pages.map({ PageDatabaseModel(page: $0) }))
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
}

//MARK: -
extension DocumentDatabaseModel {
    func toDomainModel() -> DocumentDomainModel {
        #warning("TODO: finish storing subtype")
        return DocumentDomainModel(
            id: id,
            folder: folder!.toDomainModel(),
            type: DocumentTypeDomainModel(id: typeId, name: typeName, subtypes: []),
            subType: DocumentSubTypeDomainModel(id: "", name: ""),
            created: created,
            name: name,
            notes: notes,
            pages: pages.map({ $0.toDomainModel() }),
            department: department!.toDomainModel()
        )
    }
}

extension DocumentDatabaseModel: RichDeleting {
    func deleteRichContent() {
        let folderPath = URL.documentsPath + "/" + id
        try? FileManager.default.removeItem(atPath: folderPath)
    }
}
