//
//  FakeAuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class FakeAuthenticationService: AuthenticationService {
        
    let isAuthenticated: Observable<Bool>
    
    private let isAuthenticatedRelay = BehaviorRelay(value: true)
    
    init() {
        self.isAuthenticated = isAuthenticatedRelay.asObservable()
    }
    
    func login(email: String, password: String) -> Observable<Void> {
        AppDelegate.logger.trace("Fake login.")
        isAuthenticatedRelay.accept(true)
        return Observable.just(())
    }
    
    func register(firstName: String, famiyName: String, email: String, password: String) -> Observable<Void> {
        AppDelegate.logger.trace("Fake registration.")
        return Observable.just(())
    }
    
    func validateToken() -> Observable<UserData> {
        guard isAuthenticatedRelay.value else {
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
        isAuthenticatedRelay.accept(false)
        return Observable.just(())
    }
    
    func quickRecommendation() -> Observable<Int> {
        return Observable.just(8888)
    }

    func createRecipe(dishId: Int, steps: String) -> Observable<Void> {
        return Observable.just(())
    }
}
