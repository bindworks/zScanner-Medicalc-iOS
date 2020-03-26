//
//  IkemNetworkManaging.swift
//  zScanner
//
//  Created by Jakub Skořepa on 28/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkManager {
    
    /// Send login request
    ///
    /// - Parameter login: Username and Password
    /// - Returns: Observable request status
    func login(_ login: LoginNetworkModel) -> Observable<RequestStatus<TokenNetworkModel>>

    /// Send logout request
    ///
    /// - Parameter logout: Token
    /// - Returns: Observable request status
    func logout(_ logout: LogoutNetworkModel) -> Observable<RequestStatus<EmptyResponse>>

    /// Fetch all document subtypes
    ///
    /// - Returns: Observable request status
    func getDocumentTypes(for departmentCode: String) -> Observable<RequestStatus<DocumentTypesNetworkModel>>
    
    /// Fetch all departments
    ///
    /// - Returns: Observable request status
    func getDepartments() -> Observable<RequestStatus<[DepartmentNetworkModel]>>
    
    /// Upload document to server
    ///
    /// - Parameter document: New document to upload
    /// - Returns: Observable request status
    func uploadDocument(_ document: DocumentNetworkModel) -> Observable<RequestStatus<EmptyResponse>>
    
    /// Search folders on backend
    ///
    /// - Parameter query: Part of the folder external id or name to search
    /// - Returns: Observable request status
    func searchFolders(with query: String) -> Observable<RequestStatus<[FolderNetworkModel]>>

    /// Upload one page from Document
    ///
    /// - Parameter page: One Document page with Documet corelation id
    /// - Returns: Observable request status
    func uploadPage(_ page: PageNetworkModel) -> Observable<RequestStatus<EmptyResponse>>
}
