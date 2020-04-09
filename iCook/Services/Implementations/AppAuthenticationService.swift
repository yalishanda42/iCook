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
        
    let isAuthenticated = BehaviorSubject(value: false)
    
    private let apiService: APIService
        
    private let disposeBag = DisposeBag()
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func login(email: String, password: String) -> Observable<Bool> {
        let result = apiService.login(email: email, password: password).share()
        result.subscribe(onNext: { [weak self] token in
                    self?.isAuthenticated.onNext(true)
                }, onError: { [weak self] error in
                    self?.isAuthenticated.onNext(false)
                }, onCompleted: nil, onDisposed: nil
            ).disposed(by: disposeBag)
        return result.map { _ in true }
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
