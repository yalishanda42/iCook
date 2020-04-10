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
    
    func login(email: String, password: String) -> Observable<Void> {
        AppDelegate.logger.trace("Fake login.")
        isAuthenticated.onNext(true)
        return Observable.just(())
    }
    
    func register(firstName: String, famiyName: String, email: String, password: String) -> Observable<Bool> {
        AppDelegate.logger.trace("Fake registration.")
        return Observable.just(true)
    }
    
    func validateToken() -> Observable<UserData> {
        guard (try? isAuthenticated.value()) ?? false else {
            return Observable.error(AuthenticationError.unauthorizedOperation)
        }
        
        return Observable.just(UserData(
            id: 1,
            firstname: "First Name",
            lastname: "Last Name",
            email: "email@example.com"
        ))
    }
    
    func logout() -> Observable<Void> {
        isAuthenticated.onNext(false)
        return Observable.just(())
    }
}
