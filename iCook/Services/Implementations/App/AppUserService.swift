//
//  AppUserService.swift
//  iCook
//
//  Created by Alexander Ignatov on 10.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class AppUserService: UserService {
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func fetchUserData() -> Observable<User> {
        return authenticationService.validateToken().map { $0.asDomainUserModel() }
    }
}
