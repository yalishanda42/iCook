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
        
    let isAuthenticated = BehaviorSubject<Bool>(value: false)
    
    private let bearerToken = BehaviorSubject<APIService.BearerToken?>(value: nil)
    
    private let apiService: APIService
        
    private let disposeBag = DisposeBag()
    
    init(apiService: APIService) {
        self.apiService = apiService
        bearerToken.map { $0 != nil }.subscribe(isAuthenticated).disposed(by: disposeBag)
    }
    
    func login(email: String, password: String) -> Observable<Void> {
        let result = apiService.login(email: email, password: password).share()
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
    
}
