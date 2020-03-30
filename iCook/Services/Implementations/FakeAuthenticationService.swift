//
//  FakeAuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class FakeAuthenticationService: AuthenticationService {
        
    let isAuthenticated = BehaviorSubject(value: true)
    
    func login(email: String, password: String) {
        AppDelegate.logger.trace("Fake login.")
    }
    
    func register(firstName: String, famiyName: String, email: String, password: String) -> Observable<Bool> {
        AppDelegate.logger.trace("Fake registration.")
        return Observable.just(true)
    }
}
