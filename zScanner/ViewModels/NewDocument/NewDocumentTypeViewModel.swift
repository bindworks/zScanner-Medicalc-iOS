//
//  NewDocumentTypeViewModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 04/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class NewDocumentTypeViewModel {
    
    private typealias TypePicker = ListPickerField<DocumentTypeDomainModel>
    private typealias SubTypePicker = ListPickerField<DocumentSubTypeDomainModel>
    
    let fields = BehaviorRelay<[FormField]>(value: [])
    var isValid = Observable<Bool>.just(false)
    
    // MARK: Instance part
    private let database: Database
    let folderName: String
    
    init(database: Database, folderName: String) {
        self.database = database
        self.folderName = folderName
       
        setupObservables()
    }

    // MARK: Helpers
    private let disposeBag = DisposeBag()
    private var fieldsDisposeBag = DisposeBag()
    
    private var documentTypes: [DocumentTypeDomainModel] {
        return database.loadObjects(DocumentTypeDatabaseModel.self).map({ $0.toDomainModel() })
    }
    
    private var defaultFields: [FormField] {
        var documentTypes: [DocumentTypeDomainModel] {
            return database.loadObjects(DocumentTypeDatabaseModel.self).map({ $0.toDomainModel() })
        }
    
        return [
            TextInputField(title: "form.documentDecription.title".localized, validator: { _ in true }),
            TypePicker(title: "form.listPicker.docType.title".localized, list: documentTypes),
        ]
    }
    
    private func setupObservables() {
        fields.accept(defaultFields)
        
        fields.subscribe(onNext: { [weak self] newFields in
            guard let self = self else { return }
            
            self.fieldsDisposeBag = DisposeBag()
            
            newFields.compactMap({ $0 as? TypePicker }).first?.selected
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] documentType in
                    documentType.flatMap({ self?.addSubTypesField(for: $0) })
                })
                .disposed(by: self.fieldsDisposeBag)
            
            self.isValid = Observable
                .combineLatest(newFields.map({ $0.isValid }))
                .map({ results in results.reduce(true, { $0 && $1 }) })
        })
        .disposed(by: disposeBag)
    }
    
    private var lock = false
    
    private func addSubTypesField(for documentType: DocumentTypeDomainModel) {
        guard !lock else { return }
        lock = true; defer { lock = false }
        
        var existingSubTypePicker: SubTypePicker? { fields.value.compactMap({ $0 as? SubTypePicker }).first }
        var newSubTypePicker: SubTypePicker { SubTypePicker(title: "form.listPicker.docSubType.title".localized, list: documentType.subtypes) }
        
        let newFields = fields.value.filter({ !($0 is SubTypePicker) })
        
        if documentType.subtypes.isEmpty {
            fields.accept(newFields)
            return
        }
        
        let subTypePicker = newSubTypePicker
        
        if documentType.subtypes.count == 1, let subtype = documentType.subtypes.first {
            subTypePicker.selected.accept(subtype)
        }
        
        fields.accept(newFields + [subTypePicker])
    }
}
