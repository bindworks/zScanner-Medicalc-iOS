//
//  LoginViewModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 20/07/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel {
    
    enum State: Equatable {
        case loading
        case success
        case error(RequestError)
        case awaitingInteraction
    }
 
    //MARK: Instance part
    private let networkManager: NetworkManager
    var loginModel: LoginDomainModel
    
    let usernameField = TextInputField(title: "login.username.title".localized, validator: { !$0.isEmpty })
    let passwordField = ProtectedTextInputField(title: "login.password.title".localized, validator: { !$0.isEmpty })
    
    let status = BehaviorSubject<State>(value: .awaitingInteraction)
    
    var isValid: Observable<Bool>
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.loginModel = LoginDomainModel(username: "", token: "")
        isValid = Observable<Bool>.combineLatest(usernameField.isValid, passwordField.isValid) { (username, password) -> Bool in
            return username && password
        }
    }
    
    //MARK: Interface
    func signin() {
        guard (try? self.status.value()) == .awaitingInteraction else { return }
        
        status.onNext(.loading)

        loginModel.username = usernameField.text.value
        let login = LoginNetworkModel(username: usernameField.text.value, password: passwordField.text.value)

        networkManager
            .login(login)
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .progress:
                    break
                case .success(let token):
                    self?.success(with: token)
                case .error(let error):
                    self?.error(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MAKR: Helpers
    private var disposeBag = DisposeBag()

    private func cleanUp() {
        disposeBag = DisposeBag()
    }
    
    private func success(with token: String) {
        guard (try? status.value()) == .loading else { return }
        
        cleanUp()
    
        loginModel.token = token
        status.onNext(.success)
        status.onCompleted()
    }
    
    private func error(_ error: RequestError) {
        guard (try? status.value()) == .loading else { return }
        
        cleanUp()
        
        status.onNext(.error(error))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.status.onNext(.awaitingInteraction)
        }
    }
}
