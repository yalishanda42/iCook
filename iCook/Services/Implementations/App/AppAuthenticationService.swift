//
//  AppAuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class AppAuthenticationService: AuthenticationService {
        
    let isAuthenticated: Observable<Bool>
    
    private let isAuthenticatedSubject = BehaviorSubject(value: false)
    private let bearerToken = BehaviorSubject<APIService.BearerToken?>(value: nil)
    
    private let apiService: APIService
        
    private let disposeBag = DisposeBag()
    
    init(apiService: APIService) {
        self.apiService = apiService
        self.isAuthenticated = isAuthenticatedSubject.asObservable()
        
        bearerToken.map { $0 != nil }.subscribe(isAuthenticatedSubject).disposed(by: disposeBag)
    }
    
    func login(email: String, password: String) -> Observable<Void> {
        let result = apiService.login(email: email, password: password)
        result.subscribe(onNext: { [weak self] token in
                    self?.bearerToken.onNext(token)
                }, onError: { [weak self] error in
                    self?.bearerToken.onNext(nil)
                }, onCompleted: nil, onDisposed: nil
            ).disposed(by: disposeBag)
        return result.map { _ in () }
    }
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String
    ) -> Observable<Bool> {
        return apiService.register(firstName: firstName, famiyName: famiyName, email: email, password: password)
    }
    
    func validateToken() -> Observable<UserData> {
        guard let token = (try? bearerToken.value()) ?? nil else {
            return Observable.error(AuthenticationError.unauthorizedOperation)
        }
        
        return apiService.validateToken(token)
    }
    
    func logout() -> Observable<Void> {
        bearerToken.onNext(nil)
        return Observable.just(())
    }
}
