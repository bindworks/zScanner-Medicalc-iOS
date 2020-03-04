//
//  LoginDatabaseModel.swift
//  zScanner
//
//  Created by Jakub Skořepa on 15/09/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation
import RealmSwift

class LoginDatabaseModel: Object {
    @objc dynamic var username = ""
    @objc dynamic var access_code = ""
    
    convenience init(login: LoginDomainModel) {
        self.init()
        
        self.username = login.username
        self.access_code = login.access_code
    }
}

extension LoginDatabaseModel {
    func toDomainModel() -> LoginDomainModel {
        return LoginDomainModel(username: username, access_code: access_code)
    }
}
