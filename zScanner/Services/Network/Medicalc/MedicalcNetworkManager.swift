//
//  IkemNetworkManager.swift
//  zScanner
//
//  Created by Jakub Skořepa on 28/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RxSwift

class MedicalcNetworkManager: NetworkManager {
    
    
    // MARK: Instance part
    private let api: API
    private let requestBehavior: RequestBehavior
    
    init(api: API, requestBehavior: RequestBehavior = EmptyRequestBehavior()) {
        self.api = api
        self.requestBehavior = requestBehavior
    }
    
    // MARK: Interface
        
    func getDocumentTypes(for departmentCode: String) -> Observable<RequestStatus<DocumentTypesNetworkModel>> {
        let request = DocumentTypesRequest(departmentCode: departmentCode)
        return observe(request)
    }
    
    func getDepartments() -> Observable<RequestStatus<[DepartmentNetworkModel]>> {
        let request = DepartmentsRequest()
        return observe(request)
    }
    
    func uploadDocument(_ document: DocumentNetworkModel) -> Observable<RequestStatus<EmptyResponse>> {
        let request = SubmitReuest(document: document)
        return observe(request)
    }
    
    func searchFolders(with query: String) -> Observable<RequestStatus<[FolderNetworkModel]>> {
        let request = SearchFoldersRequest(query: query)
        return observe(request)
    }
    
    func getFolder(with id: String) -> Observable<RequestStatus<FolderNetworkModel>> {
        let request = GetFolderRequest(with: id)
        return observe(request)
    }
    
    func uploadPage(_ page: PageNetworkModel) -> Observable<RequestStatus<EmptyResponse>> {
        let request = UploadPageReuest(with: page)
        return observe(request)
    }
    
    private func observe<T: Request, U: Decodable>(_ request: T) -> Observable<RequestStatus<U>> where T.DataType == U {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            var request = request
            
            request.headers.merge(
                self.requestBehavior.additionalHeaders,
                uniquingKeysWith: { (current, _) in current }
            )
            
            self.requestBehavior.beforeSend()
            
            self.api.process(request, with: { [weak self] requestStatus in
                observer.onNext(requestStatus)
                
                switch requestStatus {
                case .progress:
                    break
                case .success:
                    self?.requestBehavior.afterSuccess()
                    observer.onCompleted()
                case .error(let error):
                    self?.requestBehavior.afterError(error)
                    observer.onError(error)
                }
            })
            
            return Disposables.create()
        }
    }
}
