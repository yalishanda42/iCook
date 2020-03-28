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
    
    private(set) var isCurrentlyAuthenticated = false
    
    let isAuthenticatedObservable = BehaviorSubject(value: false)
    
    private let apiService: APIService
        
    private let disposeBag = DisposeBag()
    
    init(apiService: APIService) {
        self.apiService = apiService
        
        isAuthenticatedObservable.subscribe(onNext: { [weak self] isAuthenticated in
                self?.isCurrentlyAuthenticated = isAuthenticated
            }, onError: { [weak self] error in
                self?.isCurrentlyAuthenticated = false
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func login(email: String, password: String) {
        apiService.login(email: email, password: password)
            .subscribe(onNext: { [weak self] token in
                        self?.isAuthenticatedObservable.onNext(true)
                    }, onError: { [weak self] error in
                        self?.isAuthenticatedObservable.onNext(false)
                    }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String
    ) -> Observable<Bool> {
        return apiService.register(firstName: firstName, famiyName: famiyName, email: email, password: password)
    }
    
}
