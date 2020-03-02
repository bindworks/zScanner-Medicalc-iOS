//
//  NewDocumentTypeViewModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 04/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RxSwift

class NewDocumentTypeViewModel {
    
    // MARK: Instance part
    private let database: Database
    let folderName: String
    
    init(database: Database, folderName: String) {
        self.database = database
        self.folderName = folderName
        self.isValid = Observable
            .combineLatest(fields.map({ $0.isValid }))
            .map({ results in results.reduce(true, { $0 && $1 }) })
    }
    
    // MARK: Interface
    private(set) lazy var fields: [FormField] = {
        var documentTypes: [DocumentTypeDomainModel] {
            return database.loadObjects(DocumentTypeDatabaseModel.self)
                .map({ $0.toDomainModel() })
        }
        
        return [
            TextInputField(title: "form.documentDecription.title".localized, validator: { _ in true }),
            ListPickerField<DocumentTypeDomainModel>(title: "form.listPicker.docType.title".localized, list: documentTypes),
        ]
    }()

    var isValid = Observable<Bool>.just(false)
    
    func addSubTypesField(of documentType: DocumentTypeDomainModel) {
        let listPicker = ListPickerField<DocumentSubTypeDomainModel>(title: "form.listPicker.docSubType.title".localized, list: documentType.subtypes)
        
        if let _ = fields.last as? ListPickerField<DocumentSubTypeDomainModel> {
            fields.remove(at: fields.count - 1)
        }
        
        fields.append(listPicker)
    }
    
    func addDateTimePickerPlaceholder(at index: Int, for date: DateTimePickerField) {
        fields.insert(DateTimePickerPlaceholder(for: date), at: index)
    }
    
    func removeDateTimePickerPlaceholder() {
        fields.removeAll(where: { $0 is DateTimePickerPlaceholder })
    }
}
