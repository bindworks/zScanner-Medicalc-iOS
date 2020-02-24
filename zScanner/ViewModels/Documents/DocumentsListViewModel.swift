//
//  DocumentsListViewModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 21/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class DocumentsListViewModel {
    enum DocumentModesState {
        case awaitingInteraction
        case loading
        case success
        case error(RequestError)
    }
    
    //MARK: Instance part
    private let database: Database
    private let networkManager: NetworkManager
    
    private(set) var documents: [DocumentViewModel] = []
    private(set) var departments = BehaviorSubject<[DepartmentDomainModel]>(value: [])
    
    let isDepartmentSelected = BehaviorRelay<Bool>(value: false)
    
    init(database: Database, ikemNetworkManager: NetworkManager) {
        self.database = database
        self.networkManager = ikemNetworkManager
        
        loadDocuments()
        fetchDocumentTypes()
        fetchDepartments()
    }
    
    //MARK: Interface
    let documentModesState = BehaviorSubject<DocumentModesState>(value: .awaitingInteraction)
    
    func insertNewDocument(_ document: DocumentViewModel) {
        documents.insert(document, at: 0)
    }
    
    func updateDocumentTypes() {
        fetchDocumentTypes()
        fetchDepartments()
    }
    
    func updateDocuments() {
        
        // Find all documents with active upload
        let activeUploadDocuments = documents.filter({
            var currentStatus: DocumentViewModel.UploadStatus?
            $0.documentUploadStatus.subscribe(onNext: { status in currentStatus = status }).disposed(by: disposeBag)
            return currentStatus == .awaitingInteraction || currentStatus == .progress(0) // Any progress, parameter is not considered when comparing
        })
        
        loadDocuments()
        
        // Replace all dummy* documents with active upload to show the process in UI.
        // *dummy document is document loaded from DB without active upload process
        for activeDocument in activeUploadDocuments {
            let _ = documents.remove(activeDocument)
            documents.insert(activeDocument, at: 0)
        }
    }
    
    //MARK: Helpers
    let disposeBag = DisposeBag()
    
    private func loadDocuments() {
        documents = database
            .loadObjects(DocumentDatabaseModel.self)
            .map({ DocumentViewModel(document: $0.toDomainModel(), networkManager: networkManager, database: database) })
            .reversed()
    }
    
    func fetchDocumentTypes() {
        networkManager
            .getDocumentTypes()
            .subscribe(onNext: { [weak self] requestStatus in
                switch requestStatus {
                case .progress:
                    self?.documentModesState.onNext(.loading)
                    
                case .success(data: let networkModel):
                    let documents = networkModel.type.map({ $0.toDomainModel() })
                    
                    self?.storeDocumentTypes(documents)

                case .error(let error):
                    self?.documentModesState.onNext(.error(error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func storeDocumentTypes(_ types: [DocumentTypeDomainModel]) {
        DispatchQueue.main.async {
            self.database.deleteAll(of: DocumentTypeDatabaseModel.self)
            types
                .map({ DocumentTypeDatabaseModel(documentType: $0) })
                .forEach({ self.database.saveObject($0) })
        }
    }
    
    func fetchDepartments() {
        networkManager
            .getDepartments()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] requestStatus in
                switch requestStatus {
                case .progress:
                    self?.documentModesState.onNext(.loading)
                case .success(data: let networkModel):
                    let departments = networkModel.map({ $0.toDomainModel() })
                    
                    self?.departments.onNext(departments)
                case .error(let error):
                     self?.documentModesState.onNext(.error(error))
                }
            }).disposed(by: disposeBag)
    }
}
