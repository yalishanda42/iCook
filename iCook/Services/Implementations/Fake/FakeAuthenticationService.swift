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
        
    let isAuthenticated: Observable<Bool>
    
    private let isAuthenticatedSubject = BehaviorSubject(value: true)
    
    init() {
        self.isAuthenticated = isAuthenticatedSubject.asObservable()
    }
    
    func login(email: String, password: String) -> Observable<Void> {
        AppDelegate.logger.trace("Fake login.")
        isAuthenticatedSubject.onNext(true)
        return Observable.just(())
    }
    
    func register(firstName: String, famiyName: String, email: String, password: String) -> Observable<Void> {
        AppDelegate.logger.trace("Fake registration.")
        return Observable.just(())
    }
    
    func validateToken() -> Observable<UserData> {
        guard (try? isAuthenticatedSubject.value()) ?? false else {
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
        isAuthenticatedSubject.onNext(false)
        return Observable.just(())
    }
    
    func quickRecommendation() -> Observable<Int> {
        return Observable.just(8888)
    }

    func createRecipe(dishId: Int, steps: String) -> Observable<Void> {
        return Observable.just(())
    }
}
