//
//  LoginViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func loginCommand(email: String, password: String) {
        authenticationService.login(email: email, password: password) { success, message in
            print(message ?? "Success!")
        }
    }
}
