//
//  AppCoordinator.swift
//  zScanner
//
//  Created by Jakub Skořepa on 29/06/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import SeaCat

class AppCoordinator: Coordinator {
    
    //MARK: - Instance part
    init() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        super.init(window: window, navigationController: nil)
    }

    // MARK: Inteface
    func begin() {
        progress()
    }

    func progress() {
        if (!SeaCat.ready) {
            // If we don't have a SeaCat identity, go to a splash screen to wait to get one
            showSplashScreen()
            return
        }
        
        guard let userSession = restoredUserSession else {
            self.runLoginFlow()
            return
        }

        // We need to have a proper access code
        if userSession.login.access_code == "" {
            self.runLoginFlow()
            return
        }
        
        startDocumentsCoordinator(with: userSession)
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
    private let database: Database = try! RealmDatabase()
    private let tracker: Tracker = FirebaseAnalytics()

    private func storeUserSession(_ userSession: UserSession) {
        database.deleteAll(of: LoginDatabaseModel.self)
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

}

// MARK: - SeaCatSplashCoordinator implementation
extension AppCoordinator: SeaCatSplashCoordinator {
    func seaCatInitialized() {
        progress()
    }
}

// MARK: - LoginFlowDelegate implementation
extension AppCoordinator: LoginFlowDelegate {
    func successfulLogin(userSession: UserSession) {
        tracker.track(.login)
        storeUserSession(userSession)
        progress()
    }
}

// MARK: - DocumentsFlowDelegate implementation
extension AppCoordinator: DocumentsFlowDelegate {
    func logout() {
        removeUserSession()
        tracker.track(.logout)
        progress()
    }
}
