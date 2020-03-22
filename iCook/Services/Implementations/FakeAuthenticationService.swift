//
//  FakeAuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class FakeAuthenticationService: AuthenticationService {
    
    let isAuthenticated = true
    
    func login(email: String, password: String, completion: @escaping CompletionCallback) {
        completion(true, "fake login")
    }
    
    func register(firstName: String, famiyName: String, email: String, password: String, completion: @escaping CompletionCallback) {
        completion(true, "fake register")
    }
}
