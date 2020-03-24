//
//  AppCoordinator.swift
//  zScanner
//
//  Created by Jakub Skořepa on 29/06/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import SeaCat
import RxSwift

class AppCoordinator: Coordinator {
    
    //MARK: - Instance part
    init() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        super.init(window: window, navigationController: nil)
    }

    // MARK: Inteface
    func begin() {
        showSplashScreen()
    }
    
    // MARK: Navigation methods
    private func showSplashScreen() {
        let viewController = SeaCatSplashViewController(coordinator: self)
        changeWindowControllerTo(viewController)
    }

    private func runLoginFlow() {
        let coordinator = LoginCoordinator(flowDelegate: self, window: window)
        addChildCoordinator(coordinator)
        coordinator.begin()
    }

    private func startDocumentsCoordinator(with userSession: UserSession) {
        let coordinator = DocumentsCoordinator(userSession: userSession, flowDelegate: self, window: window)
        addChildCoordinator(coordinator)
        coordinator.begin()
    }

    // MARK: Helpers
    private let disposeBag = DisposeBag()
    private let tracker: Tracker = FirebaseAnalytics()
    private let database: Database = try! RealmDatabase()
    private let networkManager: NetworkManager = MedicalcNetworkManager(api: NativeAPI())

    private func storeUserSession(_ userSession: UserSession) {
        removeUserSession()
        
        let databaseLogin = LoginDatabaseModel(login: userSession.login)
        database.saveObject(databaseLogin)
    }

    private var restoredUserSession: UserSession? {
        if let login = database.loadObjects(LoginDatabaseModel.self).first?.toDomainModel() {
            return UserSession(login: login)
        }
        return nil
    }

    private func removeUserSession() {
        database.deleteAll(of: LoginDatabaseModel.self)
    }

    private func networkLogout() {
        guard let userSession = restoredUserSession else { return }
        let logout = LogoutNetworkModel(token: userSession.token)
        
        // We care only a little about the result of the network call to /logout
        networkManager
            .logout(logout)
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
}

// MARK: - SeaCatSplashCoordinator implementation
extension AppCoordinator: SeaCatSplashCoordinator {
    func seaCatInitialized() {
        if let userSession = restoredUserSession, SeaCat.ready {
            startDocumentsCoordinator(with: userSession)
        } else {
            runLoginFlow()
        }
    }
}

// MARK: - LoginFlowDelegate implementation
extension AppCoordinator: LoginFlowDelegate {
    func successfulLogin(userSession: UserSession) {
        tracker.track(.login)
        storeUserSession(userSession)
        startDocumentsCoordinator(with: userSession)
    }
}

// MARK: - DocumentsFlowDelegate implementation
extension AppCoordinator: DocumentsFlowDelegate {
    func logout() {
        networkLogout()
        removeUserSession()
        tracker.track(.logout)
        runLoginFlow()
    }
}
