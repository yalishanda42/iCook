//
//  AppAuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class AppAuthenticationService: AuthenticationService {
    
    var isAuthenticated: Bool {
        return token != nil
    }
    
    private let apiService: APIService
    
    private var token: APIService.BearerToken?
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        apiService.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let obtainedToken):
                self?.token = obtainedToken
                completion(true, nil)
            case .failure(let error):
                switch error {
                case .connectionFailure(failureMessage: let message):
                    print(message)
                    completion(false, message)
                case .invalidCredentials(serverMessage: let message):
                    print(message)
                    completion(false, message)
                }
            }
        }
    }
}
